import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

/// Splash view that checks authentication state and redirects accordingly.
/// Works at all screen sizes with centered loading indicator.
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
      // User is authenticated - fetch real user profile from Serverpod auth module
      try {
        final userProfile = await client.modules.auth_core.userProfileInfo
            .get();
        ref
            .read(sessionProvider.notifier)
            .setState(
              SessionState.logged(
                user: UserModel(
                  email: userProfile.email ?? 'unknown@zenscrap.com',
                  userName:
                      userProfile.fullName ?? userProfile.userName ?? 'User',
                  imageUrl: userProfile.imageUrl?.toString(),
                ),
              ),
            );
      } catch (e, s) {
        talker.error('Did not finded user', e, s);
        // Fallback if profile fetch fails - user is still authenticated
        ref
            .read(sessionProvider.notifier)
            .setState(
              SessionState.logged(
                user: UserModel(
                  email: 'user@zenscrap.com',
                  userName: 'User',
                  imageUrl: null,
                ),
              ),
            );
      }
      // Redirect to dashboard for authenticated users
      if (mounted) {
        context.go(DashboardNavigationType.userEndpoints.routeOnClick!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive loading indicator size
    final indicatorSize = context.responsiveValue(
      compact: 36.0,
      expanded: 48.0,
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
