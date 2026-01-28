import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/legal/terms_of_service_dialog.dart';

/// Terms of Service URL - must be a real URL for Google OAuth verification.
/// Google's crawler needs to see a link to this URL on the homepage.
/// Using www subdomain because it's the configured domain in scloud.
const _termsOfServiceUrl = 'https://www.zenscrap.com/terms-of-service';

/// A clickable text widget that links to the Terms of Service.
/// On web: uses a real URL link (required for Google OAuth verification).
/// On native: opens a dialog for better UX.
class TermsOfServiceLink extends StatelessWidget {
  /// Optional custom text for the link.
  final String? text;

  /// Optional custom text style.
  final TextStyle? style;

  const TermsOfServiceLink({
    super.key,
    this.text,
    this.style,
  });

  Future<void> _openTermsOfService(BuildContext context) async {
    if (kIsWeb) {
      // On web, open the actual URL so Google can crawl it
      final uri = Uri.parse(_termsOfServiceUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
      }
    } else {
      // On native, show dialog for better UX
      if (context.mounted) {
        showTermsOfServiceDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkText = text ?? 'Terms of Service';
    final linkStyle = style ??
        context.t.bodySmall?.copyWith(
          color: context.c.onSurfaceVariant,
          decoration: TextDecoration.underline,
          decorationColor: context.c.onSurfaceVariant,
        );

    // On web, use Semantics for accessibility and SEO
    if (kIsWeb) {
      return Semantics(
        link: true,
        label: linkText,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _openTermsOfService(context),
            child: Text(
              linkText,
              style: linkStyle,
              semanticsLabel: 'Link to Terms of Service',
            ),
          ),
        ),
      );
    }

    // Native platforms: use dialog
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openTermsOfService(context),
        child: Text(linkText, style: linkStyle),
      ),
    );
  }
}
