import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/core/utils/devide_utils.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class InitialChatPage extends ConsumerStatefulWidget {
  const InitialChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends ConsumerState<InitialChatPage>
    with TickerProviderStateMixin, CreateScrappableMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _hasStartedUrlInput = false;
  bool _hasStartedPromptInput = false;
  bool _isDescriptionFocussed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );

    // Add listeners to track when user starts typing
    _referenceLinkEC.addListener(_onUrlInputChanged);
    _promptEC.addListener(_onPromptInputChanged);
  }

  void _onUrlInputChanged() {
    if (_referenceLinkEC.text.isNotEmpty && !_hasStartedUrlInput) {
      _hasStartedUrlInput = true;
      ref.read(analyticsServiceProvider).trackScrappableUrlInputStart();
    }
  }

  void _onPromptInputChanged() {
    if (_promptEC.text.isNotEmpty && !_hasStartedPromptInput) {
      _hasStartedPromptInput = true;
      ref.read(analyticsServiceProvider).trackScrappablePromptInputStart();
    }
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

    // This will navigate to the creatingScrappable state which shows
    // the AI thinking stream view
    await createScrappableWithTracking(
      targetUrl: _referenceLinkEC.text,
      userPrompt: _promptEC.text,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _referenceLinkEC.removeListener(_onUrlInputChanged);
    _promptEC.removeListener(_onPromptInputChanged);
    _referenceLinkEC.dispose();
    _promptEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Track page view with authentication status
    final analytics = ref.read(analyticsServiceProvider);
    final isAuthenticated = ref
        .watch(sessionProvider)
        .maybeMap(orElse: () => false, logged: (_) => true);
    analytics.trackScrappableCreationFormView(isAuthenticated: isAuthenticated);

    return Stack(
      children: [
        if (!DevicePlatform.isWindows)
          SizedBox.expand(
            child: Lottie.network(
              'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
              decoder: customDecoder,
              fit: BoxFit.fitWidth,
              frameRate: FrameRate(120),
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
            constraints: BoxConstraints(
              maxWidth: context.responsiveValue(
                compact: double.infinity,
                medium: 600,
                expanded: 700,
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveValue(
                    compact: 20.0,
                    medium: 40.0,
                    expanded: 60.0,
                  ),
                ),
                children: [
                  AnimatedContainer(
                    height: context.responsiveValue(
                      compact: 20.0,
                      medium: 30.0,
                      expanded: 40.0,
                    ),
                    duration: const Duration(milliseconds: 800),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: _isDescriptionFocussed
                        ? context.responsiveValue(
                            compact: 80.0,
                            medium: 100.0,
                            expanded: 120.0,
                          )
                        : context.responsiveValue(
                            compact: 280.0,
                            medium: 340.0,
                            expanded: 400.0,
                          ),
                    child:
                        SizedBox(
                              height: context.responsiveValue(
                                compact: 350.0,
                                medium: 425.0,
                                expanded: 500.0,
                              ),
                              child: Transform.scale(
                                scale: context.responsiveValue(
                                  compact: 1.1,
                                  medium: 1.2,
                                  expanded: 1.3,
                                ),
                                child: Lottie.network(
                                  'https://lottie.host/5f15ff4c-0e86-4f26-9bbc-29afbf753eb0/okRB2OAoWp.lottie',
                                  decoder: customDecoder,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              duration: const Duration(seconds: 1),
                              delay: const Duration(milliseconds: 300),
                            )
                            .animate(target: _isDescriptionFocussed ? 1 : 0)
                            .fadeOut(
                              duration: const Duration(milliseconds: 200),
                            ),
                  ),
                  Center(
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Text(
                        'Vibe scrap any site',
                        textAlign: TextAlign.center,
                        style: context.t.displayMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1,
                          color: context.c.primary,
                          fontSize: context.responsiveValue(
                            compact: 32.0,
                            medium: 40.0,
                            expanded: 48.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveValue(
                      compact: 16.0,
                      medium: 18.0,
                      expanded: 20.0,
                    ),
                  ),
                  ZenTextfield(
                    controller: _referenceLinkEC,
                    labelText: 'Drop a target link',
                    hintText: 'E.g https://example.com/product/12345',
                    onSubmitted: (_) => _submitForm(),
                    validator: (s) =>
                        ValidationBuilder()
                            .url('Please enter a valid URL')
                            .minLength(10, 'URL must be at least 10 characters')
                            .maxLength(
                              500,
                              'URL must be less than 500 characters',
                            )
                            .build()(
                          s?.startsWith('http') == true ? s : 'http://$s',
                        ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    child: SizedBox(
                      height: _isDescriptionFocussed
                          ? context.responsiveValue(
                              compact: 20.0,
                              medium: 25.0,
                              expanded: 30.0,
                            )
                          : 12,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.topCenter,
                    height: _isDescriptionFocussed
                        ? context.responsiveValue(
                            compact: 250.0,
                            medium: 275.0,
                            expanded: 300.0,
                          )
                        : 56,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus && !_isDescriptionFocussed) {
                          setState(() {
                            _isDescriptionFocussed = true;
                          });
                        } else if (!hasFocus && _isDescriptionFocussed) {
                          final hasSomethingTyped = _promptEC.text
                              .trim()
                              .isNotEmpty;
                          if (hasSomethingTyped) return;
                          setState(() {
                            _isDescriptionFocussed = false;
                          });
                        }
                      },
                      child: ZenTextfield(
                        controller: _promptEC,
                        labelText:
                            'What do you wan\'t to extract from that link?',
                        hintText:
                            '''E.g. Extract all product details from the page and put them into a json like this:
{
  "product_name": "",
  "description": "",
  "price": "83.99",
  "price_currency": "USD",
  "imagesLinks": [],
}''',
                        // minLines: 1,
                        // maxLines: 5,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        onSubmitted: (_) => _submitForm(),
                        validator: ValidationBuilder()
                            .minLength(
                              10,
                              'Prompt must be at least 10 characters',
                            )
                            .maxLength(
                              2200,
                              'Prompt must be less than 2200 characters',
                            )
                            .build(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveValue(
                      compact: 24.0,
                      medium: 28.0,
                      expanded: 32.0,
                    ),
                  ),
                  Center(
                    child: FilledButton.tonalIcon(
                      onPressed: _submitForm,
                      style: FilledButton.styleFrom(
                        iconAlignment: IconAlignment.end,
                        minimumSize: Size(
                          context.responsiveValue(
                            compact: double.infinity,
                            medium: 200.0,
                            expanded: 220.0,
                          ),
                          48,
                        ),
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text('Create scrappable'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Test the platform easily'
                    '\nNo login required to test your scrap endpoint',
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: context.responsiveValue(
                      compact: 24.0,
                      medium: 28.0,
                      expanded: 32.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(
          sessionProvider.select(
            (value) =>
                value.maybeMap(orElse: () => false, notSignedIn: (_) => true),
          ),
        )) ...[
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              onPressed: () {
                // Track login click
                analytics.trackScrappableCreationLoginClick();

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
        ],
      ],
    );
  }
}
