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

/// Handles automated AI-powered fix attempts for broken scrappables.
///
/// This is a non-interactive, single-shot AI session designed to:
/// 1. Analyze the current extraction rules and error patterns
/// 2. Explore the target site to identify what changed
/// 3. Generate fixed extraction rules
/// 4. Validate the fix with ScrapingBee
class AutoFixSessionHandler {
  final Session _session;
  final String _openAiApiKey;
  final String _scrapingBeeApiKey;
  final Scrappable _scrappable;
  final ScrappableRequest _scrappableRequest;
  final ScrappingBeeExtractLogic _extractLogic;
  final ReferenceTestData _referenceTestData;
  final List<ScrappableAnalytics> _recentAnalytics;

  AutoFixSessionHandler({
    required Session session,
    required String openAiApiKey,
    required String scrapingBeeApiKey,
    required Scrappable scrappable,
    required ScrappableRequest scrappableRequest,
    required ScrappingBeeExtractLogic extractLogic,
    required ReferenceTestData referenceTestData,
    required List<ScrappableAnalytics> recentAnalytics,
  })  : _session = session,
        _openAiApiKey = openAiApiKey,
        _scrapingBeeApiKey = scrapingBeeApiKey,
        _scrappable = scrappable,
        _scrappableRequest = scrappableRequest,
        _extractLogic = extractLogic,
        _referenceTestData = referenceTestData,
        _recentAnalytics = recentAnalytics;

  /// Attempts to automatically fix the broken scrappable using AI.
  ///
  /// Returns [AutoFixSuccess] if the fix worked, [AutoFixFailure] otherwise.
  Future<AutoFixResult> attemptFix() async {
    try {
      _session.log(
        'Starting auto-fix attempt for scrappable ${_scrappable.id} (${_scrappable.name})',
        level: LogLevel.info,
      );

      // Build prompts
      final systemPrompt = buildAutoFixSystemPrompt(
        scrapingBeeApiKey: _scrapingBeeApiKey,
      );
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
      final extractionRulesGuide =
          buildExtractionRulesGuide(webScrapperRequest);

      // Call OpenAI with the auto-fix prompts
      final result = await _callOpenAI(
        systemPrompt: systemPrompt,
        contextPrompt: contextPrompt,
        extractionRulesGuide: extractionRulesGuide,
        userPrompt: userPrompt,
      );

      if (result == null) {
        return const AutoFixFailure(
          errorMessage: 'Failed to get response from AI',
        );
      }

      // Parse the response
      final parsedResponse = parseStructuredResponse(result);

      return switch (parsedResponse) {
        WebScrapperChatAIResponseJustMessage(:final message) => AutoFixFailure(
            errorMessage: 'AI returned message instead of fix: $message',
          ),
        WebScrapperChatAIResponseErrorMessage(:final errorDescription) =>
          AutoFixFailure(
            errorMessage: 'AI could not fix: $errorDescription',
          ),
        WebScrapperChatAIResponseOnlyExtractRulesModified(
          :final resumeActionMessage,
          :final fetchSettings,
        ) =>
          await _validateAndCreateFix(fetchSettings, resumeActionMessage),
        WebScrapperChatAIResponseOnlyRequestModified() => const AutoFixFailure(
            errorMessage:
                'AI modified request structure but not extract rules - cannot auto-fix',
          ),
        WebScrapperChatAIResponseBothModified(
          :final resumeActionMessage,
          :final fetchSettings,
        ) =>
          await _validateAndCreateFix(fetchSettings, resumeActionMessage),
      };
    } catch (e, stackTrace) {
      _session.log(
        'Auto-fix attempt failed with exception',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      return AutoFixFailure(errorMessage: 'Exception during auto-fix: $e');
    }
  }

  /// Validates the AI-generated fix by testing with ScrapingBee
  Future<AutoFixResult> _validateAndCreateFix(
    ScrappingBeeFetchSettings fetchSettings,
    String resumeMessage,
  ) async {
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

    // Test the fix with ScrapingBee
    final ExtractDataByRule extractResult =
        await scrappingBee.extractByRulesWithLogic(
      targetUrl: _referenceTestData.referenceLinkUsed,
      scrappingBeeExtractLogic: fixedExtractLogic,
    );

    return extractResult.when(
      withData: (scrapedData) {
        // Verify we got actual data
        if (scrapedData.isEmpty) {
          return const AutoFixFailure(
            errorMessage:
                'Fix validation failed: ScrapingBee returned empty data',
          );
        }

        _session.log(
          'Auto-fix validated successfully! Extracted ${scrapedData.length} fields',
          level: LogLevel.info,
        );

        return AutoFixSuccess(
          fixedExtractLogic: fixedExtractLogic,
          resumeMessage: resumeMessage,
        );
      },
      error: (errorMessage) {
        _session.log(
          'Auto-fix validation failed: $errorMessage',
          level: LogLevel.warning,
        );
        return AutoFixFailure(
          errorMessage: 'Fix validation failed: $errorMessage',
        );
      },
    );
  }

  /// Calls OpenAI API with the auto-fix prompts
  Future<Map<String, dynamic>?> _callOpenAI({
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

    final tools = <Map<String, dynamic>>[
      {
        'type': 'mcp',
        'server_label': 'playwright',
        'server_url': _playwrightMcpUrl,
        'require_approval': 'never',
      },
      {
        'type': 'mcp',
        'server_label': 'scraping_bee',
        'server_url': _scrapingBeeMcpUrl,
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
    tools.add({
      'type': 'web_search',
      'search_context_size': 'medium',
    });

    final requestBody = {
      'model': 'gpt-5-mini', // Use mini model for cost efficiency in auto-fix
      'stream': true,
      'reasoning': {
        'effort': 'medium', // Medium reasoning for auto-fix (balance speed/quality)
      },
      'tools': tools,
      'text': {
        'format': responseFormat,
      },
      'input': messages,
      'max_output_tokens': 128000,
    };

    final client = http.Client();
    try {
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
        _session.log(
          'OpenAI API error ${streamedResponse.statusCode}: $body',
          level: LogLevel.error,
        );
        return null;
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

        if (type == 'response.output_json.delta') {
          final delta = event['delta'];
          if (delta is String) {
            jsonBuffer.write(delta);
          }
        } else if (type == 'response.completed') {
          final response = event['response'];
          if (response is Map<String, dynamic>) {
            parsedFromCompletion = _extractParsedResponse(response);
          }
        } else if (type == 'error' || type == 'response.failed') {
          final errorData = event['error'] ?? event['message'] ?? event;
          _session.log(
            'OpenAI API error event: $errorData',
            level: LogLevel.error,
          );
          return null;
        }
      }

      // Try to get JSON from completion event first, then buffer
      Map<String, dynamic>? result = parsedFromCompletion;
      if (result == null && jsonBuffer.isNotEmpty) {
        result = _tryDecodeJson(jsonBuffer.toString());
      }

      return result;
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

/// Applies a successful auto-fix to the database
Future<void> applyAutoFix({
  required Session session,
  required Scrappable scrappable,
  required ScrappingBeeExtractLogic fixedExtractLogic,
  required String resumeMessage,
}) async {
  await session.db.transaction((transaction) async {
    // Update the extraction rules
    final updatedExtractLogic = fixedExtractLogic.copyWith(
      scrappableId: scrappable.id,
    );
    await ScrappingBeeExtractLogic.db.updateRow(
      session,
      updatedExtractLogic,
      transaction: transaction,
    );

    // Reset consecutive errors, attempt count, and update timestamps
    final updatedScrappable = scrappable.copyWith(
      currentConsecutiveErrors: 0,
      autoFixAttemptCount: 0, // Reset attempt count on success
      lastAutoFixAttemptAt: DateTime.now(),
      autoFixInProgress: false,
      extractRulesUpdatedAt: DateTime.now(),
    );

    await Scrappable.db.updateRow(
      session,
      updatedScrappable,
      columns: (t) => [
        t.currentConsecutiveErrors,
        t.autoFixAttemptCount,
        t.lastAutoFixAttemptAt,
        t.autoFixInProgress,
        t.extractRulesUpdatedAt,
      ],
      transaction: transaction,
    );

    session.log(
      'Auto-fix applied successfully for scrappable ${scrappable.id}: $resumeMessage',
      level: LogLevel.info,
    );
  });
}

/// Marks an auto-fix attempt as failed
Future<void> markAutoFixFailed({
  required Session session,
  required Scrappable scrappable,
  required String errorMessage,
}) async {
  final newAttemptCount = scrappable.autoFixAttemptCount + 1;

  final updatedScrappable = scrappable.copyWith(
    lastAutoFixAttemptAt: DateTime.now(),
    autoFixInProgress: false,
    autoFixAttemptCount: newAttemptCount, // Increment attempt count on failure
  );

  await Scrappable.db.updateRow(
    session,
    updatedScrappable,
    columns: (t) => [
      t.lastAutoFixAttemptAt,
      t.autoFixInProgress,
      t.autoFixAttemptCount,
    ],
  );

  // Calculate next retry time for logging
  final nextCooldown =
      Duration(hours: 1) * (1 << newAttemptCount); // Exponential backoff
  final maxCooldown = const Duration(hours: 24);
  final effectiveCooldown =
      nextCooldown > maxCooldown ? maxCooldown : nextCooldown;

  session.log(
    'Auto-fix failed for scrappable ${scrappable.id} (attempt $newAttemptCount/5): $errorMessage. '
    'Next retry in ${effectiveCooldown.inHours}h',
    level: LogLevel.warning,
  );
}
