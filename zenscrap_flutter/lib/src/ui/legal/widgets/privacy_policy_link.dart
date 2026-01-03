import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/legal/privacy_policy_dialog.dart';

/// A clickable text widget that opens the Privacy Policy dialog.
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showPrivacyPolicyDialog(context),
        child: Text(
          text ?? 'Privacy Policy',
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
