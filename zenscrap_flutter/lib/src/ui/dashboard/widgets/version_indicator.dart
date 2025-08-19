import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

class VersionIndicator extends StatelessWidget {
  final String Function(String versionName)? versionText;
  const VersionIndicator({
    super.key,
    this.versionText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final currentVersionString = snapshot.data?.version ?? '';

        return Center(
          child: Text(
            versionText?.call(currentVersionString) ??
                'App version: $currentVersionString',
          ),
        );
      },
    );
  }
}

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
              NavigationType.drawer => 'Collapse tab',
            }),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
