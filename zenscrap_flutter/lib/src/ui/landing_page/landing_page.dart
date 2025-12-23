import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/utils/devide_utils.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
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
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/landing_mobile_drawer.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/creating_scrappable_dialog.dart';
import 'package:zenscrap_flutter/src/design_system/elements/ip_limit_error_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/suspicious_ip_error_view.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _backgroundController;

  bool _isScrolled = false;
  LandingSection? _activeSection;

  // For "Learn more" button fade animation based on scroll
  double _learnMoreOpacity = 1.0;

  // Section keys for scroll position detection and navigation
  final _heroKey = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _autoFixKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _marketplaceKey = GlobalKey();
  final _pricingKey = GlobalKey();

  // Analytics tracking state
  late DateTime _pageViewStartTime;
  final Set<int> _trackedScrollDepthMilestones = {};
  final Set<String> _viewedSections = {};
  int _maxScrollDepthPercentage = 0;
  int _navClicksCount = 0;
  int _ctaClicksCount = 0;
  bool _hasTrackedPageView = false;

  // Dialog state tracking
  bool _isCreatingDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );
    _pageViewStartTime = DateTime.now();
  }

  void _onScroll() {
    // Update scrolled state for appbar
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }

    // Update "Learn more" button opacity - fade out over 150px of scroll
    final newOpacity = (1.0 - (_scrollController.offset / 150)).clamp(0.0, 1.0);
    if (newOpacity != _learnMoreOpacity) {
      setState(() => _learnMoreOpacity = newOpacity);
    }

    // Track scroll depth milestones (25%, 50%, 75%, 100%)
    _trackScrollDepth();

    // Update active section based on scroll position
    _updateActiveSection();
  }

  /// Track scroll depth milestones for analytics
  /// Research shows users who scroll past 70% convert at 5.8x higher rate
  void _trackScrollDepth() {
    if (!_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    final currentPosition = _scrollController.offset;
    final depthPercentage = ((currentPosition / maxExtent) * 100).round();

    // Update max scroll depth
    if (depthPercentage > _maxScrollDepthPercentage) {
      _maxScrollDepthPercentage = depthPercentage;
    }

    // Track milestones: 25%, 50%, 75%, 100%
    final milestones = [25, 50, 75, 100];
    for (final milestone in milestones) {
      if (depthPercentage >= milestone &&
          !_trackedScrollDepthMilestones.contains(milestone)) {
        _trackedScrollDepthMilestones.add(milestone);
        ref
            .read(analyticsServiceProvider)
            .trackLandingScrollDepth(
              depthPercentage: milestone,
              scrollPosition: currentPosition,
              maxScrollExtent: maxExtent,
            );
      }
    }
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;

    // If at the very top, show createScrappable as active
    if (scrollOffset < 100) {
      if (_activeSection != LandingSection.createScrappable) {
        setState(() => _activeSection = LandingSection.createScrappable);
        _trackSectionView('hero', 0);
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
      // Track section view for analytics
      _trackSectionViewForLandingSection(newSection);
    }
  }

  /// Track section visibility for analytics
  void _trackSectionView(String sectionName, int sectionIndex) {
    if (_viewedSections.contains(sectionName)) return;

    _viewedSections.add(sectionName);
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingSectionView(
          sectionName: sectionName,
          sectionIndex: sectionIndex,
          scrollPosition: scrollPosition,
        );
  }

  /// Map LandingSection enum to section name and index for analytics
  void _trackSectionViewForLandingSection(LandingSection? section) {
    if (section == null) return;

    final sectionData = switch (section) {
      LandingSection.createScrappable => ('hero', 0),
      LandingSection.howItWorks => ('howItWorks', 2),
      LandingSection.autoFix => ('autoFix', 3),
      LandingSection.features => ('features', 4),
      LandingSection.marketplace => ('marketplace', 5),
      LandingSection.pricing => ('pricing', 6),
    };

    _trackSectionView(sectionData.$1, sectionData.$2);
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
    // Track navigation click for analytics
    _trackNavClick(section);

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

  /// Track navigation item click for analytics
  void _trackNavClick(LandingSection targetSection) {
    _navClicksCount++;
    final currentSection = _activeSection?.name ?? 'unknown';
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingNavClick(
          sectionName: targetSection.name,
          currentSection: currentSection,
          scrollPosition: scrollPosition,
        );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  /// Track "Learn more" scroll indicator click
  void _trackLearnMoreClick() {
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingLearnMoreClick(scrollPosition: scrollPosition);
  }

  /// Track Sign In button click
  void _trackSignInClick() {
    final currentSection = _activeSection?.name ?? 'unknown';
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingSignInClick(
          currentSection: currentSection,
          scrollPosition: scrollPosition,
        );
  }

  /// Track Final CTA "Create Your First Scraper" button click
  void _trackFinalCtaCreateClick() {
    _ctaClicksCount++;
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingFinalCtaClick(
          buttonType: 'create_scraper',
          scrollPosition: scrollPosition,
        );
  }

  /// Track Final CTA "Browse Marketplace" button click
  void _trackFinalCtaMarketplaceClick() {
    _ctaClicksCount++;
    final scrollPosition = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    ref
        .read(analyticsServiceProvider)
        .trackLandingFinalCtaClick(
          buttonType: 'browse_marketplace',
          scrollPosition: scrollPosition,
        );
  }

  /// Track engagement summary when user leaves the landing page
  void _trackEngagementSummary() {
    final engagementTimeSeconds = DateTime.now()
        .difference(_pageViewStartTime)
        .inSeconds;

    // Only track if user spent more than 1 second on the page
    if (engagementTimeSeconds < 1) return;

    ref
        .read(analyticsServiceProvider)
        .trackLandingEngagement(
          engagementTimeSeconds: engagementTimeSeconds,
          maxScrollDepthPercentage: _maxScrollDepthPercentage,
          sectionsViewed: _viewedSections.toList(),
          navClicksCount: _navClicksCount,
          ctaClicksCount: _ctaClicksCount,
        );
  }

  @override
  void dispose() {
    // Track engagement summary before disposing
    _trackEngagementSummary();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrapChatState = ref.watch(scrapChatProvider);

    // Listen for state changes to show/hide the creating scrappable dialog
    ref.listen(scrapChatProvider, (previous, next) {
      // Check if we're entering the creatingScrappable state
      final isCreating = next.maybeWhen(
        creatingScrappable: (referenceLink, chunks, grounding) => true,
        orElse: () => false,
      );

      if (isCreating && !_isCreatingDialogShowing) {
        _isCreatingDialogShowing = true;
        CreatingScrappableDialog.show(context).then((_) {
          _isCreatingDialogShowing = false;
        });
      }
    });

    // Show the appropriate view based on state
    return scrapChatState.maybeWhen(
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
        if (exception.title == 'Suspicious Connection Detected') {
          return Scaffold(body: SuspiciousIpErrorView(exception: exception));
        }
        return Scaffold(body: ZenErrorTab(exception));
      },
      // For blank, creatingSessionState, and creatingScrappable states, show landing page
      // The creatingScrappable state will have the dialog shown on top via the listener
      orElse: () => _LandingPageContent(
        scaffoldKey: _scaffoldKey,
        scrollController: _scrollController,
        backgroundController: _backgroundController,
        activeSection: _activeSection,
        isScrolled: _isScrolled,
        learnMoreOpacity: _learnMoreOpacity,
        heroKey: _heroKey,
        howItWorksKey: _howItWorksKey,
        autoFixKey: _autoFixKey,
        featuresKey: _featuresKey,
        marketplaceKey: _marketplaceKey,
        pricingKey: _pricingKey,
        onSectionTap: _scrollToSection,
        onSignInTap: _trackSignInClick,
        onScrollToTop: _scrollToTop,
        onLearnMoreTap: () {
          _trackLearnMoreClick();
          _scrollToSection(LandingSection.howItWorks);
        },
        onFinalCtaCreateTap: _trackFinalCtaCreateClick,
        onFinalCtaMarketplaceTap: _trackFinalCtaMarketplaceClick,
        onPageViewTracked: () {
          if (!_hasTrackedPageView) {
            _hasTrackedPageView = true;
            ref.read(analyticsServiceProvider).trackLandingPageView();
            _trackSectionView('hero', 0);
          }
        },
      ),
    );
  }
}

/// Landing page content widget - proper widget class instead of build method
class _LandingPageContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;
  final AnimationController backgroundController;
  final LandingSection? activeSection;
  final bool isScrolled;
  final double learnMoreOpacity;
  final GlobalKey heroKey;
  final GlobalKey howItWorksKey;
  final GlobalKey autoFixKey;
  final GlobalKey featuresKey;
  final GlobalKey marketplaceKey;
  final GlobalKey pricingKey;
  final void Function(LandingSection) onSectionTap;
  final VoidCallback onSignInTap;
  final VoidCallback onScrollToTop;
  final VoidCallback onLearnMoreTap;
  final VoidCallback onFinalCtaCreateTap;
  final VoidCallback onFinalCtaMarketplaceTap;
  final VoidCallback onPageViewTracked;

  const _LandingPageContent({
    required this.scaffoldKey,
    required this.scrollController,
    required this.backgroundController,
    required this.activeSection,
    required this.isScrolled,
    required this.learnMoreOpacity,
    required this.heroKey,
    required this.howItWorksKey,
    required this.autoFixKey,
    required this.featuresKey,
    required this.marketplaceKey,
    required this.pricingKey,
    required this.onSectionTap,
    required this.onSignInTap,
    required this.onScrollToTop,
    required this.onLearnMoreTap,
    required this.onFinalCtaCreateTap,
    required this.onFinalCtaMarketplaceTap,
    required this.onPageViewTracked,
  });

  static const _appBarHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    // Track page view once when landing page is built
    onPageViewTracked();

    // SEO meta tags for the landing page
    // Note: Open Graph and Twitter Card tags must be set in index.html
    // as social media crawlers don't execute JavaScript
    return Seo.head(
      tags: const [
        // Primary meta tags for search engines
        MetaTag(
          name: 'title',
          content: 'ZenScrap - AI-Powered Web Scrapers That Fix Themselves',
        ),
        MetaTag(
          name: 'description',
          content:
              'Create self-healing web scrapers with AI. Describe what you want to extract and get a ready-to-use API endpoint. No code, no CSS selectors, no maintenance. Free to start.',
        ),
        MetaTag(
          name: 'keywords',
          content:
              'web scraping, AI scraper, self-healing scraper, web data extraction, API, no-code scraping, automated scraping, data extraction tool, web scraper API, scraping service',
        ),
        MetaTag(name: 'author', content: 'ZenScrap'),
        MetaTag(name: 'robots', content: 'index, follow'),
        MetaTag(
          name: 'googlebot',
          content: 'index, follow, max-snippet:-1, max-image-preview:large',
        ),
        // Canonical URL to prevent duplicate content issues
        LinkTag(rel: 'canonical', href: 'https://zenscrap.com/'),
        // Language and locale
        MetaTag(name: 'language', content: 'en'),
        // Application metadata
        MetaTag(name: 'application-name', content: 'ZenScrap'),
        MetaTag(name: 'theme-color', content: '#607D8B'),
      ],
      child: Scaffold(
        key: scaffoldKey,
        // Make scaffold background transparent so Lottie shows through
        backgroundColor: Colors.transparent,
        // Mobile drawer for navigation
        endDrawer: LandingMobileDrawer(
          activeSection: activeSection,
          onSectionTap: onSectionTap,
          onSignInTap: onSignInTap,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeroHeight = constraints.maxHeight - _appBarHeight;

            return Stack(
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
                        controller: backgroundController,
                        onLoaded: (composition) {
                          backgroundController.repeat();
                        },
                      ),
                    ),
                  ),

                // Scrollable content with transparent background
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // Spacer for appbar
                    const SliverToBoxAdapter(
                      child: SizedBox(height: _appBarHeight),
                    ),

                    // Hero Section - key on the child widget, not the sliver
                    SliverToBoxAdapter(
                      child: HeroSection(
                        key: heroKey,
                        availableHeight: availableHeroHeight,
                      ),
                    ),

                    // Problem Section
                    const SliverToBoxAdapter(child: ProblemSection()),

                    // How It Works Section - key on the child widget
                    SliverToBoxAdapter(
                      child: HowItWorksSection(key: howItWorksKey),
                    ),

                    // Auto-Fix Section - key on the child widget
                    SliverToBoxAdapter(child: AutoFixSection(key: autoFixKey)),

                    // Features Section - key on the child widget
                    SliverToBoxAdapter(
                      child: FeaturesSection(key: featuresKey),
                    ),

                    // Marketplace Section - key on the child widget
                    SliverToBoxAdapter(
                      child: MarketplaceSection(key: marketplaceKey),
                    ),

                    // Pricing Section - key on the Container wrapper
                    SliverToBoxAdapter(
                      child: _PricingSection(pricingKey: pricingKey),
                    ),

                    // Final CTA Section
                    SliverToBoxAdapter(
                      child: FinalCtaSection(
                        onScrollToTop: onScrollToTop,
                        onCreateScraperTap: onFinalCtaCreateTap,
                        onBrowseMarketplaceTap: onFinalCtaMarketplaceTap,
                      ),
                    ),
                  ],
                ),

                // Fixed floating appbar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LandingAppBar(
                    activeSection: activeSection,
                    isScrolled: isScrolled,
                    onSectionTap: onSectionTap,
                    onSignInTap: onSignInTap,
                    onMenuTap: () => scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ),

                // "Learn more" scroll indicator - overlays on top, fades out on scroll
                if (DeviceUtils.isDesktop)
                  if (learnMoreOpacity > 0)
                    _LearnMoreIndicator(
                      opacity: learnMoreOpacity,
                      onTap: onLearnMoreTap,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Pricing section widget
class _PricingSection extends StatelessWidget {
  final GlobalKey pricingKey;

  const _PricingSection({required this.pricingKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: pricingKey,
      // No background - transparent
      padding: EdgeInsets.symmetric(
        vertical: context.responsiveValue(compact: 40.0, expanded: 60.0),
        horizontal: context.responsiveValue(compact: 20.0, expanded: 40.0),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.landing_pricing_title,
            style: context.responsiveValue(
              compact: context.t.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
              expanded: context.t.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.landing_pricing_subtitle,
            style: context.t.titleMedium?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.responsiveValue(compact: 32.0, expanded: 48.0),
          ),
          SizedBox(
            height: context.responsiveValue(compact: 1200.0, expanded: 980.0),
            child: const RawPricingPageComponent(isInsideLandingPage: true),
          ),
        ],
      ),
    );
  }
}

/// if(DeviceUtils)
/// "Learn more" scroll indicator widget
class _LearnMoreIndicator extends StatelessWidget {
  final double opacity;
  final VoidCallback onTap;

  const _LearnMoreIndicator({required this.opacity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: opacity < 0.5,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: opacity,
          child: Center(
            child: GestureDetector(
              onTap: onTap,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.landing_learn_more,
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
          ),
        ),
      ),
    );
  }
}
