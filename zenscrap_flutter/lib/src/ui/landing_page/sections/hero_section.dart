import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

/// Hero section for the landing page with Z-pattern layout.
/// Contains headline, subheadline, CTA form (URL + prompt inputs), and robot Lottie.
class HeroSection extends ConsumerStatefulWidget {
  /// Callback when user successfully submits the form.
  /// This allows the landing page to transition to the scrappable creation flow.
  final VoidCallback? onFormSubmitted;

  /// Callback when scroll indicator is clicked.
  final VoidCallback? onScrollDown;

  const HeroSection({super.key, this.onFormSubmitted, this.onScrollDown});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _hasStartedUrlInput = false;
  bool _hasStartedPromptInput = false;
  bool _isDescriptionFocused = false;

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
  void initState() {
    super.initState();
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

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final analytics = ref.read(analyticsServiceProvider);
    final targetUrl = _referenceLinkEC.text;

    await analytics.trackScrappableCreationAttempt(
      targetUrl: targetUrl,
      promptLength: _promptEC.text.length,
    );

    try {
      await ref
          .read(scrapChatProvider.notifier)
          .createScrappable(targetUrl: targetUrl, userPrompt: _promptEC.text);

      await analytics.trackScrappableCreationSuccess(
        targetUrl: targetUrl,
        scrappableId: 0,
      );

      widget.onFormSubmitted?.call();
    } catch (e) {
      await analytics.trackScrappableCreationFailure(
        targetUrl: targetUrl,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _referenceLinkEC.removeListener(_onUrlInputChanged);
    _promptEC.removeListener(_onPromptInputChanged);
    _referenceLinkEC.dispose();
    _promptEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.read(analyticsServiceProvider);
    final isAuthenticated = ref
        .watch(sessionProvider)
        .maybeMap(orElse: () => false, logged: (_) => true);
    analytics.trackScrappableCreationFormView(isAuthenticated: isAuthenticated);

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: screenHeight - 80,
      ), // Account for appbar
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side - Content (Z-pattern left start)
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline
                    Text(
                          'Web Scrapers That\nFix Themselves',
                          style: context.t.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.c.onSurface,
                            height: 1.1,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 24),
                    // Subheadline
                    ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Text(
                            'Describe what you want to extract. Our AI builds, tests, and maintains your scraper automatically. No code. No CSS selectors. No broken endpoints.',
                            style: context.t.titleMedium?.copyWith(
                              color: context.c.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 48),
                    // Form
                    Form(
                      key: _formKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ZenTextfield(
                                  controller: _referenceLinkEC,
                                  labelText: 'Target URL',
                                  hintText: 'https://example.com/product/12345',
                                  onSubmitted: (_) => _submitForm(),
                                  maxLines: 1,
                                  validator: (s) =>
                                      ValidationBuilder()
                                          .url('Please enter a valid URL')
                                          .minLength(
                                            10,
                                            'URL must be at least 10 characters',
                                          )
                                          .maxLength(
                                            500,
                                            'URL must be less than 500 characters',
                                          )
                                          .build()(
                                        s?.startsWith('http') == true
                                            ? s
                                            : 'http://$s',
                                      ),
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: _isDescriptionFocused ? 200 : 56,
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      if (hasFocus && !_isDescriptionFocused) {
                                        setState(
                                          () => _isDescriptionFocused = true,
                                        );
                                      } else if (!hasFocus &&
                                          _isDescriptionFocused) {
                                        if (_promptEC.text.trim().isNotEmpty)
                                          return;
                                        setState(
                                          () => _isDescriptionFocused = false,
                                        );
                                      }
                                    },
                                    child: ZenTextfield(
                                      controller: _promptEC,
                                      labelText: 'What do you want to extract?',
                                      hintText:
                                          'E.g. Extract product name, price, and images',
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
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 700.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 24),
                            Row(
                                  children: [
                                    FilledButton.icon(
                                      onPressed: _submitForm,
                                      icon: const Icon(
                                        Icons.auto_awesome_rounded,
                                      ),
                                      label: const Text(
                                        'Create Your First Scraper',
                                      ),
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 18,
                                        ),
                                        textStyle: context.t.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Free',
                                      style: context.t.labelLarge?.copyWith(
                                        color: context.c.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 800.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 16),
                            Text(
                              'No login required to test',
                              style: context.t.bodyMedium?.copyWith(
                                color: context.c.outline,
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Right side - Robot Lottie (Z-pattern right end)
              Expanded(
                flex: 4,
                child: SizedBox(
                      height: 500,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Lottie.network(
                          'https://lottie.host/5f15ff4c-0e86-4f26-9bbc-29afbf753eb0/okRB2OAoWp.lottie',
                          decoder: customDecoder,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 500.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                    ),
              ),
            ],
          ),
          // Scroll indicator at bottom center
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: widget.onScrollDown,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Learn more',
                        style: context.t.labelMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 28,
                            color: context.c.primary,
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .moveY(begin: 0, end: 8, duration: 800.ms),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
          ),
        ],
      ),
    );
  }
}
