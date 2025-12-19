import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

/// A button that toggles between rail and drawer navigation modes.
/// Shows expand icon in rail mode, collapse icon with text in drawer mode.
class ExpandButton extends StatelessWidget {
  final NavigationType selectedNavigationType;
  final void Function(NavigationType type) onNavigationTypeChange;

  const ExpandButton({
    super.key,
    required this.selectedNavigationType,
    required this.onNavigationTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onNavigationTypeChange(switch (selectedNavigationType) {
          NavigationType.rail => NavigationType.drawer,
          NavigationType.drawer => NavigationType.rail,
        });
      },
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: context.c.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(switch (selectedNavigationType) {
              NavigationType.rail => Icons.keyboard_double_arrow_right_rounded,
              NavigationType.drawer => Icons.keyboard_double_arrow_left_rounded,
            }),
            Text(switch (selectedNavigationType) {
              NavigationType.rail => '',
              NavigationType.drawer => AppLocalizations.of(context)!.dashboard_collapse_tab,
            }),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
