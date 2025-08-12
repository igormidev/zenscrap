import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportButton extends StatelessWidget {
  const ContactSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        launchUrl(
          Uri.parse('https://wa.me/+5521967103488'),
        );
      },
      label: const Text('Contact support'),
      icon: const Icon(Icons.support_agent_rounded),
    );
  }
}
