import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_platform/simple_platform.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/pages/pricing_page.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/auto_fix_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/features_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/final_cta_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/hero_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/how_it_works_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/marketplace_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/problem_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/landing_appbar.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/ai_thinking_stream_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/ip_limit_error_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';

/// Main landing page that combines all sections into a scrollable experience.
/// Manages scroll position for appbar state and section highlighting.
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _backgroundController;

  bool _isScrolled = false;
  LandingSection? _activeSection;

  // Section keys for scroll position detection and navigation
  final _heroKey = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _autoFixKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _marketplaceKey = GlobalKey();
  final _pricingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );
  }

  void _onScroll() {
    // Update scrolled state for appbar
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }

    // Update active section based on scroll position
    _updateActiveSection();
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;

    // If at the very top, show createScrappable as active
    if (scrollOffset < 100) {
      if (_activeSection != LandingSection.createScrappable) {
        setState(() => _activeSection = LandingSection.createScrappable);
      }
      return;
    }

    LandingSection? newSection;

    // Check sections from bottom to top using actual widget positions
    final pricingPos = _getWidgetScrollPosition(_pricingKey);
    final marketplacePos = _getWidgetScrollPosition(_marketplaceKey);
    final featuresPos = _getWidgetScrollPosition(_featuresKey);
    final autoFixPos = _getWidgetScrollPosition(_autoFixKey);
    final howItWorksPos = _getWidgetScrollPosition(_howItWorksKey);

    // Use a threshold to determine which section is "active"
    // A section is active when we've scrolled past its start minus some offset
    const threshold = 200.0;

    if (pricingPos != null && scrollOffset >= pricingPos - threshold) {
      newSection = LandingSection.pricing;
    } else if (marketplacePos != null &&
        scrollOffset >= marketplacePos - threshold) {
      newSection = LandingSection.marketplace;
    } else if (featuresPos != null && scrollOffset >= featuresPos - threshold) {
      newSection = LandingSection.features;
    } else if (autoFixPos != null && scrollOffset >= autoFixPos - threshold) {
      newSection = LandingSection.autoFix;
    } else if (howItWorksPos != null &&
        scrollOffset >= howItWorksPos - threshold) {
      newSection = LandingSection.howItWorks;
    } else {
      newSection = LandingSection.createScrappable;
    }

    if (newSection != _activeSection) {
      setState(() => _activeSection = newSection);
    }
  }

  /// Get the scroll position where a widget starts (relative to scroll extent)
  double? _getWidgetScrollPosition(GlobalKey key) {
    final keyContext = key.currentContext;
    if (keyContext == null) return null;

    final box = keyContext.findRenderObject() as RenderBox?;
    if (box == null) return null;

    // Get position relative to the viewport
    final position = box.localToGlobal(Offset.zero);

    // Convert to scroll position by adding current scroll offset
    // and subtracting the appbar height (80px)
    return position.dy + _scrollController.offset - 80;
  }

  void _scrollToSection(LandingSection section) {
    // Handle createScrappable - scroll to top
    if (section == LandingSection.createScrappable) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return;
    }

    // Get the key for the target section
    GlobalKey? key;
    switch (section) {
      case LandingSection.createScrappable:
        // Already handled above
        return;
      case LandingSection.howItWorks:
        key = _howItWorksKey;
        break;
      case LandingSection.autoFix:
        key = _autoFixKey;
        break;
      case LandingSection.features:
        key = _featuresKey;
        break;
      case LandingSection.marketplace:
        key = _marketplaceKey;
        break;
      case LandingSection.pricing:
        key = _pricingKey;
        break;
    }

    // Use Scrollable.ensureVisible for reliable scrolling
    final keyContext = key.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0, // Align to top of viewport
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrapChatState = ref.watch(scrapChatProvider);

    // If user has started creating a scrappable, show the appropriate view
    return scrapChatState.maybeWhen(
      creatingScrappable: (referenceLink, thinkingChunks, groundingMetadata) {
        return Scaffold(
          body: AiThinkingStreamView(
            referenceLink: referenceLink,
            thinkingChunks: thinkingChunks,
            groundingMetadata: groundingMetadata,
          ),
        );
      },
      standard:
          (scrappable, testExpirationDate, sessionUuid, llmThinkingStream) {
            return Scaffold(
              body: ScrappableEditSessionView(
                testExpirationDate: testExpirationDate,
                scrappable: scrappable,
                llmThinkingStream: llmThinkingStream,
              ),
            );
          },
      withError: (exception) {
        if (exception.title == 'Usage Limit Reached') {
          return Scaffold(body: IpLimitErrorView(exception: exception));
        }
        return Scaffold(body: ZenErrorTab(exception));
      },
      orElse: () => _buildLandingPage(context),
    );
  }

  Widget _buildLandingPage(BuildContext context) {
    return Scaffold(
      // Make scaffold background transparent so Lottie shows through
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Base background color layer
          Positioned.fill(child: Container(color: context.c.surface)),

          // Fixed background Lottie animation
          if (!DevicePlatform.isWindows)
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.network(
                  'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
                  decoder: customDecoder,
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                  controller: _backgroundController,
                  onLoaded: (composition) {
                    _backgroundController.repeat();
                  },
                ),
              ),
            ),

          // Scrollable content with transparent background
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Spacer for appbar
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // Hero Section - key on the child widget, not the sliver
              SliverToBoxAdapter(
                child: HeroSection(
                  key: _heroKey,
                  onScrollDown: () =>
                      _scrollToSection(LandingSection.howItWorks),
                ),
              ),

              // Problem Section
              const SliverToBoxAdapter(child: ProblemSection()),

              // How It Works Section - key on the child widget
              SliverToBoxAdapter(child: HowItWorksSection(key: _howItWorksKey)),

              // Auto-Fix Section - key on the child widget
              SliverToBoxAdapter(child: AutoFixSection(key: _autoFixKey)),

              // Features Section - key on the child widget
              SliverToBoxAdapter(child: FeaturesSection(key: _featuresKey)),

              // Marketplace Section - key on the child widget
              SliverToBoxAdapter(
                child: MarketplaceSection(key: _marketplaceKey),
              ),

              // Pricing Section - key on the Container wrapper
              SliverToBoxAdapter(
                child: Container(
                  key: _pricingKey,
                  // No background - transparent
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Text(
                        'Simple, Transparent Pricing',
                        style: context.t.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.c.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose the plan that fits your needs. Scale as you grow.',
                        style: context.t.titleMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      const SizedBox(
                        height: 980,
                        child: RawPricingPageComponent(
                          isInsideLandingPage: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Final CTA Section
              SliverToBoxAdapter(
                child: FinalCtaSection(onScrollToTop: _scrollToTop),
              ),
            ],
          ),

          // Fixed floating appbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingAppBar(
              activeSection: _activeSection,
              isScrolled: _isScrolled,
              onSectionTap: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}
