import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

/// Displays the current app version at the bottom of navigation areas.
/// Supports custom version text formatting via [versionText] callback.
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
                AppLocalizations.of(context)!.dashboard_app_version(currentVersionString),
          ),
        );
      },
    );
  }
}
