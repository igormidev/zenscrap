import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/legal/terms_of_service_dialog.dart';

/// A clickable text widget that opens the Terms of Service dialog.
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showTermsOfServiceDialog(context),
        child: Text(
          text ?? 'Terms of Service',
          style: style ??
              context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant,
                decoration: TextDecoration.underline,
                decorationColor: context.c.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
