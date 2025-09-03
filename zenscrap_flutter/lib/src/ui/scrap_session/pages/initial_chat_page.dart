import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/components/adaptive_progress_indicator.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
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
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _isLoading.value = true;
    await ref.read(scrapChatProvider.notifier).createScrappable(
          targetUrl: _referenceLinkEC.text,
          userPrompt: _promptEC.text,
        );
    _isLoading.value = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _referenceLinkEC.dispose();
    _promptEC.dispose();
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    height: 400,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Lottie.network(
                        'https://lottie.host/5f15ff4c-0e86-4f26-9bbc-29afbf753eb0/okRB2OAoWp.lottie',
                        decoder: customDecoder,
                      ),
                    ),
                  ).animate().fadeIn(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 300)),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Text(
                      'Vibe scrap any site',
                      style: context.t.displayMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        height: 1,
                        color: context.c.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ZenTextfield(
                    controller: _referenceLinkEC,
                    labelText: 'Type a reference link',
                    hintText: 'E.g https://example.com/product/12345',
                    onSubmitted: (_) => _submitForm(),
                    validator: ValidationBuilder()
                        .url('Please enter a valid URL')
                        .minLength(10, 'URL must be at least 10 characters')
                        .maxLength(500, 'URL must be less than 500 characters')
                        .build(),
                  ),
                  SizedBox(height: 32),
                  ZenTextfield(
                    controller: _promptEC,
                    labelText: 'What do you wan\'t to extract from that link?',
                    hintText: 'E.g. Extract all product details from the page',
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: (_) => _submitForm(),
                    validator: ValidationBuilder()
                        .minLength(10, 'Prompt must be at least 10 characters')
                        .maxLength(
                            500, 'Prompt must be less than 500 characters')
                        .build(),
                  ),
                  SizedBox(height: 32),
                  FilledButton.tonalIcon(
                    onPressed: _submitForm,
                    style: FilledButton.styleFrom(
                      iconAlignment: IconAlignment.end,
                    ),
                    // icon: const Icon(Icons.send),
                    icon: ValueListenableBuilder(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) {
                        if (isLoading) {
                          return const SizedBox(
                            height: 20,
                            child: AdaptiveProgressIndicator(),
                          );
                        }

                        return const Icon(Icons.send);
                      },
                    ),
                    label: ValueListenableBuilder(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) {
                        if (isLoading) {
                          return Text('Creating scrappable...');
                        }

                        return Text('Create scrappable');
                      },
                    ),
                  ),
                  SizedBox(height: 16),
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
          ),
        ),
        if (ref.watch(sessionProvider.select((value) => value.maybeMap(
              orElse: () => false,
              notSignedIn: (_) => true,
            )))) ...[
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              onPressed: () {
                ref.read(scrapChatProvider.notifier).reset();
                context.push('/auth');
              },
              icon: const Icon(Icons.login),
              label: const Text('Already have an account? Log in'),
            ),
          ),
        ] else ...[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton.filledTonal(
                tooltip: 'Go back to zen scrap dashboard',
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.navigate_before_rounded),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
