import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_reset_email.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_validation_email.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/future_calls/monthly_subscription_credits_future_call.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:zenscrap_server/src/endpoints/public/scrappable_chat_session.dart';
import 'package:zenscrap_server/src/routes/scrappable_api_route.dart';
import 'package:zenscrap_server/src/web/routes/route_single_page_app.dart';
import 'package:zenscrap_server/src/webhooks/stripe_webhook.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Register API routes FIRST (before catch-all routes)
  pod.webServer.addRoute(StripeWebhookRoute(), '/stripe/webhook');

  // Register Scrappable API routes
  pod.webServer
      .addRoute(ScrappableApiRoute(isProd: false), '/api/scrappable/test');
  pod.webServer
      .addRoute(ScrappableApiRoute(isProd: true), '/api/scrappable/prod');

  // Serve all files in the /static directory
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/static/*',
  );

  // Setup single page app LAST (catch-all for remaining routes)
  pod.webServer.addRoute(
    RouteSinglePageApp(
      serverDirectory: 'app',
      appRootPath: 'index.html',
    ),
    '/*',
  );

  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: onSendValidationEmail,
    sendPasswordResetEmail: onSendResetEmail,
  ));

  final String? scrapingBeeApiKey = pod.getPassword('scrapingBeeApiKey');
  scrappingBee = ScrapingBee(apiKey: scrapingBeeApiKey ?? '');

  // // Initialize Stripe configuration
  StripeConfig.initialize({
    'stripe_secret_key': pod.getPassword('stripeSecretKey') ?? '',
    'stripe_webhook_secret': pod.getPassword('stripeWebhookSecret') ?? '',
    'stripe_basic_price_id_monthly':
        pod.getPassword('stripeBasicPriceIdMonthly') ?? '',
    'stripe_basic_price_id_yearly':
        pod.getPassword('stripeBasicPriceIdYearly') ?? '',
    'stripe_pro_price_id_monthly':
        pod.getPassword('stripeProPriceIdMonthly') ?? '',
    'stripe_pro_price_id_yearly':
        pod.getPassword('stripeProPriceIdYearly') ?? '',
    'stripe_ultra_price_id_monthly':
        pod.getPassword('stripeUltraPriceIdMonthly') ?? '',
    'stripe_ultra_price_id_yearly':
        pod.getPassword('stripeUltraPriceIdYearly') ?? '',
    'stripe_success_url':
        pod.getPassword('stripeSuccessUrl') ?? 'https://yourdomain.com/success',
    'stripe_cancel_url':
        pod.getPassword('stripeCancelUrl') ?? 'https://yourdomain.com/cancel',
  });

  // // Register your future calls
  pod.registerFutureCall(
      TestScrappableDisposeFutureCall(), 'dispose_temporary_scrappable');
  pod.registerFutureCall(
      MonthlySubscriptionCreditsFutureCall(), 'monthly_subscription_credits');
  pod.registerFutureCall(SessionPromptFutureCall(), 'session_prompt');
  pod.registerFutureCall(
      PeriodicSetRequestsAnalytics(), 'periodicSetRequestsAnalytics');
  pod.registerFutureCall(PeriodicCleanupOldAnalyticsDetails(),
      'periodicCleanupOldAnalyticsDetails');

  // Start the server.
  await pod.start();

  await pod.cancelFutureCall('periodicSetRequestsAnalytics');
  await pod.cancelFutureCall('periodicCleanupOldAnalyticsDetails');

  // Schedule future calls only if not applying migrations
  // (when applying migrations, the future call tables may not exist yet)
  // final isApplyingMigrations = args.contains('--apply-migrations');

  // Schedule periodic analytics batching
  await pod.futureCallWithDelay(
    'periodicSetRequestsAnalytics',
    null,
    Duration(minutes: 2),
    identifier: 'periodicSetRequestsAnalytics',
  );

  await pod.futureCallWithDelay(
    'periodicCleanupOldAnalyticsDetails',
    null,
    const Duration(hours: 1),
    identifier: 'periodicCleanupOldAnalyticsDetails',
  );
}
