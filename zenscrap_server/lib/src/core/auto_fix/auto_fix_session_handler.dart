import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/auto_fix/auto_fix_prompt_builder.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/openai_prompt_builder.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

const _openAiResponsesUrl = 'https://api.openai.com/v1/responses';
const _playwrightMcpUrl =
    'https://playwright-mcp-scrapingbee-production.up.railway.app/mcp';
const _scrapingBeeMcpUrl =
    'https://scraping-bee-mcp-production.up.railway.app/mcp';

/// Result of an auto-fix attempt
sealed class AutoFixResult {
  const AutoFixResult();
}

/// Auto-fix succeeded - new extraction rules are available
class AutoFixSuccess extends AutoFixResult {
  final ScrappingBeeExtractLogic fixedExtractLogic;
  final String resumeMessage;

  const AutoFixSuccess({
    required this.fixedExtractLogic,
    required this.resumeMessage,
  });
}

/// Auto-fix failed - could not repair the scrappable
class AutoFixFailure extends AutoFixResult {
  final String errorMessage;

  const AutoFixFailure({required this.errorMessage});
}

/// Maps AiModel enum to OpenAI model name
String getModelName(AiModel model) {
  return switch (model) {
    AiModel.normal => 'gpt-5.2',
    AiModel.powerful => 'gpt-5.2-pro',
  };
}

/// Maps AiModel enum to OpenAI reasoning effort.
String getReasoningEffort(AiModel model) {
  return switch (model) {
    AiModel.normal => 'high',
    AiModel.powerful => 'xhigh',
  };
}

/// Handles automated AI-powered fix attempts for broken scrappables.
///
/// This is a non-interactive, single-shot AI session designed to:
/// 1. Analyze the current extraction rules and error patterns
/// 2. Explore the target site to identify what changed
/// 3. Generate fixed extraction rules
/// 4. Validate the fix with ScrapingBee
///
/// All attempts are logged to AutoFixAttempt for auditing.
class AutoFixSessionHandler {
  final Session _session;
  final String _openAiApiKey;
  final Scrappable _scrappable;
  final ScrappableRequest _scrappableRequest;
  final ScrappingBeeExtractLogic _extractLogic;
  final ReferenceTestData _referenceTestData;
  final List<ScrappableAnalytics> _recentAnalytics;
  final AiModel _aiModel;
  final int _autoFixSessionId;

  AutoFixSessionHandler({
    required Session session,
    required String openAiApiKey,
    required Scrappable scrappable,
    required ScrappableRequest scrappableRequest,
    required ScrappingBeeExtractLogic extractLogic,
    required ReferenceTestData referenceTestData,
    required List<ScrappableAnalytics> recentAnalytics,
    required AiModel aiModel,
    required int autoFixSessionId,
  }) : _session = session,
       _openAiApiKey = openAiApiKey,
       _scrappable = scrappable,
       _scrappableRequest = scrappableRequest,
       _extractLogic = extractLogic,
       _referenceTestData = referenceTestData,
       _recentAnalytics = recentAnalytics,
       _aiModel = aiModel,
       _autoFixSessionId = autoFixSessionId;

  /// Attempts to automatically fix the broken scrappable using AI.
  ///
  /// Returns [AutoFixSuccess] if the fix worked, [AutoFixFailure] otherwise.
  Future<AutoFixResult> attemptFix() async {
    final now = DateTime.now();

    // Create AutoFixAttempt record
    final attempt = await AutoFixAttempt.db.insertRow(
      _session,
      AutoFixAttempt(
        startedAt: now,
        attemptNumber: 1, // Currently single attempt per session
        status: AutoFixAttemptStatus.in_progress,
        sessionId: _autoFixSessionId,
      ),
    );

    try {
      _session.log(
        'Starting auto-fix attempt for scrappable ${_scrappable.id} (${_scrappable.name}) '
        'using model ${getModelName(_aiModel)}',
        level: LogLevel.info,
      );

      // Build prompts
      final systemPrompt = buildAutoFixSystemPrompt();
      final contextPrompt = buildAutoFixContextPrompt(
        scrappable: _scrappable,
        scrappableRequest: _scrappableRequest,
        extractLogic: _extractLogic,
        referenceTestData: _referenceTestData,
        recentAnalytics: _recentAnalytics,
      );
      final userPrompt = buildAutoFixUserPrompt();

      // Build extraction rules guide for this session
      final webScrapperRequest = WebScrapperRequest(
        url: _scrappableRequest.url,
        queryParam: _scrappableRequest.queryParams,
        queryParamsNotRelatedToUrl:
            _scrappableRequest.queryParamsNotRelatedToUrl,
        pathParams: _scrappableRequest.pathParams,
      );
      final extractionRulesGuide = buildExtractionRulesGuide(
        webScrapperRequest,
      );

      // Call OpenAI with the auto-fix prompts
      final (
        result,
        thinkingLog,
        inputTokens,
        outputTokens,
        reasoningTokens,
      ) = await _callOpenAI(
        systemPrompt: systemPrompt,
        contextPrompt: contextPrompt,
        extractionRulesGuide: extractionRulesGuide,
        userPrompt: userPrompt,
      );

      if (result == null) {
        await _updateAttemptFailed(
          attempt: attempt,
          status: AutoFixAttemptStatus.api_error,
          errorMessage: 'Failed to get response from AI',
          thinkingLog: thinkingLog,
          inputTokens: inputTokens,
          outputTokens: outputTokens,
          reasoningTokens: reasoningTokens,
        );
        return const AutoFixFailure(
          errorMessage: 'Failed to get response from AI',
        );
      }

      // Parse the response
      final parsedResponse = parseStructuredResponse(result);

      return switch (parsedResponse) {
        WebScrapperChatAIResponseJustMessage(:final message) =>
          await _handleAiError(
            attempt: attempt,
            errorMessage: 'AI returned message instead of fix: $message',
            thinkingLog: thinkingLog,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            reasoningTokens: reasoningTokens,
          ),
        WebScrapperChatAIResponseErrorMessage(:final errorDescription) =>
          await _handleAiError(
            attempt: attempt,
            errorMessage: 'AI could not fix: $errorDescription',
            thinkingLog: thinkingLog,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            reasoningTokens: reasoningTokens,
          ),
        WebScrapperChatAIResponseOnlyExtractRulesModified(
          :final resumeActionMessage,
          :final fetchSettings,
        ) =>
          await _validateAndCreateFix(
            attempt: attempt,
            fetchSettings: fetchSettings,
            resumeMessage: resumeActionMessage,
            thinkingLog: thinkingLog,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            reasoningTokens: reasoningTokens,
          ),
        WebScrapperChatAIResponseOnlyRequestModified() => await _handleAiError(
          attempt: attempt,
          errorMessage:
              'AI modified request structure but not extract rules - cannot auto-fix',
          thinkingLog: thinkingLog,
          inputTokens: inputTokens,
          outputTokens: outputTokens,
          reasoningTokens: reasoningTokens,
        ),
        WebScrapperChatAIResponseBothModified(
          :final resumeActionMessage,
          :final fetchSettings,
        ) =>
          await _validateAndCreateFix(
            attempt: attempt,
            fetchSettings: fetchSettings,
            resumeMessage: resumeActionMessage,
            thinkingLog: thinkingLog,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            reasoningTokens: reasoningTokens,
          ),
      };
    } catch (e, stackTrace) {
      _session.log(
        'Auto-fix attempt failed with exception',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      await _updateAttemptFailed(
        attempt: attempt,
        status: AutoFixAttemptStatus.api_error,
        errorMessage: 'Exception during auto-fix: $e',
      );
      return AutoFixFailure(errorMessage: 'Exception during auto-fix: $e');
    }
  }

  /// Handles AI error responses
  Future<AutoFixResult> _handleAiError({
    required AutoFixAttempt attempt,
    required String errorMessage,
    String? thinkingLog,
    int inputTokens = 0,
    int outputTokens = 0,
    int reasoningTokens = 0,
  }) async {
    await _updateAttemptFailed(
      attempt: attempt,
      status: AutoFixAttemptStatus.ai_error,
      errorMessage: errorMessage,
      thinkingLog: thinkingLog,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      reasoningTokens: reasoningTokens,
    );
    return AutoFixFailure(errorMessage: errorMessage);
  }

  /// Updates attempt record as failed
  Future<void> _updateAttemptFailed({
    required AutoFixAttempt attempt,
    required AutoFixAttemptStatus status,
    required String errorMessage,
    String? thinkingLog,
    int inputTokens = 0,
    int outputTokens = 0,
    int reasoningTokens = 0,
  }) async {
    await AutoFixAttempt.db.updateRow(
      _session,
      attempt.copyWith(
        completedAt: DateTime.now(),
        status: status,
        errorMessage: errorMessage,
        aiThinkingLog: thinkingLog,
        inputTokens: inputTokens,
        outputTokens: outputTokens,
        reasoningTokens: reasoningTokens,
      ),
      columns: (t) => [
        t.completedAt,
        t.status,
        t.errorMessage,
        t.aiThinkingLog,
        t.inputTokens,
        t.outputTokens,
        t.reasoningTokens,
      ],
    );
  }

  /// Validates the AI-generated fix by testing with ScrapingBee
  Future<AutoFixResult> _validateAndCreateFix({
    required AutoFixAttempt attempt,
    required ScrappingBeeFetchSettings fetchSettings,
    required String resumeMessage,
    String? thinkingLog,
    int inputTokens = 0,
    int outputTokens = 0,
    int reasoningTokens = 0,
  }) async {
    _session.log(
      'Validating auto-fix with ScrapingBee...',
      level: LogLevel.info,
    );

    // Create the extract logic from the AI response
    final fixedExtractLogic = _extractLogic.copyWith(
      extractRules: fetchSettings.extract_rules,
      jsScenario: fetchSettings.js_scenario,
      renderJs: fetchSettings.render_js,
      wait: fetchSettings.wait,
      waitFor: fetchSettings.wait_for,
      waitBrowser: fetchSettings.wait_browser,
      premiumProxy: fetchSettings.premium_proxy,
      stealthProxy: fetchSettings.stealth_proxy,
      countryCode: fetchSettings.country_code,
      sessionId: fetchSettings.session_id,
      customGoogle: fetchSettings.custom_google,
    );

    // Update attempt with generated rules
    await AutoFixAttempt.db.updateRow(
      _session,
      attempt.copyWith(
        generatedExtractRules: fetchSettings.extract_rules,
        generatedJsScenario: fetchSettings.js_scenario,
        aiThinkingLog: thinkingLog,
        inputTokens: inputTokens,
        outputTokens: outputTokens,
        reasoningTokens: reasoningTokens,
      ),
      columns: (t) => [
        t.generatedExtractRules,
        t.generatedJsScenario,
        t.aiThinkingLog,
        t.inputTokens,
        t.outputTokens,
        t.reasoningTokens,
      ],
    );

    // Test the fix with ScrapingBee
    final ExtractDataByRule extractResult = await scrappingBee
        .extractByRulesWithLogic(
          targetUrl: _referenceTestData.referenceLinkUsed,
          scrappingBeeExtractLogic: fixedExtractLogic,
        );

    return extractResult.when(
      withData: (scrapedData) async {
        // Verify we got actual data
        if (scrapedData.isEmpty) {
          await _updateAttemptFailed(
            attempt: attempt,
            status: AutoFixAttemptStatus.validation_failed,
            errorMessage: 'ScrapingBee returned empty data',
          );
          return const AutoFixFailure(
            errorMessage:
                'Fix validation failed: ScrapingBee returned empty data',
          );
        }

        _session.log(
          'Auto-fix validated successfully! Extracted ${scrapedData.length} fields',
          level: LogLevel.info,
        );

        // Mark attempt as successful
        await AutoFixAttempt.db.updateRow(
          _session,
          attempt.copyWith(
            completedAt: DateTime.now(),
            succeeded: true,
            status: AutoFixAttemptStatus.success,
            validationPassed: true,
          ),
          columns: (t) => [
            t.completedAt,
            t.succeeded,
            t.status,
            t.validationPassed,
          ],
        );

        return AutoFixSuccess(
          fixedExtractLogic: fixedExtractLogic,
          resumeMessage: resumeMessage,
        );
      },
      error: (errorMessage) async {
        _session.log(
          'Auto-fix validation failed: $errorMessage',
          level: LogLevel.warning,
        );

        await AutoFixAttempt.db.updateRow(
          _session,
          attempt.copyWith(
            completedAt: DateTime.now(),
            status: AutoFixAttemptStatus.validation_failed,
            validationPassed: false,
            validationError: errorMessage,
          ),
          columns: (t) => [
            t.completedAt,
            t.status,
            t.validationPassed,
            t.validationError,
          ],
        );

        return AutoFixFailure(
          errorMessage: 'Fix validation failed: $errorMessage',
        );
      },
    );
  }

  /// Calls OpenAI API with the auto-fix prompts
  ///
  /// Returns a tuple of (result, thinkingLog, inputTokens, outputTokens, reasoningTokens)
  Future<(Map<String, dynamic>?, String?, int, int, int)> _callOpenAI({
    required String systemPrompt,
    required String contextPrompt,
    required String extractionRulesGuide,
    required String userPrompt,
  }) async {
    final messages = [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'system', 'content': contextPrompt},
      {'role': 'system', 'content': extractionRulesGuide},
      {'role': 'user', 'content': userPrompt},
    ];

    final schema = webScraperResponseJsonSchema;
    final responseFormat = {
      'type': 'json_schema',
      'name': schema['name'],
      'schema': schema['schema'],
      if (schema['strict'] != null) 'strict': schema['strict'],
    };

    // Get MCP API key from Serverpod passwords (configured via scloud secrets)
    final mcpApiKey = _session.passwords['mcpApiKey'];
    if (mcpApiKey == null || mcpApiKey.isEmpty) {
      throw Exception('MCP API key not configured in Serverpod passwords');
    }

    final tools = <Map<String, dynamic>>[
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

    // Add file_search if Vector Store is available
    final vectorStoreId = OpenAiFileManager.vectorStoreId;
    if (vectorStoreId != null) {
      tools.add({
        'type': 'file_search',
        'vector_store_ids': [vectorStoreId],
        'max_num_results': 10,
      });
    }

    // Add web search for documentation lookup
    tools.add({'type': 'web_search', 'search_context_size': 'medium'});

    // Use the resolved AI model
    final modelName = getModelName(_aiModel);
    final reasoningEffort = getReasoningEffort(_aiModel);
    _session.log(
      'Auto-fix OpenAI request config: model=$modelName, reasoningEffort=$reasoningEffort',
      level: LogLevel.debug,
    );

    final requestBody = {
      'model': modelName,
      'stream': true,
      'reasoning': {'effort': reasoningEffort},
      'tools': tools,
      'text': {'format': responseFormat},
      'input': messages,
      'max_output_tokens': 128000,
    };

    final client = http.Client();
    final thinkingBuffer = StringBuffer();
    int inputTokens = 0;
    int outputTokens = 0;
    int reasoningTokens = 0;

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
        _session.log(
          'OpenAI API error ${streamedResponse.statusCode}: $body',
          level: LogLevel.error,
        );
        return (null, null, 0, 0, 0);
      }

      // Process streaming response
      final lines = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      final jsonBuffer = StringBuffer();
      Map<String, dynamic>? parsedFromCompletion;

      await for (final line in lines) {
        if (line.isEmpty || !line.startsWith('data:')) continue;
        final data = line.substring(5).trim();
        if (data == '[DONE]') break;

        final Map<String, dynamic> event;
        try {
          event = jsonDecode(data) as Map<String, dynamic>;
        } catch (e) {
          continue;
        }

        final type = event['type'] as String?;

        if (type == 'response.output_text.delta') {
          // Capture thinking/reasoning content
          final delta = event['delta'];
          if (delta is String) {
            thinkingBuffer.write(delta);
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

            // Extract token usage
            final usage = response['usage'];
            if (usage is Map<String, dynamic>) {
              inputTokens = (usage['input_tokens'] as num?)?.toInt() ?? 0;
              outputTokens = (usage['output_tokens'] as num?)?.toInt() ?? 0;
              // Reasoning tokens might be in output_tokens_details
              final outputDetails = usage['output_tokens_details'];
              if (outputDetails is Map<String, dynamic>) {
                reasoningTokens =
                    (outputDetails['reasoning_tokens'] as num?)?.toInt() ?? 0;
              }
            }
          }
        } else if (type == 'error' || type == 'response.failed') {
          final errorData = event['error'] ?? event['message'] ?? event;
          _session.log(
            'OpenAI API error event: $errorData',
            level: LogLevel.error,
          );
          return (
            null,
            thinkingBuffer.isNotEmpty ? thinkingBuffer.toString() : null,
            inputTokens,
            outputTokens,
            reasoningTokens,
          );
        }
      }

      // Try to get JSON from completion event first, then buffer
      Map<String, dynamic>? result = parsedFromCompletion;
      if (result == null && jsonBuffer.isNotEmpty) {
        result = _tryDecodeJson(jsonBuffer.toString());
      }

      return (
        result,
        thinkingBuffer.isNotEmpty ? thinkingBuffer.toString() : null,
        inputTokens,
        outputTokens,
        reasoningTokens,
      );
    } finally {
      client.close();
    }
  }

  /// Extracts parsed response from OpenAI completion event
  Map<String, dynamic>? _extractParsedResponse(Map<String, dynamic> response) {
    final output = response['output'];
    if (output is List && output.isNotEmpty) {
      for (final outputItem in output) {
        if (outputItem is! Map<String, dynamic>) continue;

        final text = outputItem['text'];
        if (text is String && text.isNotEmpty) {
          final parsed = _tryDecodeJson(text);
          if (parsed != null) return parsed;
        }

        final content = outputItem['content'];
        if (content is List) {
          for (final item in content) {
            if (item is! Map<String, dynamic>) continue;
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
    return null;
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
}
