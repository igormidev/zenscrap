import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/legal/privacy_policy_dialog.dart';

/// Privacy policy URL - must be a real URL for Google OAuth verification.
/// Google's crawler needs to see a link to this URL on the homepage.
/// Using www subdomain because it's the configured domain in scloud.
const _privacyPolicyUrl = 'https://www.zenscrap.com/privacy-policy';

/// A clickable text widget that links to the Privacy Policy.
/// On web: uses a real URL link (required for Google OAuth verification).
/// On native: opens a dialog for better UX.
class PrivacyPolicyLink extends StatelessWidget {
  /// Optional custom text for the link.
  final String? text;

  /// Optional custom text style.
  final TextStyle? style;

  const PrivacyPolicyLink({
    super.key,
    this.text,
    this.style,
  });

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    if (kIsWeb) {
      // On web, open the actual URL so Google can crawl it
      final uri = Uri.parse(_privacyPolicyUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
      }
    } else {
      // On native, show dialog for better UX
      if (context.mounted) {
        showPrivacyPolicyDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkText = text ?? 'Privacy Policy';
    final linkStyle = style ??
        context.t.bodySmall?.copyWith(
          color: context.c.onSurfaceVariant,
          decoration: TextDecoration.underline,
          decorationColor: context.c.onSurfaceVariant,
        );

    // On web, use SelectableText.rich with a real link for SEO/crawlability
    if (kIsWeb) {
      return Semantics(
        link: true,
        label: linkText,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _openPrivacyPolicy(context),
            child: Text(
              linkText,
              style: linkStyle,
              semanticsLabel: 'Link to Privacy Policy',
            ),
          ),
        ),
      );
    }

    // Native platforms: use dialog
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openPrivacyPolicy(context),
        child: Text(linkText, style: linkStyle),
      ),
    );
  }
}
