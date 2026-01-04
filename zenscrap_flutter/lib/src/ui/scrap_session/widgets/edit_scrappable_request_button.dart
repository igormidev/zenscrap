import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/dialogs/edit_scrappable_request_dialog.dart';

class EditScrappableRequestButton extends StatelessWidget {
  final ScrappableRequest? scrappableRequest;
  final int scrappableId;

  /// The session expiration time for real-time expiration tracking.
  final DateTime? targetTime;

  const EditScrappableRequestButton({
    super.key,
    required this.scrappableRequest,
    required this.scrappableId,
    this.targetTime,
  });

  /// Check if the session is expired
  bool get _isExpired {
    if (targetTime == null) return false;
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
        Icons.edit,
        size: 18,
        color: isExpired ? context.c.onSurface.withAlpha(100) : context.c.primary,
      ),
      tooltip: isExpired
          ? l10n.scrap_session_session_expired_tooltip
          : l10n.scrap_session_edit_request,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => EditScrappableRequestDialog(
            scrappableRequest: scrappableRequest!,
            scrappableId: scrappableId,
            targetTime: targetTime,
          ),
        );
      },
    );
  }
}
