import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/splash_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/initial_chat_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = StateProvider((ref) {
  final sessionState = ref.watch(sessionProvider);
  final haveUser = sessionState.maybeMap(
    orElse: () => false,
    logged: (_) => true,
  );
  final isLoading = sessionState.maybeMap(
    orElse: () => false,
    loading: (_) => true,
  );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    observers: <NavigatorObserver>[
      if (kDebugMode) TalkerRouteObserver(talker),
    ],
    redirect: (context, state) {
      final path = state.fullPath;

      // Don't redirect while session is still loading
      if (isLoading) {
        return null;
      }

      if (path == '/splash') {
        return null;
      }
      if (path == null) {
        return '/splash';
      }

      if (haveUser == false) {
        // Allow unauthenticated access to auth, splash, and review session routes
        // The review route is public so anyone can help review hardcoded strings
        if (path.contains('/create-scrappable') == false &&
            path.contains('/splash') == false) {
          return '/splash';
        }
      } else {
        // If user is authenticated and trying to access auth page, redirect to labels
        if (path == '/create-scrappable' ||
            path.contains('/create-scrappable')) {
          return '/create-scrappable';
        }
      }

      return null;
    },
    initialLocation: '/create-scrappable',
    // initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: '/create-scrappable',
        builder: (context, state) {
          return InitialChatView();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          return ScrappablesDashboard();
        },
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) {
          return AuthView();
        },
      ),
    ],
  );
});
