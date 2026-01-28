import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_core/zenscrap_core.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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

    // Use responsive layout
    return ResponsiveBuilder(
      compact: (context, constraints) => _MobileHeroLayout(
        availableHeight: widget.availableHeight,
        formKey: _formKey,
        referenceLinkEC: _referenceLinkEC,
        promptEC: _promptEC,
        isDescriptionFocused: _isDescriptionFocused,
        onDescriptionFocusChange: (focused) =>
            setState(() => _isDescriptionFocused = focused),
        onSubmit: _submitForm,
        promptText: _promptEC.text,
      ),
      expanded: (context, constraints) => _DesktopHeroLayout(
        availableHeight: widget.availableHeight,
        formKey: _formKey,
        referenceLinkEC: _referenceLinkEC,
        promptEC: _promptEC,
        isDescriptionFocused: _isDescriptionFocused,
        onDescriptionFocusChange: (focused) =>
            setState(() => _isDescriptionFocused = focused),
        onSubmit: _submitForm,
        promptText: _promptEC.text,
      ),
    );
  }
}

/// Desktop layout with Row - content on left, Lottie on right
class _DesktopHeroLayout extends StatelessWidget {
  final double availableHeight;
  final GlobalKey<FormState> formKey;
  final TextEditingController referenceLinkEC;
  final TextEditingController promptEC;
  final bool isDescriptionFocused;
  final void Function(bool) onDescriptionFocusChange;
  final VoidCallback onSubmit;
  final String promptText;

  const _DesktopHeroLayout({
    required this.availableHeight,
    required this.formKey,
    required this.referenceLinkEC,
    required this.promptEC,
    required this.isDescriptionFocused,
    required this.onDescriptionFocusChange,
    required this.onSubmit,
    required this.promptText,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate scale factor based on available height
    // Base reference height is 720px (typical laptop viewport minus app bar)
    const baseHeight = 720.0;
    final scaleFactor = (availableHeight / baseHeight).clamp(0.65, 1.4);

    // Scale values for different elements
    final lottieScale = (1.2 * scaleFactor).clamp(0.9, 1.6);
    final headlineSize = (context.t.displayLarge?.fontSize ?? 57) * scaleFactor;
    final subheadlineSize =
        (context.t.titleMedium?.fontSize ?? 16) * scaleFactor;
    final verticalSpacing = (24 * scaleFactor).clamp(12.0, 32.0);
    final formSpacing = (30 * scaleFactor).clamp(24.0, 64.0);
    final horizontalPadding = (60 * scaleFactor).clamp(24.0, 80.0);
    final verticalPadding = (40 * scaleFactor).clamp(16.0, 56.0);

    return Container(
      width: double.infinity,
      height: availableHeight,
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
                Seo.text(
                  text: AppLocalizations.of(context)!.landing_hero_title,
                  style: TextTagStyle.h1,
                  child:
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
                ),
                SizedBox(height: verticalSpacing),
                // Subheadline
                Seo.text(
                  text: AppLocalizations.of(context)!.landing_hero_subtitle,
                  child:
                      ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.landing_hero_subtitle,
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
                ),
                SizedBox(height: formSpacing),
                // Form
                _HeroForm(
                  formKey: formKey,
                  referenceLinkEC: referenceLinkEC,
                  promptEC: promptEC,
                  isDescriptionFocused: isDescriptionFocused,
                  onDescriptionFocusChange: onDescriptionFocusChange,
                  onSubmit: onSubmit,
                  promptText: promptText,
                ),
              ],
            ),
          ),
          // Right side - Robot Lottie with trust badges below
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

/// Mobile layout with Column - content stacked vertically
class _MobileHeroLayout extends StatelessWidget {
  final double availableHeight;
  final GlobalKey<FormState> formKey;
  final TextEditingController referenceLinkEC;
  final TextEditingController promptEC;
  final bool isDescriptionFocused;
  final void Function(bool) onDescriptionFocusChange;
  final VoidCallback onSubmit;
  final String promptText;

  const _MobileHeroLayout({
    required this.availableHeight,
    required this.formKey,
    required this.referenceLinkEC,
    required this.promptEC,
    required this.isDescriptionFocused,
    required this.onDescriptionFocusChange,
    required this.onSubmit,
    required this.promptText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: availableHeight),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Headline - centered on mobile
            Seo.text(
              text: l10n.landing_hero_title,
              style: TextTagStyle.h1,
              child:
                  Text(
                        l10n.landing_hero_title,
                        style: context.t.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.c.onSurface,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: -0.1, end: 0),
            ),
            const SizedBox(height: 16),
            // Subheadline - centered on mobile
            Seo.text(
              text: l10n.landing_hero_subtitle,
              child:
                  Text(
                        l10n.landing_hero_subtitle,
                        style: context.t.bodyLarge?.copyWith(
                          color: context.c.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideY(begin: -0.1, end: 0),
            ),
            const SizedBox(height: 24),
            // Trust badges - responsive
            const TrustBadgesRow().animate().fadeIn(
              duration: 600.ms,
              delay: 500.ms,
            ),
            const SizedBox(height: 32),
            // Form - full width on mobile
            _HeroForm(
              formKey: formKey,
              referenceLinkEC: referenceLinkEC,
              promptEC: promptEC,
              isDescriptionFocused: isDescriptionFocused,
              onDescriptionFocusChange: onDescriptionFocusChange,
              onSubmit: onSubmit,
              promptText: promptText,
              isMobile: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared form widget for both layouts
class _HeroForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController referenceLinkEC;
  final TextEditingController promptEC;
  final bool isDescriptionFocused;
  final void Function(bool) onDescriptionFocusChange;
  final VoidCallback onSubmit;
  final String promptText;
  final bool isMobile;

  const _HeroForm({
    required this.formKey,
    required this.referenceLinkEC,
    required this.promptEC,
    required this.isDescriptionFocused,
    required this.onDescriptionFocusChange,
    required this.onSubmit,
    required this.promptText,
    this.isMobile = false,
  });

  @override
  State<_HeroForm> createState() => _HeroFormState();
}

class _HeroFormState extends State<_HeroForm> {
  final FocusNode _promptFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.isMobile ? double.infinity : 480,
        ),
        child: Column(
          crossAxisAlignment: widget.isMobile
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 68,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: widget.isDescriptionFocused ? 0 : 18,
                  ),
                  ZenTextfield(
                        controller: widget.referenceLinkEC,
                        labelText: l10n.landing_hero_target_url_label,
                        hintText: l10n.landing_hero_target_url_hint,
                        onSubmitted: (_) => widget.onSubmit(),
                        maxLines: 1,
                        validator: (s) {
                          final normalizedUrl =
                              s?.startsWith('http') == true ? s : 'http://$s';

                          // First check standard URL validation
                          final standardValidation = ValidationBuilder()
                              .url(l10n.landing_hero_url_validation_invalid)
                              .minLength(
                                10,
                                l10n.landing_hero_url_validation_min_length,
                              )
                              .maxLength(
                                500,
                                l10n.landing_hero_url_validation_max_length,
                              )
                              .build()(normalizedUrl);

                          if (standardValidation != null) {
                            return standardValidation;
                          }

                          // Then check if the domain is banned
                          final bannedDomain =
                              getBannedDomainFromUrl(normalizedUrl ?? '');
                          if (bannedDomain != null) {
                            return l10n.landing_hero_url_validation_banned_domain(
                              bannedDomain,
                            );
                          }

                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: widget.isDescriptionFocused ? 200 : 56,
                  child:
                      (ZenTextfield(
                            focusNode: _promptFocusNode,
                            controller: widget.promptEC,
                            labelText: l10n.landing_hero_prompt_label,
                            hintText: l10n.landing_hero_prompt_hint,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            onTapOutside: (_) {
                              _promptFocusNode.unfocus();
                              if (widget.isDescriptionFocused) {
                                if (widget.promptEC.text.trim().isNotEmpty) {
                                  return;
                                }
                                widget.onDescriptionFocusChange(false);
                              }
                            },
                            onTap: () {
                              if (widget.isDescriptionFocused &&
                                  widget.promptText.trim().isEmpty) {
                                widget.onDescriptionFocusChange(false);
                                return;
                              }
                              if (!widget.isDescriptionFocused) {
                                widget.onDescriptionFocusChange(true);
                              }
                            },
                            onSubmitted: (_) => widget.onSubmit(),
                            validator: ValidationBuilder()
                                .minLength(
                                  10,
                                  l10n.landing_hero_prompt_validation_min_length,
                                )
                                .maxLength(
                                  2200,
                                  l10n.landing_hero_prompt_validation_max_length,
                                )
                                .build(),
                          )
                          as StatefulWidget),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 700.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 24),
            if (widget.isMobile)
              _MobileCtaButton(onSubmit: widget.onSubmit)
            else
              _DesktopCtaRow(onSubmit: widget.onSubmit),
          ],
        ),
      ),
    );
  }
}

/// Desktop CTA row with button and free label side by side
class _DesktopCtaRow extends StatelessWidget {
  final VoidCallback onSubmit;

  const _DesktopCtaRow({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
          children: [
            FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(l10n.landing_hero_cta_button),
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
            Seo.text(
              text: l10n.landing_hero_free_label,
              child: Text(
                l10n.landing_hero_free_label,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

/// Mobile CTA button - full width with free label below
class _MobileCtaButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const _MobileCtaButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l10n.landing_hero_cta_button),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Seo.text(
              text: l10n.landing_hero_free_label,
              child: Text(
                l10n.landing_hero_free_label,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
