import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/dialogs/edit_scrappable_request_dialog.dart';

class EditScrappableRequestButton extends StatelessWidget {
  final ScrappableRequest? scrappableRequest;
  final int scrappableId;

  const EditScrappableRequestButton({
    super.key,
    required this.scrappableRequest,
    required this.scrappableId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (scrappableRequest == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(
        Icons.edit,
        size: 18,
        color: context.c.primary,
      ),
      tooltip: l10n.scrap_session_edit_request,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => EditScrappableRequestDialog(
            scrappableRequest: scrappableRequest!,
            scrappableId: scrappableId,
          ),
        );
      },
    );
  }
}
