import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class ChatViewPage extends ConsumerStatefulWidget {
  const ChatViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends ConsumerState<ChatViewPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );
  }

  late final TextEditingController _referenceLinkEC = TextEditingController(
    text: kDebugMode
        ? 'https://www.transfermarkt.com.br/cuca/profil/trainer/4732'
        : null,
  );
  late final TextEditingController _promptEC = TextEditingController(
    text: kDebugMode
        ? 'This is a coach page. Extract the coach name, his current club name and also the current club image url.'
        : null,
  );

  @override
  void dispose() {
    super.dispose();
    _referenceLinkEC.dispose();
    _promptEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Lottie.network(
            'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
            decoder: customDecoder,
            fit: BoxFit.fitWidth,
            controller: _controller,
            onLoaded: (composition) {
              _controller.repeat();
            },
          ),
        ).animate().fadeIn(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 800),
            ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                SizedBox(height: 300),
                ZenTextfield(
                  controller: _referenceLinkEC,
                  labelText: 'Type a reference link',
                  hintText: 'E.g https://example.com/product/12345',
                ),
                SizedBox(height: 32),
                ZenTextfield(
                  controller: _promptEC,
                  labelText: 'What do you wan\'t to extract from that link?',
                  hintText: 'E.g. Extract all product details from the page',
                  minLines: 1,
                  maxLines: 5,
                ),
                SizedBox(height: 32),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    print('started');
                    await ref.read(scrapChatProvider.notifier).startSession(
                          targetUrl: _referenceLinkEC.text,
                          userPrompt: _promptEC.text,
                        );
                    print('end');
                  },
                  style: FilledButton.styleFrom(
                    iconAlignment: IconAlignment.end,
                  ),
                  icon: const Icon(Icons.send),
                  label: Text('Create scrappable'),
                ),
                Spacer(),
                Text(
                  'Test the platform easily'
                  '\nNo login required to test your scrap endpoint',
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32)
              ],
            ),
          ),
        )
      ],
    );
  }
}
