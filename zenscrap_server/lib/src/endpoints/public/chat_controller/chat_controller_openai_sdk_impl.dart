import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/openai_prompt_builder.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

const _openAiResponsesUrl = 'https://api.openai.com/v1/responses';

// Playwright MCP server deployed on Railway with ScrapingBee proxy
const _playwrightMcpUrl =
    'https://playwright-mcp-scrapingbee-production.up.railway.app/mcp';

class ChatControllerOpenAiSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  ChatControllerOpenAiSdkImpl._({
    required super.scrappableId,
    required String openAiApiKey,
    required String contextPrompt,
    required String model,
  })  : _openAiApiKey = openAiApiKey,
        _model = model {
    final systemPrompt = buildSystemPrompt();
    _baseMessages.addAll([
      OpenAiMessage(role: 'system', content: systemPrompt),
      OpenAiMessage(role: 'system', content: contextPrompt),
    ]);
  }

  factory ChatControllerOpenAiSdkImpl.startChat({
    required int scrappableId,
    required String openAiApiKey,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? currentFetchSettings,
    AiModel model = AiModel.normal,
  }) {
    final contextPrompt = buildContextPrompt(
      referenceTestData: referenceTestData,
      scrapperRequest: scrapperRequest,
      scrappingBeeLogic: currentFetchSettings,
    );

    return ChatControllerOpenAiSdkImpl._(
      scrappableId: scrappableId,
      openAiApiKey: openAiApiKey,
      contextPrompt: contextPrompt,
      model: _mapModel(model),
    );
  }

  final String _openAiApiKey;
  String _model;

  final List<OpenAiMessage> _baseMessages = [];
  final List<OpenAiMessage> _history = [];

  static String _mapModel(AiModel aiModel) {
    switch (aiModel) {
      case AiModel.normal:
        return 'gpt-5.1';
      case AiModel.powerful:
        return 'gpt-5.1';
    }
  }

  @override
  Future<void> changeModel(AiModel aiModel) async {
    _model = _mapModel(aiModel);
  }

  @override
  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
  }) async {
    var attemptPrompt = userPrompt;

    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final result = await _streamOpenAiResponse(
          session: session,
          userPrompt: attemptPrompt,
          thinkingStream: thinkingStream,
        );

        _history.add(OpenAiMessage(role: 'user', content: attemptPrompt));
        final rawJson = result.rawJson ?? _serializeStructured(result.response);
        _history.add(
          OpenAiMessage(role: 'assistant', content: jsonEncode(rawJson)),
        );

        final retryContent = await handleSendMessage(
          session: session,
          response: result.response,
          referenceTestData: referenceTestData,
          scrapperRequest: scrapperRequest,
          scrappingBeeLogic: scrappingBeeExtractLogic,
          chatSeason: chatSeason,
          attemptNumber: attempt,
          thinkingSentences: result.thinkingSentences,
        );

        if (retryContent == null) {
          return;
        }

        attemptPrompt = retryContent;
      } catch (error, stackTrace) {
        session.log(
          'OpenAI streaming failed (attempt $attempt)',
          exception: error,
          level: LogLevel.error,
          stackTrace: stackTrace,
        );

        // Stream a detailed error message to the user
        final errorMessage = _formatErrorForUser(error);
        chatSeason.add(
          ErrorTextResponse(
            role: PromptRole.system,
            errorMessage: errorMessage,
          ),
        );

        // Stream additional context to the thinking stream
        thinkingStream.add('\n\n[Error] $error\n');

        // Don't rethrow - the error has been communicated to the user
        // The caller will handle cleanup
        return;
      }
    }
  }

  Future<_OpenAiStreamResult> _streamOpenAiResponse({
    required Session session,
    required String userPrompt,
    required StreamController<String> thinkingStream,
  }) async {
    final messages = [
      ..._baseMessages,
      ..._history,
      OpenAiMessage(role: 'user', content: userPrompt),
    ];

    final schema = webScraperResponseJsonSchema;
    final responseFormat = {
      'type': 'json_schema',
      'name': schema['name'],
      'schema': schema['schema'],
      if (schema['strict'] != null) 'strict': schema['strict'],
    };

    final requestBody = {
      'model': _model,
      'stream': true,
      'tools': [
        {
          'type': 'mcp',
          'server_label': 'playwright',
          'server_url': _playwrightMcpUrl,
          'require_approval': 'never',
        },
        {
          'type': 'mcp',
          'server_label': 'scraping_bee',
          'server_url':
              'https://scraping-bee-mcp-production.up.railway.app/mcp',
          'require_approval': 'never'
        }
      ],
      'text': {
        'format': responseFormat,
      },
      'input': messages.map((m) => m.toMap()).toList(),
    };

    final client = http.Client();
    final request = http.Request(
      'POST',
      Uri.parse(_openAiResponsesUrl),
    )
      ..headers.addAll({
        'Authorization': 'Bearer $_openAiApiKey',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode(requestBody);

    final streamedResponse = await client.send(request);
    if (streamedResponse.statusCode != 200) {
      final body = await streamedResponse.stream.bytesToString();
      throw Exception(
        'OpenAI error ${streamedResponse.statusCode}: $body',
      );
    }

    final lines = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final jsonBuffer = StringBuffer();
    final thinkingBuffer = StringBuffer();
    Map<String, dynamic>? parsedFromCompletion;
    final List<String> receivedEventTypes = [];

    await for (final line in lines) {
      if (line.isEmpty || !line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data == '[DONE]') break;

      final Map<String, dynamic> event;
      try {
        event = jsonDecode(data) as Map<String, dynamic>;
      } catch (e) {
        session.log('Failed to parse SSE event: $e, data: $data',
            level: LogLevel.warning);
        continue;
      }

      final type = event['type'] as String?;
      if (type != null && !receivedEventTypes.contains(type)) {
        receivedEventTypes.add(type);
        session.log('Received event type: $type', level: LogLevel.debug);
      }

      if (type == 'response.output_text.delta') {
        final delta = event['delta'];
        if (delta is String) {
          thinkingBuffer.write(delta);
          thinkingStream.add(delta);
        }
      } else if (type == 'response.output_json.delta') {
        final delta = event['delta'];
        if (delta is String) {
          jsonBuffer.write(delta);
        }
      } else if (type == 'response.completed') {
        final response = event['response'];
        if (response is Map<String, dynamic>) {
          parsedFromCompletion = _extractParsedResponse(response, session);
        }
      } else if (type == 'error' || type == 'response.failed') {
        final errorData = event['error'] ?? event['message'] ?? event;
        session.log('OpenAI API error event: $errorData', level: LogLevel.error);
        throw Exception(
          'OpenAI streaming error: $errorData',
        );
      } else if (type != null && type.contains('mcp')) {
        // Handle MCP-related events - stream them as thinking progress
        final mcpInfo = _extractMcpEventInfo(event, type);
        if (mcpInfo.isNotEmpty) {
          thinkingStream.add('\n[MCP] $mcpInfo\n');
          thinkingBuffer.writeln('[MCP] $mcpInfo');
        }
      } else if (type == 'response.reasoning_summary_text.delta') {
        // Stream reasoning summary for thinking models
        final delta = event['delta'];
        if (delta is String) {
          thinkingBuffer.write(delta);
          thinkingStream.add(delta);
        }
      } else if (type == 'response.reasoning_summary_text.done') {
        // Reasoning summary completed
        thinkingStream.add('\n');
        thinkingBuffer.writeln();
      }
    }

    client.close();

    session.log(
        'Stream completed. Event types received: ${receivedEventTypes.join(", ")}',
        level: LogLevel.info);
    session.log(
        'Buffers: jsonBuffer=${jsonBuffer.length} chars, thinkingBuffer=${thinkingBuffer.length} chars',
        level: LogLevel.debug);

    // Try to get JSON from multiple sources in order of preference
    Map<String, dynamic>? parsedJson = parsedFromCompletion;

    // If no parsed JSON from completion event, try the jsonBuffer
    if (parsedJson == null && jsonBuffer.isNotEmpty) {
      parsedJson = _tryDecodeJson(jsonBuffer.toString());
    }

    // If still no JSON, the text output might BE the JSON (when using text.format with json_schema)
    if (parsedJson == null && thinkingBuffer.isNotEmpty) {
      final thinkingContent = thinkingBuffer.toString().trim();
      // Try to find JSON in the thinking buffer - it might have the structured response
      parsedJson = _tryExtractJsonFromText(thinkingContent);
    }

    if (parsedJson == null) {
      final thinkingContent = thinkingBuffer.toString();
      final jsonContent = jsonBuffer.toString();
      session.log('''RAW API RESPONSE - FAILED TO PARSE
Event types: ${receivedEventTypes.join(", ")}
JSON Buffer (${jsonContent.length} chars): ${jsonContent.isEmpty ? "(empty)" : jsonContent.substring(0, jsonContent.length.clamp(0, 500))}
Thinking Buffer (${thinkingContent.length} chars): ${thinkingContent.isEmpty ? "(empty)" : thinkingContent.substring(0, thinkingContent.length.clamp(0, 500))}
''', level: LogLevel.error);
      throw Exception(
          'Failed to parse structured response from OpenAI. Event types: ${receivedEventTypes.join(", ")}. '
          'JSON buffer: ${jsonContent.length} chars, Thinking buffer: ${thinkingContent.length} chars.');
    }

    final structured = parseStructuredResponse(parsedJson);
    final thinkingSentences = _splitThinking(thinkingBuffer.toString());

    return _OpenAiStreamResult(
      response: structured,
      rawJson: parsedJson,
      thinkingSentences: thinkingSentences,
    );
  }

  /// Extracts human-readable info from MCP events for streaming
  String _extractMcpEventInfo(Map<String, dynamic> event, String type) {
    try {
      if (type == 'response.mcp_list_tools.in_progress' ||
          type == 'response.mcp_list_tools') {
        final serverLabel = event['server_label'] ?? 'unknown';
        return 'Discovering tools from $serverLabel...';
      } else if (type == 'response.mcp_call.in_progress' ||
          type == 'response.mcp_call') {
        final item = event['item'] as Map<String, dynamic>?;
        final name = item?['name'] ?? event['name'] ?? 'tool';
        final serverLabel = item?['server_label'] ?? event['server_label'] ?? '';
        return 'Calling $name${serverLabel.isNotEmpty ? " on $serverLabel" : ""}...';
      } else if (type == 'response.mcp_call.completed') {
        final item = event['item'] as Map<String, dynamic>?;
        final name = item?['name'] ?? 'tool';
        return 'Completed $name';
      } else if (type.contains('mcp')) {
        // Generic MCP event
        return 'MCP activity: ${type.replaceAll("response.", "").replaceAll("_", " ")}';
      }
    } catch (e) {
      // Ignore extraction errors
    }
    return '';
  }

  /// Try to extract JSON from text that might contain markdown or other formatting
  Map<String, dynamic>? _tryExtractJsonFromText(String text) {
    // First try direct parsing
    final direct = _tryDecodeJson(text);
    if (direct != null) return direct;

    // Try to find JSON block in markdown code fences
    final jsonBlockRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final match = jsonBlockRegex.firstMatch(text);
    if (match != null) {
      final jsonContent = match.group(1)?.trim();
      if (jsonContent != null) {
        final parsed = _tryDecodeJson(jsonContent);
        if (parsed != null) return parsed;
      }
    }

    // Try to find JSON object pattern in text
    final jsonObjectRegex = RegExp(r'\{[\s\S]*"responseType"[\s\S]*\}');
    final objectMatch = jsonObjectRegex.firstMatch(text);
    if (objectMatch != null) {
      final potentialJson = objectMatch.group(0);
      if (potentialJson != null) {
        final parsed = _tryDecodeJson(potentialJson);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractParsedResponse(
    Map<String, dynamic> response,
    Session session,
  ) {
    // Log the response structure for debugging
    session.log(
        'Extracting parsed response from: ${response.keys.join(", ")}',
        level: LogLevel.debug);

    // Try multiple extraction paths
    final output = response['output'];
    if (output is List && output.isNotEmpty) {
      for (final outputItem in output) {
        if (outputItem is! Map<String, dynamic>) continue;

        // Check for direct text content (when using text.format with json_schema)
        final text = outputItem['text'];
        if (text is String && text.isNotEmpty) {
          final parsed = _tryExtractJsonFromText(text);
          if (parsed != null) {
            session.log('Found JSON in output.text', level: LogLevel.debug);
            return parsed;
          }
        }

        // Check for content array
        final content = outputItem['content'];
        if (content is List) {
          for (final item in content) {
            if (item is! Map<String, dynamic>) continue;

            // Check for parsed field (structured outputs)
            final parsed = item['parsed'] ?? item['json'];
            if (parsed is Map<String, dynamic>) {
              session.log('Found parsed map in content', level: LogLevel.debug);
              return parsed;
            }
            if (parsed is String) {
              final decoded = _tryDecodeJson(parsed);
              if (decoded != null) {
                session.log('Decoded JSON string from parsed field',
                    level: LogLevel.debug);
                return decoded;
              }
            }

            // Check for text field in content items
            final itemText = item['text'];
            if (itemText is String && itemText.isNotEmpty) {
              final decoded = _tryExtractJsonFromText(itemText);
              if (decoded != null) {
                session.log('Found JSON in content.text', level: LogLevel.debug);
                return decoded;
              }
            }
          }
        }
      }
    }

    // Try to extract from the response message directly
    final message = response['message'];
    if (message is Map<String, dynamic>) {
      final content = message['content'];
      if (content is String) {
        final decoded = _tryExtractJsonFromText(content);
        if (decoded != null) {
          session.log('Found JSON in message.content', level: LogLevel.debug);
          return decoded;
        }
      }
    }

    session.log('Could not extract parsed response from completion event',
        level: LogLevel.warning);
    return null;
  }

  Map<String, dynamic>? _serializeStructured(
    WebScrapperChatAIResponse response,
  ) {
    return switch (response) {
      WebScrapperChatAIResponseJustMessage(:final message) => {
          'responseType': 'message',
          'message': message,
        },
      WebScrapperChatAIResponseErrorMessage(:final errorDescription) => {
          'responseType': 'error',
          'errorMessage': errorDescription,
        },
      WebScrapperChatAIResponseOnlyExtractRulesModified(
        :final resumeActionMessage,
        :final fetchSettings,
      ) =>
        {
          'responseType': 'data',
          'resumeActionMessage': resumeActionMessage,
          'scrappingBeeFetchSettings': fetchSettings.toMap(),
        },
      WebScrapperChatAIResponseOnlyRequestModified(
        :final resumeActionMessage,
        :final scrappableRequest,
      ) =>
        {
          'responseType': 'data',
          'resumeActionMessage': resumeActionMessage,
          'scrappableRequest': scrappableRequest.toMap(),
        },
      WebScrapperChatAIResponseBothModified(
        :final resumeActionMessage,
        :final fetchSettings,
        :final scrappableRequest,
      ) =>
        {
          'responseType': 'data',
          'resumeActionMessage': resumeActionMessage,
          'scrappingBeeFetchSettings': fetchSettings.toMap(),
          'scrappableRequest': scrappableRequest.toMap(),
        },
    };
  }

  Map<String, dynamic>? _tryDecodeJson(String? source) {
    if (source == null || source.isEmpty) return null;
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      return null;
    }
    return null;
  }

  List<String> _splitThinking(String content) {
    if (content.isEmpty) return const [];
    return content
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Formats an error into a user-friendly message
  String _formatErrorForUser(Object error) {
    final errorStr = error.toString();

    // Check for common error patterns and provide helpful messages
    if (errorStr.contains('Failed to parse structured response')) {
      return 'The AI model returned an unexpected response format. '
          'This can happen when the model is processing complex requests with multiple tool calls. '
          'Please try again with a simpler request, or contact support if the issue persists.\n\n'
          'Technical details: $errorStr';
    }

    if (errorStr.contains('OpenAI error 4')) {
      // 4xx errors
      if (errorStr.contains('401')) {
        return 'Authentication error with OpenAI API. Please check the API key configuration.';
      }
      if (errorStr.contains('429')) {
        return 'Rate limit exceeded. Please wait a moment and try again.';
      }
      if (errorStr.contains('400')) {
        return 'Invalid request to OpenAI API. This might be a configuration issue. '
            'Technical details: $errorStr';
      }
      return 'OpenAI API error: $errorStr';
    }

    if (errorStr.contains('OpenAI error 5')) {
      // 5xx errors
      return 'OpenAI service is temporarily unavailable. Please try again in a few moments.';
    }

    if (errorStr.contains('OpenAI streaming error')) {
      return 'An error occurred while streaming the AI response: $errorStr';
    }

    if (errorStr.contains('SocketException') ||
        errorStr.contains('Connection')) {
      return 'Network connection error. Please check your internet connection and try again.';
    }

    // Default error message
    return 'An error occurred while processing your request: $errorStr\n\n'
        'Please try again. If the issue persists, try simplifying your request.';
  }
}

class OpenAiMessage {
  final String role;
  final String content;

  OpenAiMessage({
    required this.role,
    required this.content,
  });

  Map<String, String> toMap() => {'role': role, 'content': content};
}

class _OpenAiStreamResult {
  final WebScrapperChatAIResponse response;
  final Map<String, dynamic>? rawJson;
  final List<String> thinkingSentences;

  _OpenAiStreamResult({
    required this.response,
    required this.rawJson,
    required this.thinkingSentences,
  });
}
