import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
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

  const TestEndpointDialog({
    super.key,
    required this.scrappableId,
    required this.scrappableRequest,
    required this.testData,
    this.isTestMode = true,
    this.targetTime,
    this.apiKey,
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

  bool _isLoading = false;
  String? _responseJson;
  String? _errorMessage;
  bool _hasTestedOnce = false;

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
        final testPayload = jsonDecode(
          widget.testData!.referenceQueryParametersJson,
        ) as Map<String, dynamic>;

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
    super.dispose();
  }

  Future<void> _handleTest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _responseJson = null;
    });

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

      // Get base URL from client
      final client = ref.read(clientProvider);
      final baseUrl =
          client.host.replaceAll('localhost:8080/', 'localhost:8082');
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
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            // Accept any status code to handle errors properly
            return status != null && status < 500;
          },
        ),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          // Success response
          final data = response.data;
          setState(() {
            _isLoading = false;
            _hasTestedOnce = true;
            // Pretty-print the JSON response
            const encoder = JsonEncoder.withIndent('  ');
            _responseJson = encoder.convert(data);
          });
        } else {
          // Error response
          final error = response.data['error'] as Map<String, dynamic>?;
          setState(() {
            _isLoading = false;
            _hasTestedOnce = true;
            _errorMessage = error != null
                ? '${error['title']}: ${error['description']}'
                : 'Request failed with status ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasTestedOnce = true;
          _errorMessage = 'An unexpected error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TestDialogHeader(
              targetTime: widget.targetTime,
              isTestMode: widget.isTestMode,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Parameters Panel
                  SizedBox(
                    width: 320,
                    child: _ParametersPanel(
                      pathParamControllers: _pathParamControllers,
                      queryParamControllers: _queryParamControllers,
                      isLoading: _isLoading,
                      onTest: _handleTest,
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Response Panel
                  Expanded(
                    child: _ResponsePanel(
                      isLoading: _isLoading,
                      responseJson: _responseJson,
                      errorMessage: _errorMessage,
                      hasTestedOnce: _hasTestedOnce,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestDialogHeader extends StatelessWidget {
  final DateTime? targetTime;
  final bool isTestMode;

  const _TestDialogHeader({
    required this.targetTime,
    required this.isTestMode,
  });

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
          icon: Icon(
            Icons.close,
            color: context.c.onSurfaceVariant,
          ),
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
      builder: (_, value, __) {
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
          text =
              containsHour ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
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

  const _ParametersPanel({
    required this.pathParamControllers,
    required this.queryParamControllers,
    required this.isLoading,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              Icons.tune_rounded,
              size: 18,
              color: context.c.primary,
            ),
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
        // Run Test button
        FilledButton.icon(
          onPressed: isLoading ? null : onTest,
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
                  borderSide: BorderSide(
                    color: context.c.primary,
                    width: 1.5,
                  ),
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

  const _ResponsePanel({
    required this.isLoading,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              Icons.code_rounded,
              size: 18,
              color: context.c.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Response',
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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

  const _ResponseContent({
    required this.isLoading,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _LoadingState();
    }

    if (errorMessage != null) {
      return _ErrorState(errorMessage: errorMessage!);
    }

    if (responseJson != null) {
      return _SuccessState(responseJson: responseJson!);
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

  const _ErrorState({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.errorContainer.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.error.withAlpha(50),
        ),
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

  const _SuccessState({required this.responseJson});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outline.withAlpha(40),
        ),
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
