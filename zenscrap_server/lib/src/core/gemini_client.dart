import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

/// Client for Google's Generative Language API (Gemini)
///
/// This client uses the REST API directly to access Gemini 3 Pro with:
/// - Google Search grounding for real-time web information
/// - Structured output (JSON schema) for type-safe responses
/// - Streaming with thinking chunks for real-time feedback
///
/// Documentation: https://ai.google.dev/gemini-api/docs/gemini-3
class GeminiClient {
  final String apiKey;
  final Dio _dio;

  /// Base URL for the Generative Language API
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  /// Default model for Gemini 3 Pro
  static const defaultModel = 'gemini-3-pro-preview';

  GeminiClient({required this.apiKey})
      : _dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            headers: {'Content-Type': 'application/json'},
            // Gemini 3 with "high" thinking level + web search grounding
            // can take 3-5 minutes for complex research tasks
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(minutes: 6),
          ),
        );

  /// Generates content with Google Search grounding and structured JSON output.
  ///
  /// This method combines:
  /// - `google_search` tool for real-time web information
  /// - `responseJsonSchema` for structured output matching the provided schema
  ///
  /// [model] - The Gemini model to use (default: gemini-3-pro-preview)
  /// [prompt] - The user prompt/question
  /// [responseSchema] - JSON schema for structured output
  /// [thinkingLevel] - Controls reasoning depth: "high" (default) or "low"
  ///
  /// Returns the parsed JSON response matching the schema.
  ///
  /// Example:
  /// ```dart
  /// final result = await client.generateWithSearchAndSchema(
  ///   prompt: 'Search for latest injuries for Manchester United',
  ///   responseSchema: {
  ///     'type': 'object',
  ///     'properties': {
  ///       'injuries': {
  ///         'type': 'array',
  ///         'items': {'type': 'object', ...}
  ///       }
  ///     },
  ///     'required': ['injuries']
  ///   },
  /// );
  /// ```
  Future<GeminiSearchResponse> generateWithSearchAndSchema({
    String model = defaultModel,
    required String prompt,
    required Map<String, dynamic> responseSchema,
    String thinkingLevel = 'high',
  }) async {
    final endpoint = '/models/$model:generateContent';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      // Enable Google Search grounding
      'tools': [
        {'googleSearch': {}},
      ],
      // Structured output configuration
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseJsonSchema': responseSchema,
        'thinkingConfig': {'thinkingLevel': thinkingLevel},
      },
    };

    try {
      final response = await _dio.post(
        endpoint,
        data: requestBody,
        queryParameters: {'key': apiKey},
        options: Options(responseType: ResponseType.json),
      );

      return _parseResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Handle specific API errors
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map
            ? (errorData['error']?['message'] ?? 'Bad Request')
            : 'Bad Request';
        throw GeminiApiException(
          'Gemini API Error (400): $errorMessage',
          statusCode: 400,
          details: errorData,
        );
      }
      if (e.response?.statusCode == 429) {
        throw GeminiApiException(
          'Rate limit exceeded. Please try again later.',
          statusCode: 429,
        );
      }
      if (e.response?.statusCode == 403) {
        throw GeminiApiException(
          'Invalid API key or insufficient permissions.',
          statusCode: 403,
        );
      }
      rethrow;
    }
  }

  /// Streams content generation with Google Search grounding, structured JSON
  /// output, and real-time thinking chunks.
  ///
  /// This method uses Server-Sent Events (SSE) to stream responses, allowing
  /// clients to receive thinking progress in real-time before the final result.
  ///
  /// Yields [GeminiStreamChunk] events which can be:
  /// - Thinking chunks (thought summaries showing AI reasoning progress)
  /// - The final JSON result matching the provided schema
  ///
  /// [model] - The Gemini model to use (default: gemini-3-pro-preview)
  /// [prompt] - The user prompt/question
  /// [responseSchema] - JSON schema for structured output
  /// [thinkingLevel] - Controls reasoning depth: "high" (default) or "low"
  /// [onLog] - Optional callback for logging (e.g., session.log)
  ///
  /// Reference: https://ai.google.dev/gemini-api/docs/thinking
  Stream<GeminiStreamChunk> streamWithSearchAndSchema({
    String model = defaultModel,
    required String prompt,
    required Map<String, dynamic> responseSchema,
    String thinkingLevel = 'high',
    void Function(String message)? onLog,
  }) async* {
    // Use streamGenerateContent endpoint with alt=sse for Server-Sent Events
    final url =
        '$_baseUrl/models/$model:streamGenerateContent?alt=sse&key=$apiKey';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      // Enable Google Search grounding
      'tools': [
        {'googleSearch': {}},
      ],
      // Generation config with thinking and structured output
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseJsonSchema': responseSchema,
        'thinkingConfig': {
          'thinkingLevel': thinkingLevel,
          'includeThoughts': true, // Enable thought summaries in stream
        },
      },
    };

    // onLog?.call('[GeminiStream] Starting SSE stream to Gemini API...');

    try {
      final response = await _dio.post<ResponseBody>(
        url,
        data: requestBody,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final stream = response.data?.stream;
      if (stream == null) {
        throw GeminiApiException('No stream in response');
      }

      // onLog?.call('[GeminiStream] Connected, receiving chunks...');

      // Buffer for accumulating partial SSE data
      final buffer = StringBuffer();
      String? lastThinkingChunk;
      Map<String, dynamic>? finalContent;
      GroundingMetadata? grounding;

      // Buffer for accumulating partial JSON content (structured output streams as chunks)
      final jsonBuffer = StringBuffer();

      await for (final chunk in stream) {
        final chunkStr = utf8.decode(chunk);
        buffer.write(chunkStr);

        // Process complete SSE events (data: {...}\n\n)
        final bufferContent = buffer.toString();
        final events = _parseSSEEvents(bufferContent);

        // Keep any incomplete data in the buffer
        final lastEventEnd = bufferContent.lastIndexOf('\n\n');
        if (lastEventEnd >= 0 && lastEventEnd < bufferContent.length - 2) {
          buffer.clear();
          buffer.write(bufferContent.substring(lastEventEnd + 2));
        } else if (events.isNotEmpty) {
          buffer.clear();
        }

        for (final eventData in events) {
          try {
            final json = jsonDecode(eventData) as Map<String, dynamic>;
            final candidates = json['candidates'] as List?;

            if (candidates == null || candidates.isEmpty) continue;

            final candidate = candidates[0] as Map<String, dynamic>;
            final content = candidate['content'] as Map<String, dynamic>?;
            final parts = content?['parts'] as List?;

            // Extract grounding metadata if present
            final groundingMeta =
                candidate['groundingMetadata'] as Map<String, dynamic>?;
            if (groundingMeta != null) {
              grounding = GroundingMetadata.fromJson(groundingMeta);
            }

            if (parts == null) continue;

            for (final part in parts) {
              final partMap = part as Map<String, dynamic>;
              final text = partMap['text'] as String?;
              final isThought = partMap['thought'] as bool? ?? false;

              if (text == null || text.isEmpty) continue;

              if (isThought) {
                // This is a thinking chunk - yield it for UI feedback
                // Only yield if it's different from the last one (avoid duplicates)
                if (text != lastThinkingChunk) {
                  lastThinkingChunk = text;
                  // onLog?.call(
                  // '[GeminiStream] Thinking: ${text.substring(0, text.length > 100 ? 100 : text.length)}...',
                  // );
                  yield GeminiStreamChunk.thinking(text);
                }
              } else {
                // This is JSON content - accumulate all chunks
                // Streaming structured output sends partial JSON strings
                jsonBuffer.write(text);
                // onLog?.call(
                // '[GeminiStream] Accumulated JSON chunk (${text.length} chars, total: ${jsonBuffer.length})',
                // );
              }
            }
          } catch (e) {
            // Skip malformed events
            // onLog?.call('[GeminiStream] Skipping malformed event: $e');
          }
        }
      }

      // Parse accumulated JSON content
      final jsonString = jsonBuffer.toString();
      if (jsonString.isNotEmpty) {
        try {
          finalContent = jsonDecode(jsonString) as Map<String, dynamic>;
          // onLog?.call(
          // '[GeminiStream] Successfully parsed accumulated JSON (${jsonString.length} chars)',
          // );
        } catch (e) {
          // onLog?.call('[GeminiStream] Failed to parse JSON: $e');
          // onLog?.call(
          // '[GeminiStream] Raw JSON (first 500 chars): ${jsonString.substring(0, jsonString.length > 500 ? 500 : jsonString.length)}',
          // );
          throw GeminiApiException(
            'Failed to parse accumulated JSON content: $e',
            details: {
              'rawJson': jsonString.length > 1000
                  ? '${jsonString.substring(0, 1000)}...'
                  : jsonString,
            },
          );
        }
      }

      // Yield the final result
      if (finalContent != null) {
        // onLog?.call('[GeminiStream] Stream complete, yielding final result');
        yield GeminiStreamChunk.result(
          GeminiSearchResponse(
            content: finalContent,
            grounding: grounding,
            rawResponse: {'streaming': true},
          ),
        );
      } else {
        throw GeminiApiException(
          'Stream completed without valid JSON content (no content chunks received)',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map
            ? (errorData['error']?['message'] ?? 'Bad Request')
            : 'Bad Request';
        throw GeminiApiException(
          'Gemini API Error (400): $errorMessage',
          statusCode: 400,
          details: errorData,
        );
      }
      if (e.response?.statusCode == 429) {
        throw GeminiApiException(
          'Rate limit exceeded. Please try again later.',
          statusCode: 429,
        );
      }
      if (e.response?.statusCode == 403) {
        throw GeminiApiException(
          'Invalid API key or insufficient permissions.',
          statusCode: 403,
        );
      }
      rethrow;
    }
  }

  /// Parses SSE (Server-Sent Events) format data into individual event payloads.
  ///
  /// SSE format: `data: {json}\n\n`
  List<String> _parseSSEEvents(String data) {
    final events = <String>[];
    final lines = data.split('\n');

    for (final line in lines) {
      if (line.startsWith('data: ')) {
        final payload = line.substring(6).trim();
        if (payload.isNotEmpty && payload != '[DONE]') {
          events.add(payload);
        }
      }
    }

    return events;
  }

  /// Parses the Gemini API response and extracts content + grounding metadata.
  GeminiSearchResponse _parseResponse(Map<String, dynamic> responseData) {
    final candidates = responseData['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw GeminiApiException(
        'No candidates in response',
        details: responseData,
      );
    }

    final firstCandidate = candidates[0] as Map<String, dynamic>;
    final content = firstCandidate['content'] as Map<String, dynamic>?;
    final groundingMetadata =
        firstCandidate['groundingMetadata'] as Map<String, dynamic>?;

    if (content == null) {
      throw GeminiApiException(
        'No content in response candidate',
        details: firstCandidate,
      );
    }

    final parts = content['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw GeminiApiException(
        'No parts in response content',
        details: content,
      );
    }

    // Get the text content (should be JSON)
    final textPart = parts.firstWhere(
      (p) => (p as Map<String, dynamic>).containsKey('text'),
      orElse: () => <String, dynamic>{},
    ) as Map<String, dynamic>;

    final textContent = textPart['text'] as String?;
    if (textContent == null || textContent.isEmpty) {
      throw GeminiApiException(
        'Empty text content in response',
        details: parts,
      );
    }

    // Parse the JSON content
    Map<String, dynamic> jsonContent;
    try {
      jsonContent = jsonDecode(textContent) as Map<String, dynamic>;
    } catch (e) {
      throw GeminiApiException(
        'Failed to parse JSON content: $e',
        details: {'rawText': textContent},
      );
    }

    // Extract grounding information
    GroundingMetadata? grounding;
    if (groundingMetadata != null) {
      grounding = GroundingMetadata.fromJson(groundingMetadata);
    }

    return GeminiSearchResponse(
      content: jsonContent,
      grounding: grounding,
      rawResponse: responseData,
    );
  }
}

/// Response from Gemini API with search grounding
class GeminiSearchResponse {
  /// The parsed JSON content matching the requested schema
  final Map<String, dynamic> content;

  /// Grounding metadata including search queries and sources
  final GroundingMetadata? grounding;

  /// The raw API response for debugging
  final Map<String, dynamic> rawResponse;

  GeminiSearchResponse({
    required this.content,
    this.grounding,
    required this.rawResponse,
  });

  /// Whether the response was grounded with web search results
  bool get isGrounded =>
      grounding != null && grounding!.searchQueries.isNotEmpty;
}

/// Metadata about the grounding/search results
class GroundingMetadata {
  /// The search queries that were executed
  final List<String> searchQueries;

  /// The web sources that were used
  final List<GroundingSource> sources;

  GroundingMetadata({required this.searchQueries, required this.sources});

  factory GroundingMetadata.fromJson(Map<String, dynamic> json) {
    final queries = (json['webSearchQueries'] as List?)
            ?.map((q) => q.toString())
            .toList() ??
        [];

    final chunks = json['groundingChunks'] as List? ?? [];
    final sources = chunks
        .map((chunk) {
          final chunkMap = chunk as Map<String, dynamic>;
          final web = chunkMap['web'] as Map<String, dynamic>?;
          if (web != null) {
            return GroundingSource(
              uri: web['uri'] as String? ?? '',
              title: web['title'] as String? ?? '',
            );
          }
          return null;
        })
        .whereType<GroundingSource>()
        .toList();

    return GroundingMetadata(searchQueries: queries, sources: sources);
  }
}

/// A web source used for grounding
class GroundingSource {
  final String uri;
  final String title;

  GroundingSource({required this.uri, required this.title});
}

/// Exception for Gemini API errors
class GeminiApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  GeminiApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    final buffer = StringBuffer('GeminiApiException: $message');
    if (statusCode != null) {
      buffer.write(' (HTTP $statusCode)');
    }
    if (details != null) {
      buffer.write('\nDetails: $details');
    }
    return buffer.toString();
  }
}

/// A chunk from a streaming Gemini response.
///
/// Can be either:
/// - A thinking chunk (AI reasoning progress)
/// - The final result (parsed JSON matching the schema)
class GeminiStreamChunk {
  /// The thinking/reasoning text (null if this is a final result)
  final String? thinkingText;

  /// The final response (null if this is a thinking chunk)
  final GeminiSearchResponse? result;

  /// Whether this chunk represents AI thinking progress
  bool get isThinking => thinkingText != null;

  /// Whether this chunk represents the final result
  bool get isResult => result != null;

  GeminiStreamChunk._({this.thinkingText, this.result});

  /// Creates a thinking chunk with the AI's reasoning progress
  factory GeminiStreamChunk.thinking(String text) {
    return GeminiStreamChunk._(thinkingText: text);
  }

  /// Creates a result chunk with the final parsed response
  factory GeminiStreamChunk.result(GeminiSearchResponse response) {
    return GeminiStreamChunk._(result: response);
  }
}
