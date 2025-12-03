import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/animated_thinking_dots.dart';

const String _kTestDialogInfoDismissedKey = 'test_dialog_info_dismissed';

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
  bool _isInfoBannerVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInfoBannerPreference();
  }

  void _loadInfoBannerPreference() {
    final prefs = ref.read(sharedPreferencesProvider);
    final dismissed = prefs.getBool(_kTestDialogInfoDismissedKey) ?? false;
    setState(() {
      _isInfoBannerVisible = !dismissed;
    });
  }

  Future<void> _dismissInfoBanner() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kTestDialogInfoDismissedKey, true);
    setState(() {
      _isInfoBannerVisible = false;
    });
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
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TestDialogHeader(
              targetTime: widget.targetTime,
              isTestMode: widget.isTestMode,
            ),
            const SizedBox(height: 16),
            if (_isInfoBannerVisible)
              _TestDialogInfoBanner(onDismiss: _dismissInfoBanner),
            if (_isInfoBannerVisible) const SizedBox(height: 20),
            Expanded(
              child: _TestDialogTwoPanelLayout(
                pathParamControllers: _pathParamControllers,
                queryParamControllers: _queryParamControllers,
                isLoading: _isLoading,
                responseJson: _responseJson,
                errorMessage: _errorMessage,
                hasTestedOnce: _hasTestedOnce,
                onTest: _handleTest,
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
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.c.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.science,
            size: 34,
            color: context.c.tertiary,
          ),
        ),
        const SizedBox(width: 12),
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
                'Test your scraping configuration with custom parameters',
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isTestMode && targetTime != null) ...[
          _RemainingTimeChip(targetTime: targetTime!),
          const SizedBox(width: 8),
        ],
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
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
          text = containsHour ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: baseColor.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: baseColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer, size: 16, color: baseColor),
              const SizedBox(width: 6),
              Text(
                text,
                style: context.t.labelLarge?.copyWith(
                  color: baseColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TestDialogInfoBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const _TestDialogInfoBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.tertiaryContainer.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.c.tertiary.withAlpha(77),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: context.c.tertiary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fill in the parameter values and click "Run Test" to see the scraped data. This simulates calling your API endpoint with the provided parameters.',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: 'Don\'t show again',
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _TestDialogTwoPanelLayout extends StatelessWidget {
  final Map<String, TextEditingController> pathParamControllers;
  final Map<String, TextEditingController> queryParamControllers;
  final bool isLoading;
  final String? responseJson;
  final String? errorMessage;
  final bool hasTestedOnce;
  final VoidCallback onTest;

  const _TestDialogTwoPanelLayout({
    required this.pathParamControllers,
    required this.queryParamControllers,
    required this.isLoading,
    required this.responseJson,
    required this.errorMessage,
    required this.hasTestedOnce,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _ParametersPanel(
            pathParamControllers: pathParamControllers,
            queryParamControllers: queryParamControllers,
            isLoading: isLoading,
            onTest: onTest,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _ResponsePanel(
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
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.primaryContainer.withAlpha(128),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 20,
                  color: context.c.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Parameters',
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pathParamControllers.isNotEmpty) ...[
                    _ParameterSection(
                      title: 'Path Parameters',
                      icon: Icons.route,
                      controllers: pathParamControllers,
                      helperText: 'Values to replace {placeholders} in the URL',
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (queryParamControllers.isNotEmpty) ...[
                    _ParameterSection(
                      title: 'Query Parameters',
                      icon: Icons.query_stats,
                      controllers: queryParamControllers,
                      helperText: 'Values appended to the URL as ?key=value',
                    ),
                  ],
                  if (pathParamControllers.isEmpty &&
                      queryParamControllers.isEmpty)
                    const _NoParametersWidget(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: isLoading ? null : onTest,
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.c.onPrimary,
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(isLoading ? 'Testing...' : 'Run Test'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, TextEditingController> controllers;
  final String helperText;

  const _ParameterSection({
    required this.title,
    required this.icon,
    required this.controllers,
    required this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: context.c.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: context.t.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          helperText,
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
              decoration: InputDecoration(
                labelText: entry.key,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
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
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.data_object_outlined,
              size: 48,
              color: context.c.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No parameters configured',
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
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.secondaryContainer.withAlpha(128),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  size: 20,
                  color: context.c.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Response',
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.secondary,
                  ),
                ),
                const Spacer(),
                if (responseJson != null)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    tooltip: 'Copy response',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: responseJson!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _ResponseContent(
              isLoading: isLoading,
              responseJson: responseJson,
              errorMessage: errorMessage,
              hasTestedOnce: hasTestedOnce,
            ),
          ),
        ],
      ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedThinkingDots(
            color: context.c.primary,
            size: 12,
            spacing: 4,
          ),
          const SizedBox(height: 24),
          Text(
            'Running test...',
            style: context.t.bodyLarge?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurfaceVariant.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;

  const _ErrorState({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.c.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Test Failed',
            style: context.t.titleLarge?.copyWith(
              color: context.c.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.errorContainer.withAlpha(77),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.c.error.withAlpha(128),
              ),
            ),
            child: SelectableText(
              errorMessage,
              style: context.t.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: context.c.onErrorContainer,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 20,
                color: context.c.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Test successful!',
                style: context.t.titleSmall?.copyWith(
                  color: context.c.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.c.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.outline.withAlpha(128),
                ),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  responseJson,
                  style: context.t.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.api,
              size: 64,
              color: context.c.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              hasTestedOnce ? 'Ready for another test' : 'Ready to test',
              style: context.t.titleMedium?.copyWith(
                color: context.c.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasTestedOnce
                  ? 'Modify parameters and run again'
                  : 'Fill in the parameters and click "Run Test"',
              textAlign: TextAlign.center,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
