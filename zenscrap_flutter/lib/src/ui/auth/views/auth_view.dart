import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
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
    _emailAuth = EmailAuthController(ref.read(clientProvider).modules.auth);
    _tabController.addListener(_setTab);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 22,
      ), // Default duration of the animation
    );
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
    super.dispose();
  }

  void _onChangeToConfirmEmail(String email) {
    _isConfirmEmail.value = email;
  }

  Future<void> _onSuccessConfirmEmail() async {
    await showOkAlertDialog(
      context: context,
      title: 'Email confirmed!',
      message: 'Now you can log in with your email and password.',
      okLabel: 'OK',
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

  @override
  Widget build(BuildContext context) {
    final scrapChatState = ref.watch(scrapChatProvider);
    final scrappable = scrapChatState.maybeMap(
      standard: (state) => state.data,
      orElse: () => null,
    );

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isCompactSize = screenWidth < 1060.0;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Stack(
        children: [
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
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isCompactSize ? 600 : 1700),
              child: isCompactSize
                  ? Column(
                      children: [
                        SizedBox(height: 20),
                        Transform.scale(
                          scale: 1.6,
                          child: Lottie.network(
                            'https://lottie.host/6778c6b9-32ee-401c-bc8f-97eea151b1df/U3LT3t31Wa.lottie',
                            decoder: customDecoder,
                            width: double.maxFinite,
                            height: 200,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        // Form section for compact size
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (context.canPop())
                                  CircleAvatar(
                                    backgroundColor:
                                        context.c.surfaceContainerHighest,
                                    child: IconButton(
                                      onPressed: context.pop,
                                      icon: Icon(Icons.arrow_back),
                                    ),
                                  ),
                                Text(
                                  'Welcome',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 700),
                                    child: AuthContainer(
                                      tabController: _tabController,
                                      emailAuth: _emailAuth,
                                      isConfirmEmail: _isConfirmEmail,
                                      resetPasswordEmailVN:
                                          _resetPasswordEmailVN,
                                      onChangeToConfirmEmail:
                                          _onChangeToConfirmEmail,
                                      onSuccessConfirmEmail:
                                          _onSuccessConfirmEmail,
                                      onChangeToPasswordReset:
                                          _onChangeToPasswordReset,
                                      onSuccessChangePassword:
                                          _onSuccessChangePassword,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (scrappable != null) ...[
                                  const SizedBox(height: 16),
                                  ScrappableCardIndicator(
                                    accountId: null,
                                    scrappable: scrappable,
                                  ),
                                ],
                                const SizedBox(height: 16),
                                const ContactSupportButton(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 40,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (context.canPop()) ...[
                                  CircleAvatar(
                                    backgroundColor:
                                        context.c.surfaceContainerHighest,
                                    child: IconButton(
                                      onPressed: context.pop,
                                      icon: Icon(Icons.arrow_back),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                                Text(
                                  'Welcome',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge,
                                ),
                                const SizedBox(height: 20),
                                AnimatedContainer(
                                  height: switch (_selectedAuthPage) {
                                    SelectedAuthPage.login => 300,
                                    SelectedAuthPage.signIn => 440,
                                    SelectedAuthPage.passwordReset => 270,
                                  },
                                  duration: const Duration(milliseconds: 700),
                                  child: AuthContainer(
                                    tabController: _tabController,
                                    emailAuth: _emailAuth,
                                    isConfirmEmail: _isConfirmEmail,
                                    resetPasswordEmailVN: _resetPasswordEmailVN,
                                    onChangeToConfirmEmail:
                                        _onChangeToConfirmEmail,
                                    onSuccessConfirmEmail:
                                        _onSuccessConfirmEmail,
                                    onChangeToPasswordReset:
                                        _onChangeToPasswordReset,
                                    onSuccessChangePassword:
                                        _onSuccessChangePassword,
                                  ),
                                ),
                                if (scrappable != null) ...[
                                  const SizedBox(height: 16),
                                  ScrappableCardIndicator(
                                    accountId: null,
                                    scrappable: scrappable,
                                  ),
                                ],
                                const SizedBox(height: 16),
                                const ContactSupportButton(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Lottie.network(
                                      'https://lottie.host/6778c6b9-32ee-401c-bc8f-97eea151b1df/U3LT3t31Wa.lottie',
                                      decoder: customDecoder,
                                      width: double.maxFinite,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ).animate().fadeIn(
                                        duration: const Duration(seconds: 1),
                                        delay:
                                            const Duration(milliseconds: 200),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthContainer extends StatelessWidget {
  const AuthContainer({
    super.key,
    required this.tabController,
    required this.emailAuth,
    required this.isConfirmEmail,
    required this.resetPasswordEmailVN,
    required this.onChangeToConfirmEmail,
    required this.onSuccessConfirmEmail,
    required this.onChangeToPasswordReset,
    required this.onSuccessChangePassword,
  });

  final TabController tabController;
  final EmailAuthController emailAuth;
  final ValueNotifier<String?> isConfirmEmail;
  final ValueNotifier<String?> resetPasswordEmailVN;
  final void Function(String) onChangeToConfirmEmail;
  final Future<void> Function() onSuccessConfirmEmail;
  final void Function(String) onChangeToPasswordReset;
  final void Function() onSuccessChangePassword;

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
                  return IgnorePointer(
                    ignoring: isHover,
                    child: Opacity(
                      opacity: isHover ? 0.7 : 1,
                      child: TabBar(
                        controller: tabController,
                        tabs: const [
                          Tab(text: 'Login', icon: Icon(Icons.login)),
                          Tab(text: 'Sign In', icon: Icon(Icons.person_add)),
                          Tab(
                            text: 'Password Reset',
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ConfirmEmailPage(
                              emailAuth: emailAuth,
                              email: haveEmail ? email : '',
                              onSuccessChangePassword: onSuccessConfirmEmail,
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
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
