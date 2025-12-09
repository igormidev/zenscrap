import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';

/// A beautiful Material 3 error view for when anonymous users hit the IP-based
/// spending limit. Shows a clear message and CTA to create an account.
class IpLimitErrorView extends ConsumerStatefulWidget {
  final ZenScrapException exception;

  const IpLimitErrorView({
    super.key,
    required this.exception,
  });

  @override
  ConsumerState<IpLimitErrorView> createState() => _IpLimitErrorViewState();
}

class _IpLimitErrorViewState extends ConsumerState<IpLimitErrorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasTrackedView = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _trackView();
  }

  void _trackView() {
    if (!_hasTrackedView) {
      _hasTrackedView = true;
      ref.read(analyticsServiceProvider).trackCreateScrappableIpLimitView(
            errorTitle: widget.exception.title,
            errorDescription: widget.exception.description,
          );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon with gradient background
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.errorContainer,
                            colorScheme.error.withValues(alpha: 0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.error.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.hourglass_empty_rounded,
                        size: 56,
                        color: colorScheme.error,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      widget.exception.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Description card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.exception.description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Benefits of creating account
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primaryContainer.withValues(alpha: 0.3),
                            colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Create an account to unlock:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildBenefitItem(
                            context,
                            Icons.all_inclusive_rounded,
                            'Monthly AI credits that reset automatically',
                          ),
                          const SizedBox(height: 10),
                          _buildBenefitItem(
                            context,
                            Icons.save_rounded,
                            'Save and manage your scraping endpoints',
                          ),
                          const SizedBox(height: 10),
                          _buildBenefitItem(
                            context,
                            Icons.key_rounded,
                            'Get your own API key for production use',
                          ),
                          const SizedBox(height: 10),
                          _buildBenefitItem(
                            context,
                            Icons.analytics_rounded,
                            'Access usage analytics and history',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Primary CTA - Create Account
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: () => _navigateToSignUp(context),
                        icon: const Icon(Icons.person_add_rounded),
                        label: const Text(
                          'Create Free Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Secondary action - Go back
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _goBack(context),
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        label: const Text('Go Back'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer text
                    Text(
                      'Free accounts include \$10 in monthly AI credits',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }

  void _navigateToSignUp(BuildContext context) {
    // Track the click
    ref.read(analyticsServiceProvider).trackCreateScrappableIpLimitCreateAccountClick(
          errorTitle: widget.exception.title,
        );

    // Navigate to auth page
    context.push('/auth');
  }

  void _goBack(BuildContext context) {
    // Track the click
    ref.read(analyticsServiceProvider).trackCreateScrappableIpLimitTryAgainClick();

    // Reset the chat state and go back to the form
    ref.read(scrapChatProvider.notifier).reset();
  }
}
