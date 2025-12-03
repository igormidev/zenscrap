import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';

class ContactSupportButton extends ConsumerWidget {
  const ContactSupportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);

    return TextButton.icon(
      onPressed: () async {
        // Track contact support click
        await analytics.trackAccountContactSupportClick();

        launchUrl(
          Uri.parse('https://wa.me/+5521967103488'),
        );
      },
      label: const Text('Contact support'),
      icon: const Icon(Icons.support_agent_rounded),
    );
  }
}
