import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserAuthState();
    });
  }

  void _getUserAuthState() async {
    final sessionManager = ref.read(sessionManagerProvider);
    final signedInUser = sessionManager.signedInUser;
    if (signedInUser == null) {
      ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
      // Redirect to landing page for unauthenticated users
      if (mounted) {
        context.go('/scrappable-form');
      }
    } else {
      final email = signedInUser.email;
      final userName = signedInUser.userName;
      if (email == null || userName == null) {
        await sessionManager.signOutAllDevices();
        ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
        if (mounted) {
          context.go('/scrappable-form');
        }
        return;
      }

      ref.read(sessionProvider.notifier).setState(SessionState.logged(
        user: UserModel(
          email: email,
          userName: userName,
          imageUrl: signedInUser.imageUrl,
        ),
      ));
      // Redirect to dashboard for authenticated users
      if (mounted) {
        context.go(DashboardNavigationType.userEndpoints.routeOnClick!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
