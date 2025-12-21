import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:seo/seo.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/contact_support_button.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/confirm_email_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/login_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/password_reset_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/password_reset_validate_code_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/sign_in_page.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/ui/legal/terms_of_service_dialog.dart';
import 'package:zenscrap_flutter/src/ui/legal/privacy_policy_dialog.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView>
    with TickerProviderStateMixin, EditScrappable {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );
  late final EmailAuthController _emailAuth;

  final ValueNotifier<String?> _isConfirmEmail = ValueNotifier(null);
  final ValueNotifier<String?> _resetPasswordEmailVN = ValueNotifier(null);
  SelectedAuthPage _selectedAuthPage = SelectedAuthPage.login;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final client = ref.read(clientProvider);
    _emailAuth = EmailAuthController(
      client: client,
      startScreen: EmailFlowScreen.login,
      onAuthenticated: _onAuthSuccess,
      onError: _onAuthError,
    );
    _tabController.addListener(_setTab);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 22,
      ), // Default duration of the animation
    );
  }

  void _onAuthSuccess() {
    // Authentication was successful - the session state is updated by individual pages
    // that have access to the user's email and name from form inputs
  }

  void _onAuthError(Object error) {
    // Error is handled by each page individually
  }

  void _setTab() {
    setState(() {
      _selectedAuthPage = SelectedAuthPage.values[_tabController.index];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isConfirmEmail.dispose();
    _resetPasswordEmailVN.dispose();
    _tabController.removeListener(_setTab);
    _controller.dispose();
    _emailAuth.dispose();
    super.dispose();
  }

  void _onChangeToConfirmEmail(String email) {
    _isConfirmEmail.value = email;
  }

  Future<void> _onSuccessConfirmEmail() async {
    final l10n = AppLocalizations.of(context)!;
    await showOkAlertDialog(
      context: context,
      title: l10n.auth_email_confirmed_title,
      message: l10n.auth_email_confirmed_message,
      okLabel: l10n.auth_ok_button,
      barrierDismissible: true,
      useRootNavigator: false,
    );
    _isConfirmEmail.value = null;
    _tabController.animateTo(0);
  }

  void _onChangeToPasswordReset(String email) {
    _resetPasswordEmailVN.value = email;
  }

  void _onSuccessChangePassword() {
    _resetPasswordEmailVN.value = null;
    _tabController.animateTo(0);
  }

  void _onGoBackFromConfirmEmail() {
    // Clear the confirm email state to go back to the sign up form.
    // Note: We intentionally do NOT clear PendingRegistrationData here,
    // so the form will still have access to the userName and password
    // if the user returns to the sign up form.
    _isConfirmEmail.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final scrapChatState = ref.watch(scrapChatProvider);
    final scrappable = scrapChatState.maybeMap(
      standard: (state) => state.data,
      orElse: () => null,
    );

    // SEO meta tags for the authentication page
    return Seo.head(
      tags: const [
        MetaTag(
          name: 'title',
          content: 'Sign In | ZenScrap - AI-Powered Web Scraping Platform',
        ),
        MetaTag(
          name: 'description',
          content:
              'Sign in or create your ZenScrap account. Access AI-powered web scrapers, manage your endpoints, and start extracting data automatically.',
        ),
        MetaTag(
          name: 'keywords',
          content:
              'ZenScrap login, sign in, create account, web scraping account, API access',
        ),
        MetaTag(name: 'robots', content: 'index, follow'),
        LinkTag(rel: 'canonical', href: 'https://zenscrap.com/auth'),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Background Lottie animation
            SizedBox.expand(
              child: Lottie.network(
                'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
                decoder: customDecoder,
                fit: BoxFit.fitWidth,
                controller: _controller,
                onLoaded: (composition) {
                  _controller.repeat();
                },
              ),
            ).animate().fadeIn(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 800),
            ),
            // Terms of Service and Privacy Policy links - bottom right corner
            _LegalLinksFooter(),
            // Main content with responsive layout
            Center(
              child: ResponsiveBuilder(
                compact: (context, constraints) => _MobileAuthLayout(
                  tabController: _tabController,
                  emailAuth: _emailAuth,
                  isConfirmEmail: _isConfirmEmail,
                  resetPasswordEmailVN: _resetPasswordEmailVN,
                  onChangeToConfirmEmail: _onChangeToConfirmEmail,
                  onSuccessConfirmEmail: _onSuccessConfirmEmail,
                  onChangeToPasswordReset: _onChangeToPasswordReset,
                  onSuccessChangePassword: _onSuccessChangePassword,
                  onGoBackFromConfirmEmail: _onGoBackFromConfirmEmail,
                  scrappable: scrappable,
                ),
                expanded: (context, constraints) => _DesktopAuthLayout(
                  tabController: _tabController,
                  emailAuth: _emailAuth,
                  isConfirmEmail: _isConfirmEmail,
                  resetPasswordEmailVN: _resetPasswordEmailVN,
                  onChangeToConfirmEmail: _onChangeToConfirmEmail,
                  onSuccessConfirmEmail: _onSuccessConfirmEmail,
                  onChangeToPasswordReset: _onChangeToPasswordReset,
                  onSuccessChangePassword: _onSuccessChangePassword,
                  onGoBackFromConfirmEmail: _onGoBackFromConfirmEmail,
                  selectedAuthPage: _selectedAuthPage,
                  scrappable: scrappable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthContainer extends StatelessWidget {
  const _AuthContainer({
    required this.tabController,
    required this.emailAuth,
    required this.isConfirmEmail,
    required this.resetPasswordEmailVN,
    required this.onChangeToConfirmEmail,
    required this.onSuccessConfirmEmail,
    required this.onChangeToPasswordReset,
    required this.onSuccessChangePassword,
    this.onGoBackFromConfirmEmail,
  });

  final TabController tabController;
  final EmailAuthController emailAuth;
  final ValueNotifier<String?> isConfirmEmail;
  final ValueNotifier<String?> resetPasswordEmailVN;
  final void Function(String) onChangeToConfirmEmail;
  final Future<void> Function() onSuccessConfirmEmail;
  final void Function(String) onChangeToPasswordReset;
  final void Function() onSuccessChangePassword;
  final VoidCallback? onGoBackFromConfirmEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: isConfirmEmail,
            builder: (context, String? email, _) {
              final isEmailActivated = email != null;
              return ValueListenableBuilder<String?>(
                valueListenable: resetPasswordEmailVN,
                builder: (context, String? passwordEmail, child) {
                  final isPasswordEmail = passwordEmail != null;
                  final isHover = isEmailActivated || isPasswordEmail;
                  final l10n = AppLocalizations.of(context)!;
                  return IgnorePointer(
                    ignoring: isHover,
                    child: Opacity(
                      opacity: isHover ? 0.7 : 1,
                      child: TabBar(
                        controller: tabController,
                        tabs: [
                          Tab(
                            text: l10n.auth_login_tab,
                            icon: Icon(Icons.login),
                          ),
                          Tab(
                            text: l10n.auth_sign_up_tab,
                            icon: Icon(Icons.person_add),
                          ),
                          Tab(
                            text: l10n.auth_password_reset_tab,
                            icon: Icon(Icons.vpn_key),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox.expand(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      LoginPage(
                        emailAuth: emailAuth,
                        onChangeToConfirmPassword: onChangeToConfirmEmail,
                      ),
                      SignInPage(
                        emailAuth: emailAuth,
                        onChangeToConfirmPassword: onChangeToConfirmEmail,
                      ),
                      PasswordResetPage(
                        emailAuth: emailAuth,
                        onChangeToPasswordReset: onChangeToPasswordReset,
                      ),
                    ],
                  ),
                ),
                SizedBox.expand(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: isConfirmEmail,
                    builder: (context, String? email, _) {
                      final haveEmail = email != null;

                      return IgnorePointer(
                        ignoring: !haveEmail,
                        child: AnimatedOpacity(
                          opacity: haveEmail ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ConfirmEmailPage(
                              emailAuth: emailAuth,
                              email: haveEmail ? email : '',
                              onSuccessChangePassword: onSuccessConfirmEmail,
                              onGoBack: onGoBackFromConfirmEmail,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox.expand(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: resetPasswordEmailVN,
                    builder: (context, String? email, child) {
                      final haveEmail = email != null;
                      return IgnorePointer(
                        ignoring: !haveEmail,
                        child: AnimatedOpacity(
                          opacity: haveEmail ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: PasswordResetValidateCodePage(
                              key: ValueKey(email),
                              emailAuth: emailAuth,
                              email: haveEmail ? email : '',
                              onSuccessChangePassword: onSuccessChangePassword,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum SelectedAuthPage { login, signIn, passwordReset }

/// Legal links footer positioned at bottom right corner
class _LegalLinksFooter extends StatelessWidget {
  const _LegalLinksFooter();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.responsiveValue(compact: 8.0, expanded: 16.0),
      right: context.responsiveValue(compact: 8.0, expanded: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TermsOfServiceLink(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey[600],
            ),
          ),
          SizedBox(
            width: context.responsiveValue(compact: 12.0, expanded: 16.0),
          ),
          PrivacyPolicyLink(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile layout for auth view - stacked vertically with smaller animation
class _MobileAuthLayout extends StatelessWidget {
  final TabController tabController;
  final EmailAuthController emailAuth;
  final ValueNotifier<String?> isConfirmEmail;
  final ValueNotifier<String?> resetPasswordEmailVN;
  final void Function(String) onChangeToConfirmEmail;
  final Future<void> Function() onSuccessConfirmEmail;
  final void Function(String) onChangeToPasswordReset;
  final void Function() onSuccessChangePassword;
  final VoidCallback onGoBackFromConfirmEmail;
  final Scrappable? scrappable;

  const _MobileAuthLayout({
    required this.tabController,
    required this.emailAuth,
    required this.isConfirmEmail,
    required this.resetPasswordEmailVN,
    required this.onChangeToConfirmEmail,
    required this.onSuccessConfirmEmail,
    required this.onChangeToPasswordReset,
    required this.onSuccessChangePassword,
    required this.onGoBackFromConfirmEmail,
    this.scrappable,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Compact Lottie animation at top
          Transform.scale(
            scale: 1.4,
            child: Lottie.network(
              'https://lottie.host/6778c6b9-32ee-401c-bc8f-97eea151b1df/U3LT3t31Wa.lottie',
              decoder: customDecoder,
              width: double.maxFinite,
              height: 160,
              fit: BoxFit.fitHeight,
            ),
          ),
          // Form section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title row
                  if (context.canPop()) _BackButton(),
                  Text(
                    l10n.auth_welcome,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  // Auth form container
                  Expanded(
                    child: _AuthContainer(
                      tabController: tabController,
                      emailAuth: emailAuth,
                      isConfirmEmail: isConfirmEmail,
                      resetPasswordEmailVN: resetPasswordEmailVN,
                      onChangeToConfirmEmail: onChangeToConfirmEmail,
                      onSuccessConfirmEmail: onSuccessConfirmEmail,
                      onChangeToPasswordReset: onChangeToPasswordReset,
                      onSuccessChangePassword: onSuccessChangePassword,
                      onGoBackFromConfirmEmail: onGoBackFromConfirmEmail,
                    ),
                  ),
                  // Scrappable indicator if available
                  if (scrappable != null) ...[
                    const SizedBox(height: 12),
                    ScrappableCardIndicator(
                      accountId: null,
                      scrappable: scrappable!,
                    ),
                  ],
                  const SizedBox(height: 12),
                  const ContactSupportButton(),
                  // Extra padding for legal links footer
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop layout for auth view - side by side with large animation
class _DesktopAuthLayout extends StatelessWidget {
  final TabController tabController;
  final EmailAuthController emailAuth;
  final ValueNotifier<String?> isConfirmEmail;
  final ValueNotifier<String?> resetPasswordEmailVN;
  final void Function(String) onChangeToConfirmEmail;
  final Future<void> Function() onSuccessConfirmEmail;
  final void Function(String) onChangeToPasswordReset;
  final void Function() onSuccessChangePassword;
  final VoidCallback onGoBackFromConfirmEmail;
  final SelectedAuthPage selectedAuthPage;
  final Scrappable? scrappable;

  const _DesktopAuthLayout({
    required this.tabController,
    required this.emailAuth,
    required this.isConfirmEmail,
    required this.resetPasswordEmailVN,
    required this.onChangeToConfirmEmail,
    required this.onSuccessConfirmEmail,
    required this.onChangeToPasswordReset,
    required this.onSuccessChangePassword,
    required this.onGoBackFromConfirmEmail,
    required this.selectedAuthPage,
    this.scrappable,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Row(
        children: [
          const SizedBox(width: 20),
          // Left side - Form section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (context.canPop()) ...[
                    _BackButton(),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    l10n.auth_welcome,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 20),
                  // Animated height container for auth form
                  // Listens to isConfirmEmail to adjust height when showing
                  // verification code flow (smaller form)
                  ValueListenableBuilder<String?>(
                    valueListenable: isConfirmEmail,
                    builder: (context, confirmEmail, _) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: resetPasswordEmailVN,
                        builder: (context, resetEmail, _) {
                          final isInVerificationFlow = confirmEmail != null;
                          final isInPasswordResetFlow = resetEmail != null;

                          return AnimatedContainer(
                            height: _calculateAuthContainerHeight(
                              selectedAuthPage: selectedAuthPage,
                              isInVerificationFlow: isInVerificationFlow,
                              isInPasswordResetFlow: isInPasswordResetFlow,
                            ),
                            duration: const Duration(milliseconds: 700),
                            child: _AuthContainer(
                              tabController: tabController,
                              emailAuth: emailAuth,
                              isConfirmEmail: isConfirmEmail,
                              resetPasswordEmailVN: resetPasswordEmailVN,
                              onChangeToConfirmEmail: onChangeToConfirmEmail,
                              onSuccessConfirmEmail: onSuccessConfirmEmail,
                              onChangeToPasswordReset: onChangeToPasswordReset,
                              onSuccessChangePassword: onSuccessChangePassword,
                              onGoBackFromConfirmEmail: onGoBackFromConfirmEmail,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Scrappable indicator if available
                  if (scrappable != null) ...[
                    const SizedBox(height: 16),
                    ScrappableCardIndicator(
                      accountId: null,
                      scrappable: scrappable!,
                    ),
                  ],
                  const SizedBox(height: 16),
                  const ContactSupportButton(),
                ],
              ),
            ),
          ),
          // Right side - Lottie animation
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child:
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Lottie.network(
                        'https://lottie.host/6778c6b9-32ee-401c-bc8f-97eea151b1df/U3LT3t31Wa.lottie',
                        decoder: customDecoder,
                        width: double.maxFinite,
                        fit: BoxFit.fitWidth,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 200),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Calculates the height for the auth container based on current state.
/// Heights are adjusted when in verification/reset flows to show smaller forms.
double _calculateAuthContainerHeight({
  required SelectedAuthPage selectedAuthPage,
  required bool isInVerificationFlow,
  required bool isInPasswordResetFlow,
}) {
  // When in verification code flow (Sign Up confirmation), use smaller height
  // since only one field is shown (plus the "Change email" button)
  if (isInVerificationFlow) {
    return 290;
  }

  // When in password reset code flow, use height for 3 fields
  // (code + new password + confirm password)
  if (isInPasswordResetFlow) {
    return 400;
  }

  // Default heights based on selected page
  return switch (selectedAuthPage) {
    SelectedAuthPage.login => 388,
    SelectedAuthPage.signIn => 455,
    SelectedAuthPage.passwordReset => 270,
  };
}

/// Reusable back button widget for both layouts
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.c.surfaceContainerHighest,
      child: IconButton(
        onPressed: context.pop,
        icon: const Icon(Icons.arrow_back),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
    );
  }
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
