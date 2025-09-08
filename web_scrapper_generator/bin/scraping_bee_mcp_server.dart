#!/usr/bin/env dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

/// ScrapingBee MCP Server - Standalone executable
void main(List<String> args) async {
  // Get API key from environment or command line
  final apiKey = Platform.environment['SCRAPINGBEE_API_KEY'] ?? 
                 (args.isNotEmpty ? args[0] : null);
  
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Error: SCRAPINGBEE_API_KEY environment variable is required');
    exit(1);
  }
  
  final server = ScrapingBeeMcpServer(apiKey: apiKey);
  await server.run();
}

class ScrapingBeeMcpServer {
  final String apiKey;
  late final Dio _dio;
  static const String _baseUrl = 'https://app.scrapingbee.com/api/v1/';
  
  ScrapingBeeMcpServer({required this.apiKey}) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 2),
    ));
  }
  
  Future<void> run() async {
    // Read from stdin and write to stdout for MCP communication
    await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
      try {
        final request = json.decode(line) as Map<String, dynamic>;
        final response = await _handleRequest(request);
        stdout.writeln(json.encode(response));
      } catch (e) {
        stderr.writeln('Error processing request: $e');
        stdout.writeln(json.encode({
          'jsonrpc': '2.0',
          'error': {
            'code': -32603,
            'message': 'Internal error: $e',
          },
          'id': null,
        }));
      }
    }
  }
  
  Future<Map<String, dynamic>> _handleRequest(Map<String, dynamic> request) async {
    final method = request['method'] as String?;
    final params = request['params'] as Map<String, dynamic>?;
    final id = request['id'];
    
    if (method == 'initialize') {
      return {
        'jsonrpc': '2.0',
        'result': {
          'protocolVersion': '2024-11-05',
          'capabilities': {
            'tools': {},
          },
          'serverInfo': {
            'name': 'ScrapingBee MCP Server',
            'version': '1.0.0',
          },
        },
        'id': id,
      };
    }
    
    if (method == 'tools/list') {
      return {
        'jsonrpc': '2.0',
        'result': {
          'tools': [
            {
              'name': 'test_extraction_rules',
              'description': 'Test ScrapingBee extraction rules on a target URL',
              'inputSchema': {
                'type': 'object',
                'properties': {
                  'url': {
                    'type': 'string',
                    'description': 'The target page URL to scrape',
                  },
                  'extract_rules': {
                    'type': 'string',
                    'description': 'JSON-encoded extraction rules',
                  },
                  'js_scenario': {
                    'type': 'string',
                    'description': 'JSON-encoded scripted actions',
                  },
                  'render_js': {
                    'type': 'boolean',
                    'description': 'Enable JavaScript rendering',
                    'default': true,
                  },
                  'wait': {
                    'type': 'integer',
                    'description': 'Fixed delay in milliseconds (0-35000)',
                  },
                  'wait_for': {
                    'type': 'string',
                    'description': 'CSS/XPath selector to wait for',
                  },
                  'wait_browser': {
                    'type': 'string',
                    'description': 'Browser event to wait for',
                  },
                  'premium_proxy': {
                    'type': 'boolean',
                    'description': 'Use residential proxy',
                  },
                  'country_code': {
                    'type': 'string',
                    'description': 'Proxy geolocation',
                  },
                  'session_id': {
                    'type': 'integer',
                    'description': 'Sticky session ID',
                  },
                  'custom_google': {
                    'type': 'boolean',
                    'description': 'Enable Google-specific handling',
                  },
                },
                'required': ['url', 'extract_rules'],
              },
            },
          ],
        },
        'id': id,
      };
    }
    
    if (method == 'tools/call') {
      final toolName = params?['name'] as String?;
      final arguments = params?['arguments'] as Map<String, dynamic>?;
      
      if (toolName == 'test_extraction_rules' && arguments != null) {
        final result = await _testExtractionRules(arguments);
        return {
          'jsonrpc': '2.0',
          'result': result,
          'id': id,
        };
      }
    }
    
    // Method not found
    return {
      'jsonrpc': '2.0',
      'error': {
        'code': -32601,
        'message': 'Method not found: $method',
      },
      'id': id,
    };
  }
  
  Future<Map<String, dynamic>> _testExtractionRules(Map<String, dynamic> arguments) async {
    try {
      // Extract all parameters
      final String url = arguments['url'] as String;
      final String extractRules = arguments['extract_rules'] as String;
      final String? jsScenario = arguments['js_scenario'] as String?;
      final bool renderJs = (arguments['render_js'] as bool?) ?? true;
      final int? wait = arguments['wait'] as int?;
      final String? waitFor = arguments['wait_for'] as String?;
      final String? waitBrowser = arguments['wait_browser'] as String?;
      final bool premiumProxy = (arguments['premium_proxy'] as bool?) ?? false;
      final String? countryCode = arguments['country_code'] as String?;
      final int? sessionId = arguments['session_id'] as int?;
      final bool? customGoogle = arguments['custom_google'] as bool?;
      
      // Check if URL is from Google domain
      final bool useCustomGoogle = customGoogle ?? _isGoogleDomain(url);
      
      // Validate JSON parameters
      try {
        json.decode(extractRules);
      } catch (e) {
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': 'Invalid extract_rules: Must be valid JSON. Error: $e',
              }),
            },
          ],
        };
      }
      
      if (jsScenario != null && jsScenario.isNotEmpty) {
        try {
          json.decode(jsScenario);
        } catch (e) {
          return {
            'content': [
              {
                'type': 'text',
                'text': json.encode({
                  'success': false,
                  'error': 'Invalid js_scenario: Must be valid JSON. Error: $e',
                }),
              },
            ],
          };
        }
      }
      
      // Build query parameters
      final Map<String, dynamic> queryParams = {
        'api_key': apiKey,
        'url': url,
        'extract_rules': extractRules,
        'render_js': renderJs.toString(),
        'json_response': 'true',
      };
      
      if (jsScenario != null && jsScenario.isNotEmpty) {
        queryParams['js_scenario'] = jsScenario;
      }
      if (wait != null) {
        queryParams['wait'] = wait.toString();
      }
      if (waitFor != null && waitFor.isNotEmpty) {
        queryParams['wait_for'] = waitFor;
      }
      if (waitBrowser != null && waitBrowser.isNotEmpty) {
        queryParams['wait_browser'] = waitBrowser;
      }
      if (premiumProxy) {
        queryParams['premium_proxy'] = 'true';
      }
      if (countryCode != null && countryCode.isNotEmpty) {
        queryParams['country_code'] = countryCode;
      }
      if (sessionId != null) {
        queryParams['session_id'] = sessionId.toString();
      }
      if (useCustomGoogle) {
        queryParams['custom_google'] = 'true';
      }
      
      // Make the actual HTTP request to ScrapingBee API
      final response = await _dio.get<Map<String, dynamic>>(
        '',
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      // Handle successful response
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data!;
        final extractedData = responseData['body'] ?? {};
        
        final result = {
          'success': true,
          'extracted_data': extractedData,
          'metadata': {
            if (responseData['cost'] != null) 'cost': responseData['cost'],
            if (responseData['url'] != null) 'url': responseData['url'],
            if (responseData['status_code'] != null) 'status_code': responseData['status_code'],
            if (responseData['resolved_url'] != null) 'resolved_url': responseData['resolved_url'],
          },
          'message': 'Extraction rules tested successfully',
        };
        
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode(result),
            },
          ],
        };
      } else {
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': 'Unexpected response from ScrapingBee: Status ${response.statusCode}',
              }),
            },
          ],
        };
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        String errorMessage = 'ScrapingBee API error';
        
        try {
          final errorData = e.response!.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'] as String;
          } else if (errorData is String) {
            errorMessage = errorData;
          }
        } catch (_) {
          errorMessage = e.response!.data.toString();
        }
        
        String detailedError;
        switch (statusCode) {
          case 400:
            detailedError = 'Bad Request: $errorMessage. Check extraction rules syntax.';
            break;
          case 401:
            detailedError = 'Authentication failed: Invalid API key';
            break;
          case 402:
            detailedError = 'Payment required: Insufficient credits';
            break;
          case 403:
            detailedError = 'Forbidden: $errorMessage';
            break;
          case 404:
            detailedError = 'Not Found: Target URL could not be accessed';
            break;
          case 429:
            detailedError = 'Rate limit exceeded';
            break;
          case 500:
            detailedError = 'ScrapingBee server error: $errorMessage';
            break;
          default:
            detailedError = 'ScrapingBee API error: $errorMessage (Status $statusCode)';
        }
        
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': detailedError,
                'status_code': statusCode,
              }),
            },
          ],
        };
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': 'Connection timeout',
              }),
            },
          ],
        };
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': 'Request timeout',
              }),
            },
          ],
        };
      } else {
        return {
          'content': [
            {
              'type': 'text',
              'text': json.encode({
                'success': false,
                'error': 'Network error: ${e.message}',
              }),
            },
          ],
        };
      }
    } catch (e) {
      return {
        'content': [
          {
            'type': 'text',
            'text': json.encode({
              'success': false,
              'error': 'Unexpected error: $e',
            }),
          },
        ],
      };
    }
  }
  
  bool _isGoogleDomain(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();
      
      final googleDomains = [
        'google.com', 'google.co.uk', 'google.ca', 'google.com.au',
        'google.de', 'google.fr', 'google.co.jp', 'google.com.br',
        'google.co.in', 'google.it', 'google.es', 'google.com.mx',
        'googleapis.com', 'googleusercontent.com', 'googlevideo.com',
        'youtube.com', 'youtu.be', 'ytimg.com',
      ];
      
      return googleDomains.any((domain) => 
        host == domain || 
        host.endsWith('.$domain') ||
        host.contains('.google.')
      );
    } catch (_) {
      return false;
    }
  }
}