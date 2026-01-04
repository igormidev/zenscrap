import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/animated_thinking_dots.dart';

class TestEndpointDialog extends ConsumerStatefulWidget {
  final int scrappableId;
  final ScrappableRequest scrappableRequest;
  final ReferenceTestData? testData;

  /// When true, uses the test endpoint (no API key required, shows expiration timer).
  /// When false, uses the prod endpoint (requires API key, no expiration timer).
  final bool isTestMode;

  /// Required when [isTestMode] is true. The session expiration time.
  final DateTime? targetTime;

  /// Required when [isTestMode] is false. The API key for production calls.
  final String? apiKey;

  /// When true, the Run Test button will be disabled with a notice.
  final bool isChatLoading;

  /// When true, the Run Test button will be disabled (session expired).
  final bool isExpired;

  const TestEndpointDialog({
    super.key,
    required this.scrappableId,
    required this.scrappableRequest,
    required this.testData,
    this.isTestMode = true,
    this.targetTime,
    this.apiKey,
    this.isChatLoading = false,
    this.isExpired = false,
  }) : assert(
         isTestMode ? targetTime != null : apiKey != null,
         isTestMode
             ? 'targetTime is required in test mode'
             : 'apiKey is required in production mode',
       );

  @override
  ConsumerState<TestEndpointDialog> createState() => _TestEndpointDialogState();
}

class _TestEndpointDialogState extends ConsumerState<TestEndpointDialog> {
  final Map<String, TextEditingController> _pathParamControllers = {};
  final Map<String, TextEditingController> _queryParamControllers = {};

  /// Converts the Serverpod API host to the web server host.
  ///
  /// In Serverpod Cloud, the API routes (RPC endpoints) are at api.domain.com,
  /// but webServer routes (added via addRoute) are at www.domain.com.
  String _apiHostToWebHost(String apiHost) {
    // Handle localhost development
    if (apiHost.contains('localhost:8080')) {
      return apiHost.replaceAll('localhost:8080', 'localhost:8082');
    }
    // Handle production: api.domain.com → www.domain.com
    if (apiHost.contains('://api.')) {
      return apiHost.replaceAll('://api.', '://www.');
    }
    return apiHost;
  }

  bool _isLoading = false;
  String? _responseJson;
  String? _errorMessage;
  bool _hasTestedOnce = false;
  int? _statusCode;
  int? _responseTimeMs;

  // Live elapsed time tracking
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _elapsedTimer;
  final ValueNotifier<int> _elapsedMs = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize path parameter controllers
    for (final param in widget.scrappableRequest.pathParams) {
      _pathParamControllers[param] = TextEditingController();
    }

    // Initialize query parameter controllers
    widget.scrappableRequest.queryParams.forEach((key, value) {
      _queryParamControllers[key] = TextEditingController(text: value ?? '');
    });

    // Pre-fill with test data if available
    if (widget.testData != null) {
      try {
        final testPayload =
            jsonDecode(widget.testData!.referenceQueryParametersJson)
                as Map<String, dynamic>;

        testPayload.forEach((key, value) {
          if (_pathParamControllers.containsKey(key)) {
            _pathParamControllers[key]!.text = value?.toString() ?? '';
          } else if (_queryParamControllers.containsKey(key)) {
            _queryParamControllers[key]!.text = value?.toString() ?? '';
          }
        });
      } catch (e) {
        // Ignore if test data can't be parsed
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _pathParamControllers.values) {
      controller.dispose();
    }
    for (final controller in _queryParamControllers.values) {
      controller.dispose();
    }
    _elapsedTimer?.cancel();
    _elapsedMs.dispose();
    super.dispose();
  }

  void _startElapsedTimer() {
    _stopwatch.reset();
    _stopwatch.start();
    _elapsedMs.value = 0;
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _elapsedMs.value = _stopwatch.elapsedMilliseconds;
    });
  }

  void _stopElapsedTimer() {
    _stopwatch.stop();
    _elapsedTimer?.cancel();
    _elapsedMs.value = _stopwatch.elapsedMilliseconds;
  }

  Future<void> _handleTest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _responseJson = null;
      _statusCode = null;
      _responseTimeMs = null;
    });

    _startElapsedTimer();

    try {
      // Build payload from controller values
      final Map<String, dynamic> payload = {};

      _pathParamControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          payload[key] = controller.text;
        }
      });

      _queryParamControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          payload[key] = controller.text;
        }
      });

      // Get base URL from client and convert to web server host
      final client = ref.read(clientProvider);
      final baseUrl = _apiHostToWebHost(client.host);
      final endpoint = widget.isTestMode
          ? '$baseUrl/api/scrappable/test'
          : '$baseUrl/api/scrappable/prod';

      // Build request data
      final requestData = <String, dynamic>{
        'scrappableId': widget.scrappableId,
        'payload': payload,
      };

      // Add API key for production mode
      if (!widget.isTestMode && widget.apiKey != null) {
        requestData['apiKey'] = widget.apiKey;
      }

      // Make HTTP POST request to the endpoint
      final dio = Dio();
      final response = await dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) {
            // Accept any status code to handle errors properly
            return status != null && status < 500;
          },
        ),
      );

      _stopElapsedTimer();

      if (mounted) {
        if (response.statusCode == 200) {
          // Success response
          final data = response.data;
          setState(() {
            _isLoading = false;
            _hasTestedOnce = true;
            _statusCode = response.statusCode;
            _responseTimeMs = _stopwatch.elapsedMilliseconds;
            // Pretty-print the JSON response
            const encoder = JsonEncoder.withIndent('  ');
            _responseJson = encoder.convert(data);
          });
        } else {
          // Error response
          String errorMessage;
          final responseData = response.data;
          if (responseData is Map<String, dynamic>) {
            final error = responseData['error'] as Map<String, dynamic>?;
            errorMessage = error != null
                ? '${error['title']}: ${error['description']}'
                : 'Request failed with status ${response.statusCode}';
          } else {
            // Unexpected response format
            errorMessage =
                'Request failed with status ${response.statusCode}: $responseData';
          }
          setState(() {
            _isLoading = false;
            _hasTestedOnce = true;
            _statusCode = response.statusCode;
            _responseTimeMs = _stopwatch.elapsedMilliseconds;
            _errorMessage = errorMessage;
          });
        }
      }
    } on DioException catch (e) {
      _stopElapsedTimer();

      if (mounted) {
        // DioException provides more context about HTTP errors
        final statusCode = e.response?.statusCode;
        String errorMessage;

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Request timed out: ${e.message}';
        } else if (e.response != null) {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            final error = responseData['error'] as Map<String, dynamic>?;
            errorMessage = error != null
                ? '${error['title']}: ${error['description']}'
                : 'Server error: ${e.message}';
          } else {
            errorMessage = 'Server error (${e.response?.statusCode}): $responseData';
          }
        } else {
          errorMessage = 'Network error: ${e.message}';
        }

        setState(() {
          _isLoading = false;
          _hasTestedOnce = true;
          _statusCode = statusCode;
          _responseTimeMs = _stopwatch.elapsedMilliseconds;
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      _stopElapsedTimer();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasTestedOnce = true;
          _statusCode = null; // null indicates local error
          _responseTimeMs = _stopwatch.elapsedMilliseconds;
          _errorMessage = 'An unexpected error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = context.responsiveValue(
      compact: MediaQuery.sizeOf(context).width * 0.95,
      medium: 700.0,
      expanded: 1000.0,
    );
    final dialogHeight = MediaQuery.sizeOf(context).height *
        context.responsiveValue(
          compact: 0.9,
          medium: 0.85,
          expanded: 0.8,
        );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Padding(
          padding: EdgeInsets.all(
            context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 24.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TestDialogHeader(
                targetTime: widget.targetTime,
                isTestMode: widget.isTestMode,
              ),
              SizedBox(
                height: context.responsiveValue(
                  compact: 16.0,
                  medium: 20.0,
                  expanded: 24.0,
                ),
              ),
              Expanded(
                child: ResponsiveBuilder(
                  compact: (context, constraints) => _CompactDialogLayout(
                    pathParamControllers: _pathParamControllers,
                    queryParamControllers: _queryParamControllers,
                    isLoading: _isLoading,
                    onTest: _handleTest,
                    responseJson: _responseJson,
                    errorMessage: _errorMessage,
                    hasTestedOnce: _hasTestedOnce,
                    statusCode: _statusCode,
                    responseTimeMs: _responseTimeMs,
                    elapsedMsNotifier: _elapsedMs,
                    isChatLoading: widget.isChatLoading,
                    isExpired: widget.isExpired,
                  ),
                  expanded: (context, constraints) => _ExpandedDialogLayout(
                    pathParamControllers: _pathParamControllers,
                    queryParamControllers: _queryParamControllers,
                    isLoading: _isLoading,
                    onTest: _handleTest,
                    responseJson: _responseJson,
                    errorMessage: _errorMessage,
                    hasTestedOnce: _hasTestedOnce,
                    statusCode: _statusCode,
                    responseTimeMs: _responseTimeMs,
                    elapsedMsNotifier: _elapsedMs,
                    isChatLoading: widget.isChatLoading,
                    isExpired: widget.isExpired,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestDialogHeader extends StatelessWidget {
  final DateTime? targetTime;
  final bool isTestMode;

  const _TestDialogHeader({required this.targetTime, required this.isTestMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Endpoint',
                style: context.t.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in parameters and run a test request',
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isTestMode && targetTime != null) ...[
          _RemainingTimeChip(targetTime: targetTime!),
          const SizedBox(width: 12),
        ],
        IconButton(
          icon: Icon(Icons.close, color: context.c.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
          style: IconButton.styleFrom(
            backgroundColor: context.c.surfaceContainerHighest.withAlpha(128),
          ),
        ),
      ],
    );
  }
}

class _RemainingTimeChip extends StatefulWidget {
  final DateTime targetTime;

  const _RemainingTimeChip({required this.targetTime});

  @override
  State<_RemainingTimeChip> createState() => _RemainingTimeChipState();
}

class _RemainingTimeChipState extends State<_RemainingTimeChip> {
  late ValueNotifier<Duration?> remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remaining = ValueNotifier(widget.targetTime.difference(DateTime.now()));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.targetTime.difference(DateTime.now());
      if (diff.isNegative) {
        remaining.value = null;
        _timer?.cancel();
      } else {
        remaining.value = diff;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    remaining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration?>(
      valueListenable: remaining,
      builder: (_, value, _) {
        final Color baseColor;
        final String text;
        if (value == null) {
          text = "Expired";
          baseColor = context.c.error;
        } else {
          final hours = value.inHours.toString().padLeft(2, '0');
          final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');

          final totalMinutesLeft = value.inMinutes;
          baseColor = totalMinutesLeft < 15
              ? context.c.error
              : (totalMinutesLeft < 35 ? Colors.orange : context.c.primary);

          final containsHour = hours != '00';
          text = containsHour
              ? '$hours:$minutes:$seconds'
              : '$minutes:$seconds';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: baseColor.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 16, color: baseColor),
              const SizedBox(width: 6),
              Text(
                text,
                style: context.t.labelMedium?.copyWith(
                  color: baseColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ParametersPanel extends StatelessWidget {
  final Map<String, TextEditingController> pathParamControllers;
  final Map<String, TextEditingController> queryParamControllers;
  final bool isLoading;
  final VoidCallback onTest;
  final bool isChatLoading;
  final bool isExpired;

  const _ParametersPanel({
    required this.pathParamControllers,
    required this.queryParamControllers,
    required this.isLoading,
    required this.onTest,
    this.isChatLoading = false,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        Row(
          children: [
            Icon(Icons.tune_rounded, size: 18, color: context.c.primary),
            const SizedBox(width: 8),
            Text(
              'Parameters',
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Parameters content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.c.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pathParamControllers.isNotEmpty) ...[
                    _ParameterSection(
                      title: 'Path Parameters',
                      subtitle: 'Values to replace {placeholders} in the URL',
                      controllers: pathParamControllers,
                    ),
                    if (queryParamControllers.isNotEmpty)
                      const SizedBox(height: 20),
                  ],
                  if (queryParamControllers.isNotEmpty)
                    _ParameterSection(
                      title: 'Query Parameters',
                      subtitle: 'Values appended as ?key=value',
                      controllers: queryParamControllers,
                    ),
                  if (pathParamControllers.isEmpty &&
                      queryParamControllers.isEmpty)
                    const _NoParametersWidget(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Session expired notice
        if (isExpired) ...[
          Tooltip(
            message: AppLocalizations.of(context)!.scrap_session_session_expired_tooltip,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.c.errorContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.error.withAlpha(80),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_off_outlined,
                    size: 18,
                    color: context.c.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.scrap_session_session_expired_test_notice,
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        // Chat loading notice
        if (isChatLoading && !isExpired) ...[
          Tooltip(
            message: AppLocalizations.of(context)!.scrap_session_chat_loading_disabled_tooltip,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.c.tertiaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.tertiary.withAlpha(80),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: context.c.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.scrap_session_chat_loading_test_notice,
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        // Run Test button
        Tooltip(
          message: isExpired
              ? AppLocalizations.of(context)!.scrap_session_session_expired_tooltip
              : (isChatLoading
                  ? AppLocalizations.of(context)!.scrap_session_chat_loading_disabled_tooltip
                  : ''),
          child: FilledButton.icon(
            onPressed: (isLoading || isChatLoading || isExpired) ? null : onTest,
            icon: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.c.onPrimary,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              isLoading ? 'Running...' : 'Run Test',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParameterSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map<String, TextEditingController> controllers;

  const _ParameterSection({
    required this.title,
    required this.subtitle,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.t.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.c.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ...controllers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: entry.value,
              style: context.t.bodyMedium,
              decoration: InputDecoration(
                labelText: entry.key,
                labelStyle: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
                filled: true,
                fillColor: context.c.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: context.c.outline.withAlpha(80),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: context.c.outline.withAlpha(80),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.c.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                isDense: true,
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _NoParametersWidget extends StatelessWidget {
  const _NoParametersWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: context.c.primary.withAlpha(150),
            ),
            const SizedBox(height: 12),
            Text(
              'No parameters needed',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Just click Run Test',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsePanel extends StatelessWidget {
  final bool isLoading;
  final String? responseJson;
  final String? errorMessage;
  final bool hasTestedOnce;
  final int? statusCode;
  final int? responseTimeMs;
  final ValueNotifier<int> elapsedMsNotifier;

  const _ResponsePanel({
    required this.isLoading,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
    required this.elapsedMsNotifier,
    this.statusCode,
    this.responseTimeMs,
  });

  static String _formatTime(int ms) {
    if (ms >= 1000) {
      return '${(ms / 1000).toStringAsFixed(2)}s';
    }
    return '${ms}ms';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(Icons.code_rounded, size: 18, color: context.c.secondary),
            const SizedBox(width: 8),
            Text(
              'Response',
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Live elapsed time display
            ValueListenableBuilder<int>(
              valueListenable: elapsedMsNotifier,
              builder: (context, elapsedMs, _) {
                // Only show if there's elapsed time (test has been run)
                if (elapsedMs == 0 && !hasTestedOnce) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isLoading
                        ? context.c.primary.withAlpha(20)
                        : context.c.onSurfaceVariant.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: isLoading
                            ? context.c.primary
                            : context.c.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(elapsedMs),
                        style: context.t.labelMedium?.copyWith(
                          color: isLoading
                              ? context.c.primary
                              : context.c.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Response content
        Expanded(
          child: _ResponseContent(
            isLoading: isLoading,
            responseJson: responseJson,
            errorMessage: errorMessage,
            hasTestedOnce: hasTestedOnce,
            statusCode: statusCode,
          ),
        ),
      ],
    );
  }
}

class _ResponseContent extends StatelessWidget {
  final bool isLoading;
  final String? responseJson;
  final String? errorMessage;
  final bool hasTestedOnce;
  final int? statusCode;

  const _ResponseContent({
    required this.isLoading,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _LoadingState();
    }

    if (errorMessage != null) {
      return _ErrorState(
        errorMessage: errorMessage!,
        statusCode: statusCode,
      );
    }

    if (responseJson != null) {
      return _SuccessState(
        responseJson: responseJson!,
        statusCode: statusCode,
      );
    }

    return _EmptyState(hasTestedOnce: hasTestedOnce);
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedThinkingDots(
              color: context.c.primary,
              size: 10,
              spacing: 4,
            ),
            const SizedBox(height: 20),
            Text(
              'Running test...',
              style: context.t.bodyLarge?.copyWith(
                color: context.c.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This may take a few seconds',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final int? statusCode;

  const _ErrorState({
    required this.errorMessage,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    final isLocalError = statusCode == null;
    final statusText = isLocalError ? 'Local Error' : '$statusCode';

    return Container(
      decoration: BoxDecoration(
        color: context.c.errorContainer.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.c.error.withAlpha(50)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.error.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Test Failed',
            style: context.t.titleMedium?.copyWith(
              color: context.c.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Status code chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.c.error.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLocalError ? Icons.computer_rounded : Icons.http_rounded,
                  size: 14,
                  color: context.c.error,
                ),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.c.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  errorMessage,
                  style: context.t.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    color: context.c.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final String responseJson;
  final int? statusCode;

  const _SuccessState({
    required this.responseJson,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.c.outline.withAlpha(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // macOS-style header with colored dots
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.c.surfaceContainerHighest.withAlpha(120),
            ),
            child: Row(
              children: [
                // Traffic light dots
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F56),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBD2E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF27C93F),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: context.c.tertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Success',
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Status code chip
                if (statusCode != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.c.tertiary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$statusCode',
                      style: context.t.labelSmall?.copyWith(
                        color: context.c.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: context.c.onSurfaceVariant,
                  ),
                  tooltip: 'Copy response',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: responseJson));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Response copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
          // JSON content
          Expanded(
            child: Container(
              color: context.c.surface,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  responseJson,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: context.c.onSurface,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasTestedOnce;

  const _EmptyState({required this.hasTestedOnce});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.c.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 48,
                color: context.c.primary.withAlpha(150),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasTestedOnce ? 'Ready for another test' : 'Ready to test',
              style: context.t.titleMedium?.copyWith(
                color: context.c.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasTestedOnce
                  ? 'Modify parameters and run again'
                  : 'Fill in the parameters and click "Run Test"',
              textAlign: TextAlign.center,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact layout for mobile - stacked vertical with tabs
class _CompactDialogLayout extends StatefulWidget {
  final Map<String, TextEditingController> pathParamControllers;
  final Map<String, TextEditingController> queryParamControllers;
  final bool isLoading;
  final VoidCallback onTest;
  final String? responseJson;
  final String? errorMessage;
  final bool hasTestedOnce;
  final int? statusCode;
  final int? responseTimeMs;
  final ValueNotifier<int> elapsedMsNotifier;
  final bool isChatLoading;
  final bool isExpired;

  const _CompactDialogLayout({
    required this.pathParamControllers,
    required this.queryParamControllers,
    required this.isLoading,
    required this.onTest,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
    required this.statusCode,
    required this.responseTimeMs,
    required this.elapsedMsNotifier,
    this.isChatLoading = false,
    this.isExpired = false,
  });

  @override
  State<_CompactDialogLayout> createState() => _CompactDialogLayoutState();
}

class _CompactDialogLayoutState extends State<_CompactDialogLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Parameters'),
            Tab(text: 'Response'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ParametersPanel(
                pathParamControllers: widget.pathParamControllers,
                queryParamControllers: widget.queryParamControllers,
                isLoading: widget.isLoading,
                onTest: () {
                  widget.onTest();
                  // Auto-switch to response tab after test
                  _tabController.animateTo(1);
                },
                isChatLoading: widget.isChatLoading,
                isExpired: widget.isExpired,
              ),
              _ResponsePanel(
                isLoading: widget.isLoading,
                responseJson: widget.responseJson,
                errorMessage: widget.errorMessage,
                hasTestedOnce: widget.hasTestedOnce,
                statusCode: widget.statusCode,
                responseTimeMs: widget.responseTimeMs,
                elapsedMsNotifier: widget.elapsedMsNotifier,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Expanded layout for desktop - side-by-side panels
class _ExpandedDialogLayout extends StatelessWidget {
  final Map<String, TextEditingController> pathParamControllers;
  final Map<String, TextEditingController> queryParamControllers;
  final bool isLoading;
  final VoidCallback onTest;
  final String? responseJson;
  final String? errorMessage;
  final bool hasTestedOnce;
  final int? statusCode;
  final int? responseTimeMs;
  final ValueNotifier<int> elapsedMsNotifier;
  final bool isChatLoading;
  final bool isExpired;

  const _ExpandedDialogLayout({
    required this.pathParamControllers,
    required this.queryParamControllers,
    required this.isLoading,
    required this.onTest,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
    required this.statusCode,
    required this.responseTimeMs,
    required this.elapsedMsNotifier,
    this.isChatLoading = false,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Parameters Panel
            SizedBox(
              width: responsiveValue(
                width: constraints.maxWidth,
                compact: constraints.maxWidth * 0.4,
                medium: 320,
                expanded: 340,
              ),
              child: _ParametersPanel(
                pathParamControllers: pathParamControllers,
                queryParamControllers: queryParamControllers,
                isLoading: isLoading,
                onTest: onTest,
                isChatLoading: isChatLoading,
                isExpired: isExpired,
              ),
            ),
        const SizedBox(width: 24),
        // Response Panel
        Expanded(
          child: _ResponsePanel(
            isLoading: isLoading,
            responseJson: responseJson,
            errorMessage: errorMessage,
            hasTestedOnce: hasTestedOnce,
            statusCode: statusCode,
            responseTimeMs: responseTimeMs,
            elapsedMsNotifier: elapsedMsNotifier,
          ),
        ),
          ],
        );
      },
    );
  }
}
