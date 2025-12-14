import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/trust_badges_row.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

/// Hero section for the landing page with Z-pattern layout.
/// Contains headline, subheadline, CTA form (URL + prompt inputs), and robot Lottie.
/// Scales content based on available screen height for optimal display.
class HeroSection extends ConsumerStatefulWidget {
  /// Callback when user successfully submits the form.
  /// This allows the landing page to transition to the scrappable creation flow.
  final VoidCallback? onFormSubmitted;

  /// The available height for the hero section (screen height minus app bar).
  final double availableHeight;

  const HeroSection({
    super.key,
    this.onFormSubmitted,
    required this.availableHeight,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with TickerProviderStateMixin, CreateScrappableMixin {
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

    await createScrappableWithTracking(
      targetUrl: _referenceLinkEC.text,
      userPrompt: _promptEC.text,
      onSuccess: widget.onFormSubmitted,
      onBeforeCreate: () async {
        // Track as landing page CTA click (hero section specific)
        await analytics.trackLandingCtaClick(
          buttonLabel: 'Create Your First Scraper',
          sectionName: 'hero',
          scrollPosition: 0.0, // Hero section is at the top
        );
      },
    );
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
    // Note: Form view tracking is now handled by landing page trackLandingPageView
    // to avoid redundant calls on every rebuild

    // Calculate scale factor based on available height
    // Base reference height is 720px (typical laptop viewport minus app bar)
    const baseHeight = 720.0;
    final scaleFactor = (widget.availableHeight / baseHeight).clamp(0.65, 1.4);

    // Scale values for different elements
    // Lottie scale: use Transform.scale based on available height
    final lottieScale = (1.2 * scaleFactor).clamp(0.9, 1.6);
    final headlineSize = (context.t.displayLarge?.fontSize ?? 57) * scaleFactor;
    final subheadlineSize =
        (context.t.titleMedium?.fontSize ?? 16) * scaleFactor;
    final verticalSpacing = (24 * scaleFactor).clamp(12.0, 32.0);
    final formSpacing = (48 * scaleFactor).clamp(24.0, 64.0);
    final horizontalPadding = (60 * scaleFactor).clamp(24.0, 80.0);
    final verticalPadding = (40 * scaleFactor).clamp(16.0, 56.0);

    return Container(
      width: double.infinity,
      height: widget.availableHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
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
                      AppLocalizations.of(context)!.landing_hero_title,
                      style: context.t.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.c.onSurface,
                        height: 1.1,
                        fontSize: headlineSize,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.1, end: 0),
                SizedBox(height: verticalSpacing),
                // Subheadline
                ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        AppLocalizations.of(context)!.landing_hero_subtitle,
                        style: context.t.titleMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                          height: 1.6,
                          fontSize: subheadlineSize,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                SizedBox(height: formSpacing),
                // Form - textfields don't scale per user request
                Form(
                  key: _formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ZenTextfield(
                              controller: _referenceLinkEC,
                              labelText: AppLocalizations.of(context)!.landing_hero_target_url_label,
                              hintText: AppLocalizations.of(context)!.landing_hero_target_url_hint,
                              onSubmitted: (_) => _submitForm(),
                              maxLines: 1,
                              validator: (s) =>
                                  ValidationBuilder()
                                      .url(AppLocalizations.of(context)!.landing_hero_url_validation_invalid)
                                      .minLength(
                                        10,
                                        AppLocalizations.of(context)!.landing_hero_url_validation_min_length,
                                      )
                                      .maxLength(
                                        500,
                                        AppLocalizations.of(context)!.landing_hero_url_validation_max_length,
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
                                    if (_promptEC.text.trim().isNotEmpty) {
                                      return;
                                    }
                                    setState(
                                      () => _isDescriptionFocused = false,
                                    );
                                  }
                                },
                                child: ZenTextfield(
                                  controller: _promptEC,
                                  labelText: AppLocalizations.of(context)!.landing_hero_prompt_label,
                                  hintText:
                                      AppLocalizations.of(context)!.landing_hero_prompt_hint,
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  onSubmitted: (_) => _submitForm(),
                                  validator: ValidationBuilder()
                                      .minLength(
                                        10,
                                        AppLocalizations.of(context)!.landing_hero_prompt_validation_min_length,
                                      )
                                      .maxLength(
                                        2200,
                                        AppLocalizations.of(context)!.landing_hero_prompt_validation_max_length,
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
                                  icon: const Icon(Icons.auto_awesome_rounded),
                                  label: Text(
                                    AppLocalizations.of(context)!.landing_hero_cta_button,
                                  ),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 18,
                                    ),
                                    textStyle: context.t.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  AppLocalizations.of(context)!.landing_hero_free_label,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right side - Robot Lottie with trust badges below (Z-pattern right end)
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                      scale: lottieScale,
                      child: SizedBox(
                        height: 500,
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
                const SizedBox(height: 16),
                const TrustBadgesRow().animate().fadeIn(
                  duration: 600.ms,
                  delay: 1000.ms,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
