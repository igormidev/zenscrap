import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

class ZenErrorTab extends StatelessWidget {
  final ZenScrapException exception;

  const ZenErrorTab(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            BabelText(
              'Ops...',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            BabelText(exception.title, style: const TextStyle(fontSize: 24)),
            BabelText(
              exception.description,
              style: const TextStyle(fontSize: 18),
            ),
            Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Lottie.network(
                  'https://lottie.host/7d39b737-8cc8-43b4-8d7b-a681c27f6ab1/gGAVAgTOtd.lottie',
                  decoder: customDecoder,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                launchUrl(Uri.parse('https://wa.me/+5521967103488'));
              },
              label: const Text('Contact support'),
              icon: const Icon(Icons.support_agent_rounded),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
