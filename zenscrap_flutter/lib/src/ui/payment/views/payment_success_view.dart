import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

/// Payment success view shown after successful Stripe payment.
/// Displays a success message and instructions to refresh for updated subscription.
class PaymentSuccessView extends ConsumerStatefulWidget {
  /// Optional session ID from Stripe checkout
  final String? sessionId;

  const PaymentSuccessView({super.key, this.sessionId});

  @override
  ConsumerState<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends ConsumerState<PaymentSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.forward();

    // Log session ID if provided (useful for debugging)
    if (widget.sessionId != null) {
      debugPrint('Payment session ID: ${widget.sessionId}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    context.go(DashboardNavigationType.account.routeOnClick!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Responsive sizing
    final iconSize = context.responsiveValue<double>(
      compact: 80.0,
      medium: 100.0,
      expanded: 120.0,
    );

    final maxWidth = context.responsiveValue<double>(
      compact: 400.0,
      medium: 500.0,
      expanded: 600.0,
    );

    final horizontalPadding = context.responsiveValue<double>(
      compact: 24.0,
      medium: 32.0,
      expanded: 48.0,
    );

    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Icon with animation
                  _SuccessIcon(
                    size: iconSize,
                    color: context.c.primary,
                  )
                      .animate(controller: _controller)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 300.ms),

                  SizedBox(
                    height: context.responsiveValue(
                      compact: 24.0,
                      expanded: 32.0,
                    ),
                  ),

                  // Success Title
                  Text(
                    l10n.payment_success_title,
                    style: context.responsiveValue(
                      compact: context.t.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.c.onSurface,
                      ),
                      expanded: context.t.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.c.onSurface,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(controller: _controller)
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 16),

                  // Success Message
                  Text(
                    l10n.payment_success_message,
                    style: context.t.bodyLarge?.copyWith(
                      color: context.c.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(controller: _controller)
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),

                  SizedBox(
                    height: context.responsiveValue(
                      compact: 32.0,
                      expanded: 48.0,
                    ),
                  ),

                  // Information Card
                  _InstructionCard(
                    title: l10n.payment_success_instructions_title,
                    message: l10n.payment_success_instructions_message,
                  )
                      .animate(controller: _controller)
                      .fadeIn(delay: 600.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),

                  SizedBox(
                    height: context.responsiveValue(
                      compact: 32.0,
                      expanded: 48.0,
                    ),
                  ),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _goToDashboard,
                      icon: const Icon(Icons.dashboard_rounded),
                      label: Text(l10n.payment_success_go_to_account),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                      ),
                    ),
                  )
                      .animate(controller: _controller)
                      .fadeIn(delay: 800.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 16),

                  // Session ID debug info (only in debug mode)
                  if (widget.sessionId != null)
                    Text(
                      'Session: ${widget.sessionId}',
                      style: context.t.labelSmall?.copyWith(
                        color: context.c.onSurfaceVariant.withAlpha(128),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Success icon with checkmark in a circle
class _SuccessIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _SuccessIcon({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(26), // 10% opacity
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Icon(
        Icons.check_rounded,
        size: size * 0.6,
        color: color,
      ),
    );
  }
}

/// Instruction card with helpful information
class _InstructionCard extends StatelessWidget {
  final String title;
  final String message;

  const _InstructionCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.c.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: context.c.onPrimaryContainer,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: context.t.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
