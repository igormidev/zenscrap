import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/account/views/account_view.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/views/ai_usage_view.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/view/api_analytics_view.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/views/api_usage_view.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/splash_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/pages/pricing_page.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/views/marketplace_view.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/landing_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/initial_chat_view.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/views/user_scrappables_listage_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Notifier for managing GoRouter configuration.
/// Rebuilds router when session state changes to handle authentication redirects.
class RouterNotifier extends Notifier<GoRouter> {
  @override
  GoRouter build() {
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
        // PosthogObserver tracks screen views automatically
        // Routes must have names for proper tracking
        PosthogObserver(),
        if (kDebugMode) TalkerRouteObserver(talker),
      ],
      redirect: (context, state) {
        final path = state.uri.path;

        // Don't redirect while session is still loading
        if (isLoading) {
          return null;
        }

        if (path == '/splash') {
          return null;
        }
        if (path.isEmpty || path == '/') {
          return '/splash';
        }

        if (haveUser == false) {
          if (path == '/auth') {
            return null;
          }

          // Allow unauthenticated access to auth, splash, and landing page routes
          if (path.contains('/scrappable-form') == false &&
              path.contains('/splash') == false) {
            return '/scrappable-form'; // Redirect to landing page
          }
        } else {
          // If user is authenticated and trying to access auth page, redirect to labels
          if (path == '/auth' || path.contains('/auth')) {
            return DashboardNavigationType.userEndpoints.routeOnClick;
          }
        }

        return null;
      },
      // initialLocation: '/scrappable-form',
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          name: 'Splash',
          builder: (context, state) {
            return const SplashView();
          },
        ),
        GoRoute(
          path: '/scrappable-form',
          name: 'Scrappable Form',
          builder: (context, state) {
            final scrappableIdStr = state.uri.queryParameters['id'];
            final int? scrappableId = scrappableIdStr != null
                ? int.tryParse(scrappableIdStr)
                : null;
            // If editing an existing scrappable, use InitialChatView
            // Otherwise, show the landing page
            if (scrappableId != null) {
              return InitialChatView(scrappableId: scrappableId);
            }
            return const LandingPage();
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: DashboardNavigationType.userEndpoints.routeOnClick!,
              name: 'User Endpoints',
              builder: (context, state) => const UserScrappablesListageView(),
            ),
            GoRoute(
              path: DashboardNavigationType.marketPlace.routeOnClick!,
              name: 'Marketplace',
              builder: (context, state) => MarketplaceView(),
            ),
            GoRoute(
              path: DashboardNavigationType.usage.routeOnClick!,
              name: 'API Usage',
              builder: (context, state) => ApiUsageView(),
            ),
            GoRoute(
              path: DashboardNavigationType.analytics.routeOnClick!,
              name: 'API Analytics',
              builder: (context, state) => ApiAnalyticsView(),
            ),
            GoRoute(
              path: DashboardNavigationType.aiUsage.routeOnClick!,
              name: 'AI Usage',
              builder: (context, state) => const AiUsageView(),
            ),
            GoRoute(
              path: DashboardNavigationType.account.routeOnClick!,
              name: 'Account',
              builder: (context, state) => AccountView(),
            ),
            GoRoute(
              path: DashboardNavigationType.pricingPage.routeOnClick!,
              name: 'Pricing',
              builder: (context, state) => ZenScrapPricingPage(),
            ),
          ],
          builder: (context, state, child) {
            return DashboardView(child: child);
          },
        ),
        GoRoute(
          path: '/auth',
          name: 'Auth',
          builder: (context, state) {
            return const AuthView();
          },
        ),
      ],
    );
  }
}

final routerProvider = NotifierProvider<RouterNotifier, GoRouter>(
  RouterNotifier.new,
);
