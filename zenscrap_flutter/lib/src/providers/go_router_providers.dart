import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/account/views/account_view.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/views/api_usage_view.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/splash_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/pages/pricing_page.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/views/marketplace_view.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/initial_chat_view.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/view/user_scrappables_listage.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final StateProvider routerProvider = StateProvider((ref) {
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
        if (path.contains('/scrappable-form') == false &&
            path.contains('/splash') == false) {
          return '/splash';
        }
      } else {
        // If user is authenticated and trying to access auth page, redirect to labels
        if (path == '/scrappable-form' || path.contains('/scrappable-form')) {
          return '/scrappable-form';
        }
      }

      return null;
    },
    // initialLocation: '/scrappable-form',
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: '/scrappable-form',
        builder: (context, state) {
          final scrappable = state.extra as Scrappable?;
          return InitialChatView(scrappable: scrappable);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        routes: [
          GoRoute(
            path: DashboardNavigationType.userEndpoints.routeOnClick!,
            builder: (context, state) => UserScrappablesListage(),
          ),
          GoRoute(
            path: DashboardNavigationType.marketPlace.routeOnClick!,
            builder: (context, state) => MarketplaceView(),
          ),
          GoRoute(
            path: DashboardNavigationType.usage.routeOnClick!,
            builder: (context, state) => ApiUsageView(),
          ),
          GoRoute(
            path: DashboardNavigationType.account.routeOnClick!,
            builder: (context, state) => AccountView(),
          ),
          GoRoute(
            path: DashboardNavigationType.pricingPage.routeOnClick!,
            builder: (context, state) => ZenScrapPricingPage(),
          ),
        ],
        builder: (context, state, child) {
          return DashboardView(child: child);
        },
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) {
          return AuthView(
            scrappable: state.extra as Scrappable?,
          );
        },
      ),
    ],
  );
});
