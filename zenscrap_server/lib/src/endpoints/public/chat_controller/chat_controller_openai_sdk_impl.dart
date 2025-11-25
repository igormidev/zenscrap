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
const _playwrightMcpUrl = 'https://mcp-gzws23kw.mcp-as-a-service.com/mcp';
const _playwrightMcpAuthToken =
    'Bearer mnUzM7KEuxtytiOgWvur7MO5rt5HVst6ca-ztJ-bMRg';

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
        return 'gpt-5';
      case AiModel.powerful:
        return 'gpt-5';
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
          'OpenAI streaming failed',
          exception: error,
          level: LogLevel.error,
          stackTrace: stackTrace,
        );
        chatSeason.add(
          ErrorTextResponse(
            role: PromptRole.system,
            errorMessage:
                'An error occurred while contacting OpenAI: $error. Please try again.',
          ),
        );
        rethrow;
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
          'headers': {
            'Authorization': _playwrightMcpAuthToken,
          },
          'require_approval': 'never',
        },
        {
          "type": "mcp",
          "server_label": "scraping_bee",
          "server_url":
              "https://scraping-bee-mcp-production.up.railway.app/sse",
          "require_approval": "never"
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

    await for (final line in lines) {
      if (line.isEmpty || !line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data == '[DONE]') break;

      final Map<String, dynamic> event;
      try {
        event = jsonDecode(data) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }

      final type = event['type'] as String?;
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
          parsedFromCompletion = _extractParsedResponse(response);
        }
      } else if (type == 'error') {
        final message = event['error'] ?? event['message'] ?? data;
        throw Exception(
          'OpenAI streaming error: $message',
        );
      }
    }

    client.close();

    Map<String, dynamic>? parsedJson = parsedFromCompletion;
    parsedJson ??= _tryDecodeJson(jsonBuffer.toString());
    if (parsedJson == null) {
      throw Exception('Failed to parse structured response from OpenAI.');
    }

    final structured = parseStructuredResponse(parsedJson);
    final thinkingSentences = _splitThinking(thinkingBuffer.toString());

    return _OpenAiStreamResult(
      response: structured,
      rawJson: parsedJson,
      thinkingSentences: thinkingSentences,
    );
  }

  Map<String, dynamic>? _extractParsedResponse(
    Map<String, dynamic> response,
  ) {
    final output = response['output'];
    if (output is List && output.isNotEmpty) {
      final first = output.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        if (content is List) {
          for (final item in content) {
            if (item is Map<String, dynamic>) {
              final parsed = item['parsed'] ?? item['json'];
              if (parsed is Map<String, dynamic>) return parsed;
              if (parsed is String) {
                final decoded = _tryDecodeJson(parsed);
                if (decoded != null) return decoded;
              }
            }
          }
        }
      }
    }
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
