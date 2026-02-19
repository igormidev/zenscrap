import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/auto_fix/auto_fix_session_handler.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/openai_prompt_builder.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

const _openAiResponsesUrl = 'https://api.openai.com/v1/responses';
const _openAiFilesUrl = 'https://api.openai.com/v1/files';
const _openAiVectorStoresUrl = 'https://api.openai.com/v1/vector_stores';

const _maxSendMessageAttempts = 3;
const _historyNormalTokenBudget = 70000;
const _historyAggressiveTokenBudget = 30000;

/// Exception thrown when the OpenAI API returns an `insufficient_quota` error.
/// This means the API key being used has run out of credits on OpenAI's side.
///
/// OpenAI error response:
/// ```json
/// {
///   "error": {
///     "message": "You exceeded your current quota, please check your plan and billing details.",
///     "type": "insufficient_quota",
///     "param": null,
///     "code": "insufficient_quota"
///   }
/// }
/// ```
class OpenAiQuotaExceededException implements Exception {
  /// The original error message from OpenAI
  final String openAiErrorMessage;

  /// The HTTP status code (typically 429)
  final int statusCode;

  const OpenAiQuotaExceededException({
    required this.openAiErrorMessage,
    required this.statusCode,
  });

  @override
  String toString() =>
      'OpenAiQuotaExceededException: $openAiErrorMessage (HTTP $statusCode)';
}

// Playwright MCP server deployed on Railway with ScrapingBee proxy
const _playwrightMcpUrl =
    'https://playwright-mcp-scrapingbee-production.up.railway.app/mcp';

// ScrapingBee MCP server deployed on Railway
const _scrapingBeeMcpUrl =
    'https://scraping-bee-mcp-production.up.railway.app/mcp';

class ChatControllerOpenAiSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  ChatControllerOpenAiSdkImpl._({
    required super.scrappableId,
    required String openAiApiKey,
    required String contextPrompt,
    required String extractionRulesGuide,
    required String model,
  }) : _openAiApiKey = openAiApiKey,
       _model = model {
    // ScrapingBee API key is now configured server-side in the MCP,
    // so we don't need to pass it in the prompt anymore
    final systemPrompt = buildSystemPrompt();
    _baseMessages.addAll([
      OpenAiMessage(role: 'system', content: systemPrompt),
      OpenAiMessage(role: 'system', content: contextPrompt),
      // Session-specific extraction rules guide is included as inline system message
      // instead of a file upload, since the Responses API's input_file only supports PDFs.
      // The file_search tool will be used to search the static documentation in the Vector Store.
      OpenAiMessage(role: 'system', content: extractionRulesGuide),
    ]);
  }

  /// Initializes the Vector Store with static documentation files.
  /// Should be called once at server startup.
  ///
  /// This creates a global Vector Store containing:
  /// - cost_optimization_guide.md
  /// - how_to_edit_scrappable_request.md
  /// - scrappable_request_structure_guide.md
  ///
  /// The file_search tool will be used to search these documents during chat sessions.
  static Future<void> init({required String openAiApiKey}) async {
    if (OpenAiFileManager.isInitialized) {
      return; // Already initialized
    }

    // Step 1: Upload files with purpose "assistants" (required for Vector Store)
    final costOptId = await _uploadFileForVectorStore(
      apiKey: openAiApiKey,
      filename: 'cost_optimization_guide.md',
      content: costOptimizationGuide,
    );

    final editRequestId = await _uploadFileForVectorStore(
      apiKey: openAiApiKey,
      filename: 'how_to_edit_scrappable_request.md',
      content: howToEditScrappableRequest,
    );

    final structureGuideId = await _uploadFileForVectorStore(
      apiKey: openAiApiKey,
      filename: 'scrappable_request_structure_guide.md',
      content: scrappableRequestStructureGuide,
    );

    // Step 2: Create Vector Store
    final vectorStoreId = await _createVectorStore(
      apiKey: openAiApiKey,
      name: 'zenscrap-static-docs',
    );

    // Step 3: Add files to Vector Store
    final fileIds = [costOptId, editRequestId, structureGuideId];
    for (final fileId in fileIds) {
      await _addFileToVectorStore(
        apiKey: openAiApiKey,
        vectorStoreId: vectorStoreId,
        fileId: fileId,
      );
    }

    // Step 4: Wait for all files to be processed
    await _waitForVectorStoreFilesReady(
      apiKey: openAiApiKey,
      vectorStoreId: vectorStoreId,
      expectedFileCount: fileIds.length,
    );

    // Store IDs for use in chat sessions
    OpenAiFileManager.setVectorStoreData(
      vectorStoreId: vectorStoreId,
      costOptimizationFileId: costOptId,
      howToEditRequestFileId: editRequestId,
      requestStructureGuideFileId: structureGuideId,
    );

    // ignore: avoid_print
    print('[Zenscrap] OpenAI Vector Store initialized successfully');
  }

  /// Uploads a file to OpenAI with purpose "assistants" for Vector Store use.
  /// This enables .md, .txt, .json and other text files to be used with file_search.
  static Future<String> _uploadFileForVectorStore({
    required String apiKey,
    required String filename,
    required String content,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(_openAiFilesUrl))
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['purpose'] =
          'assistants' // Required for Vector Store
      ..files.add(
        http.MultipartFile.fromString('file', content, filename: filename),
      );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to upload file $filename: ${response.statusCode} - $responseBody',
      );
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return json['id'] as String;
  }

  /// Creates a new Vector Store.
  static Future<String> _createVectorStore({
    required String apiKey,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse(_openAiVectorStoresUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to create Vector Store: ${response.statusCode} - ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['id'] as String;
  }

  /// Adds a file to a Vector Store.
  static Future<void> _addFileToVectorStore({
    required String apiKey,
    required String vectorStoreId,
    required String fileId,
  }) async {
    final response = await http.post(
      Uri.parse('$_openAiVectorStoresUrl/$vectorStoreId/files'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode({'file_id': fileId}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to add file $fileId to Vector Store: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Waits for all files in the Vector Store to be processed.
  /// Files need to be chunked and embedded before they can be searched.
  static Future<void> _waitForVectorStoreFilesReady({
    required String apiKey,
    required String vectorStoreId,
    required int expectedFileCount,
    int maxAttempts = 30,
    Duration pollInterval = const Duration(seconds: 2),
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final response = await http.get(
        Uri.parse('$_openAiVectorStoresUrl/$vectorStoreId/files'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to check Vector Store files: ${response.statusCode} - ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>? ?? [];

      // Count files by status
      var completedCount = 0;
      var failedCount = 0;

      for (final file in data) {
        final status = (file as Map<String, dynamic>)['status'] as String?;
        switch (status) {
          case 'completed':
            completedCount++;
            break;
          case 'failed':
          case 'cancelled':
            failedCount++;
            break;
          // 'in_progress' and other statuses are ignored - we just wait
        }
      }

      // Check if all files are ready
      if (completedCount >= expectedFileCount) {
        return; // All files processed successfully
      }

      if (failedCount > 0) {
        throw Exception(
          'Some files failed to process in Vector Store: $failedCount failed',
        );
      }

      // Still processing, wait and retry
      await Future<void>.delayed(pollInterval);
    }

    throw Exception(
      'Timeout waiting for Vector Store files to be ready after $maxAttempts attempts',
    );
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

    // Build the extraction rules guide specific to this session's parameters
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      queryParam: scrapperRequest.queryParams,
      queryParamsNotRelatedToUrl: scrapperRequest.queryParamsNotRelatedToUrl,
      pathParams: scrapperRequest.pathParams,
    );
    final extractionRulesGuide = buildExtractionRulesGuide(webScrapperRequest);

    return ChatControllerOpenAiSdkImpl._(
      scrappableId: scrappableId,
      openAiApiKey: openAiApiKey,
      contextPrompt: contextPrompt,
      extractionRulesGuide: extractionRulesGuide,
      model: _mapModel(model),
    );
  }

  final String _openAiApiKey;
  String _model;

  final List<OpenAiMessage> _baseMessages = [];
  final List<OpenAiMessage> _history = [];

  static String _mapModel(AiModel aiModel) {
    return getModelName(aiModel);
  }

  /// Returns max_output_tokens limit for the current model.
  /// Mini models have a 128k limit; full models have higher limits.
  int? get _maxOutputTokens {
    switch (_model) {
      case 'gpt-5-mini':
        // GPT-5-mini supports up to 128,000 output tokens
        // Setting this explicitly prevents truncation issues
        return 128000;
      default:
        // Full models have higher limits, let the API use defaults
        return null;
    }
  }

  /// Returns reasoning effort for the current model.
  /// Powerful tier gets xhigh, normal tier stays high.
  String get _reasoningEffort {
    switch (_model) {
      case 'gpt-5.2-pro':
        return 'xhigh';
      default:
        return 'high';
    }
  }

  @override
  Future<void> changeModel(AiModel aiModel) async {
    _model = _mapModel(aiModel);
  }

  @override
  Future<void> dispose() async {
    // No session-specific cleanup needed.
    // The extraction rules guide is now included as an inline system message,
    // and the Vector Store with static docs is shared across all sessions.
  }

  @override
  Future<SendMessageResult> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
    required SupportedLanguage language,
  }) async {
    final originalUserPrompt = userPrompt;
    var attemptPrompt = userPrompt;
    var attempt = 1;
    var didContextOverflowRecovery = false;

    // Track total cost across all retry attempts
    var totalInputTokens = 0;
    var totalOutputTokens = 0;
    var totalReasoningTokens = 0;
    var totalCostUsd = 0.0;

    while (attempt <= _maxSendMessageAttempts) {
      try {
        final result = await _streamOpenAiResponse(
          session: session,
          userPrompt: attemptPrompt,
          thinkingStream: thinkingStream,
        );

        // Accumulate token usage from this attempt
        totalInputTokens += result.usage.inputTokens;
        totalOutputTokens += result.usage.outputTokens;
        totalReasoningTokens += result.usage.reasoningTokens;
        totalCostUsd += _calculateCostUsd(result.usage);

        if (result.validationReason != null) {
          final reason = result.validationReason!;
          final reasonCode = reason.code;
          final rawValidationError = result.validationErrorDescription ?? 'n/a';

          session.log(
            'Structured response validation failed on attempt $attempt/$_maxSendMessageAttempts: '
            'reason=$reasonCode, detail="$rawValidationError"',
            level: LogLevel.warning,
          );

          if (attempt < _maxSendMessageAttempts) {
            attemptPrompt = buildSchemaRepairRetryPrompt(
              reason: reason,
              invalidResponse: result.rawJson,
              originalUserPrompt: originalUserPrompt,
              attemptNumber: attempt + 1,
            );

            thinkingStream.add(
              '\n[System] Retrying due to invalid response format ($reasonCode)...\n',
            );
            attempt++;
            continue;
          }

          session.log(
            'Structured response validation retries exhausted: reason=$reasonCode',
            level: LogLevel.error,
          );

          chatSeason.add(
            ErrorTextResponse(
              role: PromptRole.system,
              expectsFollowUp: false,
              errorMessage: getErrorDescription('chat_parse_error', language),
            ),
          );

          return SendMessageResult(
            costInUsd: totalCostUsd,
            inputTokens: totalInputTokens,
            outputTokens: totalOutputTokens,
            reasoningTokens: totalReasoningTokens,
          );
        }

        final retryContent = await handleSendMessage(
          session: session,
          response: result.response,
          referenceTestData: referenceTestData,
          scrapperRequest: scrapperRequest,
          scrappingBeeLogic: scrappingBeeExtractLogic,
          chatSeason: chatSeason,
          attemptNumber: attempt,
          thinkingSentences: result.thinkingSentences,
          language: language,
        );

        if (retryContent == null) {
          _appendStableTurnToHistory(
            originalUserPrompt: originalUserPrompt,
            response: result.response,
            rawJson: result.rawJson,
          );

          // Success - return accumulated cost
          session.log(
            'Message completed. Total cost: \$$totalCostUsd (input: $totalInputTokens, output: $totalOutputTokens, reasoning: $totalReasoningTokens)',
            level: LogLevel.info,
          );
          return SendMessageResult(
            costInUsd: totalCostUsd,
            inputTokens: totalInputTokens,
            outputTokens: totalOutputTokens,
            reasoningTokens: totalReasoningTokens,
          );
        }

        attemptPrompt = retryContent;
        attempt++;
      } catch (error, stackTrace) {
        if (_isContextLengthExceededError(error) &&
            !didContextOverflowRecovery) {
          didContextOverflowRecovery = true;
          final trimResult = _trimHistoryForBudget(
            session: session,
            pendingUserPrompt: attemptPrompt,
            aggressive: true,
            reason: 'context_length_exceeded',
          );
          session.log(
            'OpenAI context overflow detected. '
            'Retrying once after aggressive trim. '
            'droppedTurns=${trimResult.droppedTurns}, '
            'droppedMessages=${trimResult.droppedMessages}, '
            'estimatedTokensBefore=${trimResult.estimatedTokensBefore}, '
            'estimatedTokensAfter=${trimResult.estimatedTokensAfter}',
            level: LogLevel.warning,
          );
          thinkingStream.add(
            '\n[System] Context was trimmed after overflow. Retrying...\n',
          );
          continue;
        }

        session.log(
          'OpenAI streaming failed (attempt $attempt)',
          exception: error,
          level: LogLevel.error,
          stackTrace: stackTrace,
        );

        // Stream a typed error message to the user
        final errorMessage = _formatErrorForUser(
          error: error,
          language: language,
          session: session,
        );
        chatSeason.add(
          ErrorTextResponse(
            role: PromptRole.system,
            expectsFollowUp: false, // Terminal error, no follow-up
            errorMessage: errorMessage,
          ),
        );

        // Stream additional context to the thinking stream
        thinkingStream.add('\n\n[Error] $error\n');

        // Don't rethrow - the error has been communicated to the user
        // Return accumulated cost even on error
        return SendMessageResult(
          costInUsd: totalCostUsd,
          inputTokens: totalInputTokens,
          outputTokens: totalOutputTokens,
          reasoningTokens: totalReasoningTokens,
        );
      }
    }

    // Exhausted all retries, return accumulated cost
    return SendMessageResult(
      costInUsd: totalCostUsd,
      inputTokens: totalInputTokens,
      outputTokens: totalOutputTokens,
      reasoningTokens: totalReasoningTokens,
    );
  }

  void _appendStableTurnToHistory({
    required String originalUserPrompt,
    required WebScrapperChatAIResponse response,
    required Map<String, dynamic>? rawJson,
  }) {
    _history.add(OpenAiMessage(role: 'user', content: originalUserPrompt));
    final serialized = rawJson ?? _serializeStructured(response);
    _history.add(
      OpenAiMessage(role: 'assistant', content: jsonEncode(serialized)),
    );
  }

  bool _isContextLengthExceededError(Object error) {
    final lower = error.toString().toLowerCase();
    return lower.contains('context_length_exceeded') ||
        (lower.contains('context') && lower.contains('length'));
  }

  _HistoryTrimResult _trimHistoryForBudget({
    required Session session,
    required String pendingUserPrompt,
    required String reason,
    bool aggressive = false,
  }) {
    final budget = aggressive
        ? _historyAggressiveTokenBudget
        : _historyNormalTokenBudget;
    final before = _estimateTokensForMessages([
      ..._baseMessages,
      ..._history,
      OpenAiMessage(role: 'user', content: pendingUserPrompt),
    ]);

    if (before <= budget || _history.isEmpty) {
      return _HistoryTrimResult(
        droppedMessages: 0,
        droppedTurns: 0,
        estimatedTokensBefore: before,
        estimatedTokensAfter: before,
      );
    }

    var droppedMessages = 0;
    var droppedTurns = 0;
    var estimated = before;

    while (estimated > budget && _history.isNotEmpty) {
      final canDropTurn =
          _history.length >= 2 &&
          _history.first.role == 'user' &&
          _history[1].role == 'assistant';
      if (canDropTurn) {
        _history.removeAt(0);
        _history.removeAt(0);
        droppedMessages += 2;
        droppedTurns++;
      } else {
        _history.removeAt(0);
        droppedMessages++;
      }

      estimated = _estimateTokensForMessages([
        ..._baseMessages,
        ..._history,
        OpenAiMessage(role: 'user', content: pendingUserPrompt),
      ]);
    }

    final after = estimated;
    session.log(
      'Trimmed chat history for $reason. '
      'droppedTurns=$droppedTurns, '
      'droppedMessages=$droppedMessages, '
      'estimatedTokensBefore=$before, '
      'estimatedTokensAfter=$after, '
      'estimatedReduction=${before - after}',
      level: LogLevel.info,
    );

    return _HistoryTrimResult(
      droppedMessages: droppedMessages,
      droppedTurns: droppedTurns,
      estimatedTokensBefore: before,
      estimatedTokensAfter: after,
    );
  }

  int _estimateTokensForMessages(List<OpenAiMessage> messages) {
    var total = 0;
    for (final message in messages) {
      total += 8; // per-message framing overhead
      total += _estimateTokensForContent(message.role);
      total += _estimateTokensForContent(message.content);
    }
    return total;
  }

  int _estimateTokensForContent(String content) {
    if (content.isEmpty) return 0;
    return (content.length / 4).ceil();
  }

  /// Calculates the cost in USD for a given token usage based on the current model
  double _calculateCostUsd(_TokenUsage usage) {
    final double inputPricePerMillion;
    final double outputPricePerMillion;

    // Get pricing based on model
    switch (_model) {
      case 'gpt-5.2':
        inputPricePerMillion = kGpt52InputPricePerMillionTokens;
        outputPricePerMillion = kGpt52OutputPricePerMillionTokens;
        break;
      case 'gpt-5.2-pro':
        inputPricePerMillion = kGpt52ProInputPricePerMillionTokens;
        outputPricePerMillion = kGpt52ProOutputPricePerMillionTokens;
        break;
      case 'gpt-5-mini':
        inputPricePerMillion = kGpt5MiniInputPricePerMillionTokens;
        outputPricePerMillion = kGpt5MiniOutputPricePerMillionTokens;
        break;
      case 'gpt-5.1':
        inputPricePerMillion = kGpt51InputPricePerMillionTokens;
        outputPricePerMillion = kGpt51OutputPricePerMillionTokens;
        break;
      default:
        // Default to GPT-5.2 pricing.
        inputPricePerMillion = kGpt52InputPricePerMillionTokens;
        outputPricePerMillion = kGpt52OutputPricePerMillionTokens;
        break;
    }

    // Calculate cost: (tokens / 1,000,000) * price_per_million
    final inputCost = (usage.inputTokens / 1000000.0) * inputPricePerMillion;
    final outputCost = (usage.outputTokens / 1000000.0) * outputPricePerMillion;

    return inputCost + outputCost;
  }

  Future<_OpenAiStreamResult> _streamOpenAiResponse({
    required Session session,
    required String userPrompt,
    required StreamController<String> thinkingStream,
  }) async {
    _trimHistoryForBudget(
      session: session,
      pendingUserPrompt: userPrompt,
      reason: 'pre_request',
    );

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

    // Build input messages (no more input_file - using file_search instead)
    final input = messages.map((msg) => msg.toMap()).toList();

    // Get MCP API key from Serverpod passwords (configured via scloud secrets)
    final mcpApiKey = session.passwords['mcpApiKey'];
    if (mcpApiKey == null || mcpApiKey.isEmpty) {
      throw Exception('MCP API key not configured in Serverpod passwords');
    }

    // Build tools array with file_search for Vector Store documentation
    final tools = <Map<String, dynamic>>[
      // MCP tools for web scraping (authenticated with X-API-KEY header)
      {
        'type': 'mcp',
        'server_label': 'playwright',
        'server_url': _playwrightMcpUrl,
        'headers': {'X-API-KEY': mcpApiKey},
        'require_approval': 'never',
      },
      {
        'type': 'mcp',
        'server_label': 'scraping_bee',
        'server_url': _scrapingBeeMcpUrl,
        'headers': {'X-API-KEY': mcpApiKey},
        'require_approval': 'never',
      },
    ];

    // Add file_search tool if Vector Store is initialized
    // This allows the model to search the static documentation files
    // (.md files that couldn't be used with input_file)
    final vectorStoreId = OpenAiFileManager.vectorStoreId;
    if (vectorStoreId != null) {
      tools.add({
        'type': 'file_search',
        'vector_store_ids': [vectorStoreId],
        'max_num_results': 10,
      });
    }

    // Add web_search tool to allow the model to search the web for documentation
    // This is especially useful when the model is unsure about ScrapingBee API details
    // or needs to verify extract_rules syntax from official documentation
    tools.add({
      'type': 'web_search',
      'search_context_size': 'medium', // Balance between quality and cost
    });

    final requestBody = {
      'model': _model,
      'stream': true,
      'reasoning': {'effort': _reasoningEffort},
      'tools': tools,
      'text': {'format': responseFormat},
      'input': input,
      // Set max_output_tokens for mini models to prevent truncation
      if (_maxOutputTokens != null) 'max_output_tokens': _maxOutputTokens,
    };

    session.log(
      'OpenAI request config: model=$_model, reasoningEffort=$_reasoningEffort, '
      'maxOutputTokens=${_maxOutputTokens ?? "default"}',
      level: LogLevel.debug,
    );

    final client = http.Client();
    final jsonBuffer = StringBuffer();
    final thinkingBuffer = StringBuffer();
    Map<String, dynamic>? parsedFromCompletion;
    var tokenUsage = _TokenUsage.zero;
    final List<String> receivedEventTypes = [];

    try {
      final request = http.Request('POST', Uri.parse(_openAiResponsesUrl))
        ..headers.addAll({
          'Authorization': 'Bearer $_openAiApiKey',
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode(requestBody);

      final streamedResponse = await client.send(request);
      if (streamedResponse.statusCode != 200) {
        final body = await streamedResponse.stream.bytesToString();
        final bodyPreview = body.length > 1200
            ? '${body.substring(0, 1200)}...[truncated]'
            : body;
        session.log(
          'OpenAI non-200 response: status=${streamedResponse.statusCode}, body=$bodyPreview',
          level: LogLevel.error,
        );

        // Check for insufficient_quota error (HTTP 429 with specific error code)
        if (streamedResponse.statusCode == 429) {
          try {
            final errorJson = jsonDecode(body) as Map<String, dynamic>;
            final error = errorJson['error'] as Map<String, dynamic>?;
            final errorCode = error?['code'] as String?;
            final errorMessage =
                error?['message'] as String? ?? 'Unknown quota error';

            if (errorCode == 'insufficient_quota') {
              throw OpenAiQuotaExceededException(
                openAiErrorMessage: errorMessage,
                statusCode: streamedResponse.statusCode,
              );
            }
          } catch (e) {
            if (e is OpenAiQuotaExceededException) rethrow;
            // If parsing fails, check for quota-related keywords in the body
            if (body.contains('insufficient_quota') ||
                body.contains('exceeded your current quota')) {
              throw OpenAiQuotaExceededException(
                openAiErrorMessage: body,
                statusCode: streamedResponse.statusCode,
              );
            }
          }
        }

        throw Exception('OpenAI error ${streamedResponse.statusCode}: $body');
      }

      final lines = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in lines) {
        if (line.isEmpty || !line.startsWith('data:')) continue;
        final data = line.substring(5).trim();
        if (data == '[DONE]') break;

        final Map<String, dynamic> event;
        try {
          event = jsonDecode(data) as Map<String, dynamic>;
        } catch (e) {
          session.log(
            'Failed to parse SSE event: $e, data: $data',
            level: LogLevel.warning,
          );
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
            // Extract usage information from the completed response
            final usage = response['usage'] as Map<String, dynamic>?;
            tokenUsage = _TokenUsage.fromJson(usage);
            session.log(
              'Token usage - input: ${tokenUsage.inputTokens}, output: ${tokenUsage.outputTokens}, reasoning: ${tokenUsage.reasoningTokens}',
              level: LogLevel.info,
            );
          }
        } else if (type == 'error' || type == 'response.failed') {
          final errorData = event['error'] ?? event['message'] ?? event;
          session.log(
            'OpenAI API error event: $errorData',
            level: LogLevel.error,
          );

          // Check for insufficient_quota error in streaming events
          if (errorData is Map<String, dynamic>) {
            final errorCode = errorData['code'] as String?;
            final errorMessage =
                errorData['message'] as String? ?? 'Unknown quota error';
            if (errorCode == 'insufficient_quota') {
              throw OpenAiQuotaExceededException(
                openAiErrorMessage: errorMessage,
                statusCode: 429,
              );
            }
          } else if (errorData.toString().contains('insufficient_quota') ||
              errorData.toString().contains('exceeded your current quota')) {
            throw OpenAiQuotaExceededException(
              openAiErrorMessage: errorData.toString(),
              statusCode: 429,
            );
          }

          throw Exception('OpenAI streaming error: $errorData');
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
        } else if (type != null && type.contains('web_search')) {
          // Handle web_search events - stream them as thinking progress
          final webSearchInfo = _extractWebSearchEventInfo(event, type);
          if (webSearchInfo.isNotEmpty) {
            thinkingStream.add('\n[Web Search] $webSearchInfo\n');
            thinkingBuffer.writeln('[Web Search] $webSearchInfo');
          }
        }
      }
    } finally {
      client.close();
    }

    session.log(
      'Stream completed. Event types received: ${receivedEventTypes.join(", ")}',
      level: LogLevel.info,
    );
    session.log(
      'Buffers: jsonBuffer=${jsonBuffer.length} chars, thinkingBuffer=${thinkingBuffer.length} chars',
      level: LogLevel.debug,
    );

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
        'JSON buffer: ${jsonContent.length} chars, Thinking buffer: ${thinkingContent.length} chars.',
      );
    }

    final parseResult = parseStructuredResponseWithValidation(parsedJson);
    final validationErrorDescription =
        parseResult.response is WebScrapperChatAIResponseErrorMessage
        ? (parseResult.response as WebScrapperChatAIResponseErrorMessage)
              .errorDescription
        : null;
    final thinkingSentences = _splitThinking(thinkingBuffer.toString());

    return _OpenAiStreamResult(
      response: parseResult.response,
      rawJson: parsedJson,
      thinkingSentences: thinkingSentences,
      usage: tokenUsage,
      validationReason: parseResult.validationReason,
      validationErrorDescription: validationErrorDescription,
    );
  }

  /// Extracts human-readable info from web_search events for streaming
  String _extractWebSearchEventInfo(Map<String, dynamic> event, String type) {
    try {
      if (type == 'response.web_search_call.in_progress' ||
          type == 'response.web_search_call') {
        return '🔍 Searching the web...';
      } else if (type == 'response.web_search_call.searching') {
        final item = event['item'] as Map<String, dynamic>?;
        final query = item?['query'] ?? event['query'];
        if (query != null) {
          return '🔍 Searching for: "$query"';
        }
        return '🔍 Searching...';
      } else if (type == 'response.web_search_call.completed') {
        final item = event['item'] as Map<String, dynamic>?;
        final status = item?['status'] ?? 'completed';
        return '✅ Web search $status';
      } else if (type == 'response.web_search_call.failed') {
        final item = event['item'] as Map<String, dynamic>?;
        final error = item?['error'] ?? event['error'] ?? 'Unknown error';
        return '❌ Web search failed: $error';
      } else if (type.contains('web_search')) {
        return 'Web search activity: ${type.replaceAll("response.", "").replaceAll("_", " ")}';
      }
    } catch (e) {
      return 'Web search event parsing error: $e';
    }
    return '';
  }

  /// Extracts human-readable info from MCP events for streaming
  String _extractMcpEventInfo(Map<String, dynamic> event, String type) {
    try {
      if (type == 'response.mcp_list_tools.in_progress' ||
          type == 'response.mcp_list_tools') {
        final serverLabel = event['server_label'] ?? 'unknown';
        return 'Discovering tools from $serverLabel...';
      } else if (type == 'response.mcp_list_tools.completed') {
        final serverLabel = event['server_label'] ?? 'unknown';
        final item = event['item'] as Map<String, dynamic>?;
        final tools = item?['tools'] as List?;
        final toolCount = tools?.length ?? 0;
        return 'Discovered $toolCount tools from $serverLabel';
      } else if (type == 'response.mcp_call.in_progress' ||
          type == 'response.mcp_call') {
        final item = event['item'] as Map<String, dynamic>?;
        final name = item?['name'] ?? event['name'] ?? 'tool';
        final serverLabel =
            item?['server_label'] ?? event['server_label'] ?? '';
        final arguments = item?['arguments'] ?? event['arguments'];
        if (arguments != null) {
          final argsStr = arguments.toString();
          final truncatedArgs = argsStr.length > 200
              ? '${argsStr.substring(0, 200)}...'
              : argsStr;
          return 'Calling $name${serverLabel.isNotEmpty ? " on $serverLabel" : ""} with: $truncatedArgs';
        }
        return 'Calling $name${serverLabel.isNotEmpty ? " on $serverLabel" : ""}...';
      } else if (type == 'response.mcp_call.completed') {
        final item = event['item'] as Map<String, dynamic>?;
        final name = item?['name'] ?? 'tool';
        final serverLabel = item?['server_label'] ?? '';

        // Extract the actual output from the MCP call
        final output = item?['output'] as List?;
        if (output != null && output.isNotEmpty) {
          final buffer = StringBuffer();
          buffer.writeln(
            '✅ $name completed${serverLabel.isNotEmpty ? " ($serverLabel)" : ""}:',
          );

          for (final outputItem in output) {
            if (outputItem is Map<String, dynamic>) {
              final outputType = outputItem['type'];
              if (outputType == 'text') {
                final text = outputItem['text'] as String? ?? '';
                // Truncate long outputs but show enough to understand the result
                final truncatedText = text.length > 1500
                    ? '${text.substring(0, 1500)}...[truncated]'
                    : text;
                buffer.writeln(truncatedText);
              }
            }
          }
          return buffer.toString();
        }
        return '✅ $name completed${serverLabel.isNotEmpty ? " ($serverLabel)" : ""}';
      } else if (type == 'response.mcp_call.failed') {
        final item = event['item'] as Map<String, dynamic>?;
        final name = item?['name'] ?? 'tool';
        final serverLabel = item?['server_label'] ?? '';

        // Extract error information
        final error = item?['error'] ?? event['error'];
        final errorMessage = error is Map
            ? (error['message'] ?? error.toString())
            : (error?.toString() ?? 'Unknown error');

        return '❌ $name FAILED${serverLabel.isNotEmpty ? " ($serverLabel)" : ""}: $errorMessage';
      } else if (type.contains('mcp')) {
        // Generic MCP event
        return 'MCP activity: ${type.replaceAll("response.", "").replaceAll("_", " ")}';
      }
    } catch (e) {
      // Log extraction errors for debugging
      return 'MCP event parsing error: $e';
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
      level: LogLevel.debug,
    );

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
                session.log(
                  'Decoded JSON string from parsed field',
                  level: LogLevel.debug,
                );
                return decoded;
              }
            }

            // Check for text field in content items
            final itemText = item['text'];
            if (itemText is String && itemText.isNotEmpty) {
              final decoded = _tryExtractJsonFromText(itemText);
              if (decoded != null) {
                session.log(
                  'Found JSON in content.text',
                  level: LogLevel.debug,
                );
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

    session.log(
      'Could not extract parsed response from completion event',
      level: LogLevel.warning,
    );
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

  /// Formats an error into a user-friendly message using typed classification.
  String _formatErrorForUser({
    required Object error,
    required SupportedLanguage language,
    required Session session,
  }) {
    final classification = _classifyChatError(error);
    session.log(
      'Classified chat error: reasonCode=${classification.reasonCode}, '
      'translationKey=${classification.translationKey}, rawError="$error"',
      level: LogLevel.warning,
    );
    return getErrorDescription(classification.translationKey, language);
  }

  _ChatErrorClassification _classifyChatError(Object error) {
    final errorStr = error.toString();
    final lower = errorStr.toLowerCase();

    if (_isContextLengthExceededError(error)) {
      return const _ChatErrorClassification(
        reasonCode: 'context_length_exceeded',
        translationKey: 'chat_context_length_exceeded',
      );
    }

    if (lower.contains('failed to parse structured response')) {
      return const _ChatErrorClassification(
        reasonCode: 'structured_response_parse_error',
        translationKey: 'chat_parse_error',
      );
    }

    if (lower.contains('openaiquotaexceededexception') ||
        lower.contains('insufficient_quota') ||
        lower.contains('exceeded your current quota')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_insufficient_quota',
        translationKey: 'chat_openai_quota_error',
      );
    }

    if (lower.contains('openai error 401') ||
        lower.contains('openai error 403')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_auth_error',
        translationKey: 'chat_auth_error',
      );
    }

    if (lower.contains('openai error 429') ||
        lower.contains('too many requests') ||
        lower.contains('rate_limit_exceeded')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_rate_limit',
        translationKey: 'chat_rate_limit',
      );
    }

    if (lower.contains('openai error 400')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_invalid_request',
        translationKey: 'chat_invalid_request',
      );
    }

    if (lower.contains('openai error 5')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_service_unavailable',
        translationKey: 'chat_service_unavailable',
      );
    }

    if (lower.contains('socketexception') ||
        lower.contains('connection closed while receiving data') ||
        lower.contains('connection reset') ||
        lower.contains('connection aborted') ||
        lower.contains('network is unreachable') ||
        lower.contains('clientexception: connection')) {
      return const _ChatErrorClassification(
        reasonCode: 'network_connection_error',
        translationKey: 'chat_network_error',
      );
    }

    if (lower.contains('openai streaming error')) {
      return const _ChatErrorClassification(
        reasonCode: 'openai_streaming_error',
        translationKey: 'chat_service_unavailable',
      );
    }

    return const _ChatErrorClassification(
      reasonCode: 'unknown_error',
      translationKey: 'chat_message_error',
    );
  }
}

class _ChatErrorClassification {
  final String reasonCode;
  final String translationKey;

  const _ChatErrorClassification({
    required this.reasonCode,
    required this.translationKey,
  });
}

class OpenAiMessage {
  final String role;
  final String content;

  OpenAiMessage({required this.role, required this.content});

  Map<String, String> toMap() => {'role': role, 'content': content};
}

class _OpenAiStreamResult {
  final WebScrapperChatAIResponse response;
  final Map<String, dynamic>? rawJson;
  final List<String> thinkingSentences;
  final StructuredResponseValidationReason? validationReason;
  final String? validationErrorDescription;

  /// Token usage from the API response
  final _TokenUsage usage;

  _OpenAiStreamResult({
    required this.response,
    required this.rawJson,
    required this.thinkingSentences,
    required this.usage,
    required this.validationReason,
    required this.validationErrorDescription,
  });
}

class _HistoryTrimResult {
  final int droppedMessages;
  final int droppedTurns;
  final int estimatedTokensBefore;
  final int estimatedTokensAfter;

  const _HistoryTrimResult({
    required this.droppedMessages,
    required this.droppedTurns,
    required this.estimatedTokensBefore,
    required this.estimatedTokensAfter,
  });
}

/// Token usage information from OpenAI API response
class _TokenUsage {
  final int inputTokens;
  final int outputTokens;
  final int reasoningTokens;
  final int totalTokens;

  const _TokenUsage({
    required this.inputTokens,
    required this.outputTokens,
    this.reasoningTokens = 0,
    required this.totalTokens,
  });

  /// Zero usage (used when usage info is not available)
  static const zero = _TokenUsage(
    inputTokens: 0,
    outputTokens: 0,
    totalTokens: 0,
  );

  /// Parses the usage object from OpenAI API response
  factory _TokenUsage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return zero;

    final inputTokens = json['input_tokens'] as int? ?? 0;
    final outputTokens = json['output_tokens'] as int? ?? 0;
    final totalTokens =
        json['total_tokens'] as int? ?? (inputTokens + outputTokens);

    // Extract reasoning tokens from output_tokens_details
    final outputDetails =
        json['output_tokens_details'] as Map<String, dynamic>?;
    final reasoningTokens = outputDetails?['reasoning_tokens'] as int? ?? 0;

    return _TokenUsage(
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      reasoningTokens: reasoningTokens,
      totalTokens: totalTokens,
    );
  }
}
