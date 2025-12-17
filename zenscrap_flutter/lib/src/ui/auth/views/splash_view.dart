import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
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
    final client = ref.read(clientProvider);
    final isAuthenticated = client.auth.isAuthenticated;

    if (!isAuthenticated) {
      ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
      // Redirect to landing page for unauthenticated users
      if (mounted) {
        context.go('/scrappable-form');
      }
    } else {
      // User is authenticated - we don't have user profile info from AuthSuccess
      // so we use placeholder values that will be updated when account info is fetched
      ref.read(sessionProvider.notifier).setState(SessionState.logged(
        user: UserModel(
          email: 'user@zenscrap.com',
          userName: 'User',
          imageUrl: null,
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
