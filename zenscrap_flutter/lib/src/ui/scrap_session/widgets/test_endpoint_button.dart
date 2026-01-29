import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/dialogs/test_endpoint_dialog.dart';

class TestEndpointButton extends StatelessWidget {
  final int scrappableId;
  final ScrappableRequest? scrappableRequest;
  final ReferenceTestData? testData;

  /// Required when [isTestMode] is true. The session expiration time.
  final DateTime? targetTime;

  /// When true, uses the test endpoint. When false, uses the prod endpoint.
  /// Defaults to true for backward compatibility.
  final bool isTestMode;

  /// Required when [isTestMode] is false. The API key for production calls.
  final String? apiKey;

  /// The default country code from ScrappingBeeExtractLogic (can be null).
  final String? defaultCountryCode;

  const TestEndpointButton({
    super.key,
    required this.scrappableId,
    required this.scrappableRequest,
    required this.testData,
    this.targetTime,
    this.isTestMode = true,
    this.apiKey,
    this.defaultCountryCode,
  });

  /// Check if the session is expired (only applies to test mode)
  bool get _isExpired {
    if (!isTestMode || targetTime == null) return false;
    return DateTime.now().isAfter(targetTime!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (scrappableRequest == null) {
      return const SizedBox.shrink();
    }

    final isExpired = _isExpired;

    return IconButton(
      icon: Icon(
        Icons.science,
        size: 18,
        color: isExpired ? context.c.onSurface.withAlpha(100) : context.c.tertiary,
      ),
      tooltip: isExpired
          ? l10n.scrap_session_session_expired_tooltip
          : 'Test endpoint',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => TestEndpointDialog(
            scrappableId: scrappableId,
            scrappableRequest: scrappableRequest!,
            testData: testData,
            isTestMode: isTestMode,
            targetTime: targetTime,
            apiKey: apiKey,
            defaultCountryCode: defaultCountryCode,
          ),
        );
      },
    );
  }
}
