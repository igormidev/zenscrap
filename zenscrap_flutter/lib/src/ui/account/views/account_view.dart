import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/contact_support_button.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/language_selector.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_provider.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_state.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/brightness_picker.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/color_option.dart';

class AccountView extends ConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);

    final accountInfo = ref
        .watch(accountProvider)
        .mapOrNull(withData: (value) => value.accountInfo);
    final session = ref
        .watch(sessionProvider)
        .mapOrNull(logged: (value) => value);
    if (accountInfo == null || session == null) {
      return SizedBox.fromSize();
    }

    // Track page view when account page is displayed
    analytics.trackAccountPageView(
      userName: session.user.userName,
      email: session.user.email,
      planTier: accountInfo.planTier.displayName,
    );

    return ResponsiveBuilder(
      compact: (context, constraints) => _MobileLayout(
        user: session.user,
        accountInfo: accountInfo,
        analytics: analytics,
      ),
      medium: (context, constraints) => _TabletLayout(
        user: session.user,
        accountInfo: accountInfo,
        analytics: analytics,
      ),
      expanded: (context, constraints) => _DesktopLayout(
        user: session.user,
        accountInfo: accountInfo,
        analytics: analytics,
      ),
    );
  }
}

/// Mobile layout - single column with scrollable content
class _MobileLayout extends StatelessWidget {
  final UserModel user;
  final AccountInfo accountInfo;
  final AnalyticsService analytics;

  const _MobileLayout({
    required this.user,
    required this.accountInfo,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
    );

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      children: [
        SizedBox(
          height: context.responsiveValue(
            compact: 24.0,
            medium: 40.0,
            expanded: 60.0,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.account_title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          height: context.responsiveValue(
            compact: 16.0,
            medium: 20.0,
            expanded: 24.0,
          ),
        ),
        _AccountInformationCard(
          user: user,
          accountInfo: accountInfo,
          analytics: analytics,
        ),
        SizedBox(
          height: context.responsiveValue(
            compact: 20.0,
            medium: 24.0,
            expanded: 27.0,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.account_appearance_title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          height: context.responsiveValue(
            compact: 16.0,
            medium: 20.0,
            expanded: 24.0,
          ),
        ),
        _ThemeCustomizationSection(),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Tablet layout - similar to mobile but with more spacing
class _TabletLayout extends StatelessWidget {
  final UserModel user;
  final AccountInfo accountInfo;
  final AnalyticsService analytics;

  const _TabletLayout({
    required this.user,
    required this.accountInfo,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: _MobileLayout(
          user: user,
          accountInfo: accountInfo,
          analytics: analytics,
        ),
      ),
    );
  }
}

/// Desktop layout - two column layout with account info and theme customization side by side
class _DesktopLayout extends StatelessWidget {
  final UserModel user;
  final AccountInfo accountInfo;
  final AnalyticsService analytics;

  const _DesktopLayout({
    required this.user,
    required this.accountInfo,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 900.0,
            expanded: 1100.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      AppLocalizations.of(context)!.account_title,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 24),
                    _AccountInformationCard(
                      user: user,
                      accountInfo: accountInfo,
                      analytics: analytics,
                    ),
                    SizedBox(height: 20),
                    // Language Card
                    const LanguageSelectorCard(),
                  ],
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  compact: 16.0,
                  medium: 20.0,
                  expanded: 24.0,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 0),
                    _ThemeCustomizationSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Account information card widget
class _AccountInformationCard extends StatelessWidget {
  final UserModel user;
  final AccountInfo accountInfo;
  final AnalyticsService analytics;

  const _AccountInformationCard({
    required this.user,
    required this.accountInfo,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.responsiveValue(
      compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      medium: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      expanded: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );

    final borderRadius = context.responsiveValue(
      compact: 8.0,
      medium: 10.0,
      expanded: 12.0,
    );

    return Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: context.c.outline.withAlpha(51), width: 1),
        color: context.c.surfaceContainerLowest.withAlpha(100),
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 16.0,
              expanded: 20.0,
            ),
          ),
          // Profile image editing not available in new IDP system
          // UserEditableProfileImage is disabled until we have a way to update profile
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 16.0,
              expanded: 20.0,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.account_information_title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 14.0,
              expanded: 16.0,
            ),
          ),
          _AccountDisplayTime(
            title: AppLocalizations.of(context)!.account_user_name_label,
            content: user.userName,
            analytics: analytics,
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 14.0,
              expanded: 16.0,
            ),
          ),
          _AccountDisplayTime(
            title: AppLocalizations.of(context)!.account_email_label,
            content: user.email,
            analytics: analytics,
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 14.0,
              expanded: 16.0,
            ),
          ),
          _AccountDisplayTime(
            title: AppLocalizations.of(
              context,
            )!.account_subscription_plan_label,
            content: accountInfo.planTier.displayName,
            analytics: analytics,
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 16.0,
              medium: 18.0,
              expanded: 20.0,
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: ContactSupportButton(),
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 14.0,
              expanded: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDisplayTime extends StatelessWidget {
  final String title;
  final String content;
  final AnalyticsService analytics;
  const _AccountDisplayTime({
    required this.title,
    required this.content,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = context.responsiveValue(
      compact: 6.0,
      medium: 7.0,
      expanded: 8.0,
    );

    final horizontalPadding = context.responsiveValue(
      compact: 12.0,
      medium: 14.0,
      expanded: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BabelText(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: context.responsiveValue(
            compact: 6.0,
            medium: 7.0,
            expanded: 8.0,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.c.surfaceContainerLow,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.only(left: horizontalPadding, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.c.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: content));

                  // Track copy action
                  await analytics.trackAccountInfoCopy(
                    fieldName: title,
                    fieldValue: content,
                  );
                },
                icon: const Icon(Icons.copy),
              ),
              // Text('Api key: ${accountInfo?.apiKey ?? ''}'),
            ],
          ),
        ),
      ],
    );
  }
}

BoxDecoration getStandardCardContainerDecoration(BuildContext context) {
  return BoxDecoration(
    color: context.c.onPrimary,
    // color: context.c.onPrimary,
    borderRadius: BorderRadius.circular(16),
    // border: Border.all(
    //   color: context.c.surfaceContainerHighest,
    // ),
    boxShadow: [
      BoxShadow(
        color: context.c.surfaceContainerHighest.withAlpha(160),
        // color: context.c.surfaceContainerHighest.withAlpha(128),
        // color: Colors.grey.withAlpha(128),
        blurRadius: 20.0, // soften the shadow
        spreadRadius: 0.0, //extend the shadow
        offset: const Offset(
          5.0, // Move to right 10  horizontally
          5.0, // Move to bottom 10 Vertically
        ),
      ),
    ],
  );
}

class _ThemeCustomizationSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        Text(
          AppLocalizations.of(context)!.account_appearance_title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 24),
        // Brightness Card
        _ThemeCard(
          icon: Icons.brightness_6_rounded,
          title: AppLocalizations.of(context)!.account_display_mode_title,
          subtitle: AppLocalizations.of(context)!.account_display_mode_subtitle,
          child: BrightnessPicker(
            brightness: themeState.brightness,
            onBrightnessChanged: themeNotifier.selectBrightness,
          ),
        ),
        const SizedBox(height: 27),
        // Color Card
        _ThemeCard(
          icon: Icons.palette_rounded,
          title: AppLocalizations.of(context)!.account_accent_color_title,
          subtitle: AppLocalizations.of(context)!.account_accent_color_subtitle,
          child: _ColorPaletteGrid(
            selectedColor: themeState.seedColor,
            onColorSelected: themeNotifier.selectColor,
          ),
        ),
        const SizedBox(height: 27),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _ThemeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.responsiveValue(
      compact: 16.0,
      medium: 18.0,
      expanded: 20.0,
    );

    final borderRadius = context.responsiveValue(
      compact: 8.0,
      medium: 10.0,
      expanded: 12.0,
    );

    final iconPadding = context.responsiveValue(
      compact: 8.0,
      medium: 9.0,
      expanded: 10.0,
    );

    final iconSize = context.responsiveValue(
      compact: 20.0,
      medium: 21.0,
      expanded: 22.0,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: context.c.outline.withAlpha(51), width: 1),
        color: context.c.surfaceContainerLowest.withAlpha(100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: context.c.primaryContainer,
                  borderRadius: BorderRadius.circular(iconPadding),
                ),
                child: Icon(icon, color: context.c.primary, size: iconSize),
              ),
              SizedBox(
                width: context.responsiveValue(
                  compact: 12.0,
                  medium: 13.0,
                  expanded: 14.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 16.0,
              medium: 18.0,
              expanded: 20.0,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

bool _removeBlackAndWhite(Color color) =>
    color != Colors.black && color != Colors.white;

class _ColorPaletteGrid extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorPaletteGrid({
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = const <Color>[Colors.black, Colors.white]
        .followedBy(Colors.primaries.reversed)
        .followedBy(Colors.accents)
        .where(_removeBlackAndWhite)
        .toList(growable: false);

    final maxExtent = context.responsiveValue(
      compact: 42.0,
      medium: 46.0,
      expanded: 50.0,
    );

    final spacing = context.responsiveValue(
      compact: 8.0,
      medium: 9.0,
      expanded: 10.0,
    );

    return GridView.extent(
      shrinkWrap: true,
      maxCrossAxisExtent: maxExtent,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: colors
          .map((color) {
            // ignore: deprecated_member_use
            final isSelected = color.value == selectedColor.value;
            return ColorOption(
              color: color,
              isSelected: isSelected,
              onTap: () => onColorSelected(color),
            );
          })
          .toList(growable: false),
    );
  }
}
