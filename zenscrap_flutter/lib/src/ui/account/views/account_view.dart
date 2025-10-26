import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/contact_support_button.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
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
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 805),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('Account', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: getStandardCardContainerDecoration(context),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  UserEditableProfileImage(user: user),
                  const SizedBox(height: 20),
                  Text(
                    'Account information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  AccountDisplayTime(
                    title: 'User name',
                    content: session.user.userName,
                    analytics: analytics,
                  ),
                  const SizedBox(height: 16),
                  AccountDisplayTime(
                    title: 'Email',
                    content: session.user.email,
                    analytics: analytics,
                  ),
                  const SizedBox(height: 16),
                  AccountDisplayTime(
                    title: 'Your subscription plan',
                    content: accountInfo.planTier.displayName,
                    analytics: analytics,
                    // content: accountInfo.accountApiKey?.apiKey ?? '',
                  ),
                  // AccountDisplayTime(
                  //   title: 'Your account <b>nano id<b>',
                  //   content: accountInfo.planTier.displayName,
                  //   // content: accountInfo.accountApiKey?.apiKey ?? '',
                  // ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ContactSupportButton(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              // child: const CircularUserImage(),
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
