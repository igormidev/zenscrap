import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/contact_support_button.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/language_selector.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_provider.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_state.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/brightness_picker.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/color_option.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/user_editable_profile_image.dart';

class AccountView extends ConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);
    final user = ref.read(sessionManagerProvider).signedInUser;

    final accountInfo = ref
        .watch(accountProvider)
        .mapOrNull(withData: (value) => value.accountInfo);
    final session =
        ref.watch(sessionProvider).mapOrNull(logged: (value) => value);
    if (accountInfo == null || session == null) {
      return SizedBox.fromSize();
    }

    // Track page view when account page is displayed
    analytics.trackAccountPageView(
      userName: session.user.userName,
      email: session.user.email,
      planTier: accountInfo.planTier.displayName,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 900),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 60),
                  Text(AppLocalizations.of(context)!.account_title,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.c.outline.withAlpha(51),
                        width: 1,
                      ),
                      color: context.c.surfaceContainerLowest.withAlpha(100),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        UserEditableProfileImage(user: user),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.account_information_title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        AccountDisplayTime(
                          title: AppLocalizations.of(context)!.account_user_name_label,
                          content: session.user.userName,
                          analytics: analytics,
                        ),
                        const SizedBox(height: 16),
                        AccountDisplayTime(
                          title: AppLocalizations.of(context)!.account_email_label,
                          content: session.user.email,
                          analytics: analytics,
                        ),
                        const SizedBox(height: 16),
                        AccountDisplayTime(
                          title: AppLocalizations.of(context)!.account_subscription_plan_label,
                          content: accountInfo.planTier.displayName,
                          analytics: analytics,
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: ContactSupportButton(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Theme Customization Column
            Expanded(
              child: ListView(
                children: [
                  _ThemeCustomizationSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountDisplayTime extends StatelessWidget {
  final String title;
  final String content;
  final String? copyText;
  final AnalyticsService analytics;
  const AccountDisplayTime({
    super.key,
    required this.title,
    required this.content,
    required this.analytics,
    this.copyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BabelText(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.c.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
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
                  final textToCopy = copyText ?? content;
                  await Clipboard.setData(
                    ClipboardData(text: textToCopy),
                  );

                  // Track copy action
                  await analytics.trackAccountInfoCopy(
                    fieldName: title,
                    fieldValue: textToCopy,
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
        // Language Card
        const LanguageSelectorCard(),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outline.withAlpha(51),
          width: 1,
        ),
        color: context.c.surfaceContainerLowest.withAlpha(100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.c.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: context.c.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
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
          const SizedBox(height: 20),
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

    return GridView.extent(
      shrinkWrap: true,
      maxCrossAxisExtent: 50,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: colors.map((color) {
        // ignore: deprecated_member_use
        final isSelected = color.value == selectedColor.value;
        return ColorOption(
          color: color,
          isSelected: isSelected,
          onTap: () => onColorSelected(color),
        );
      }).toList(growable: false),
    );
  }
}
