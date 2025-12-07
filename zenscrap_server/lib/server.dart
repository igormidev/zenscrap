import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_reset_email.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_validation_email.dart';
import 'package:zenscrap_server/src/core/auto_fix/periodic_auto_fix_scrappables.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart';
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
  pod.registerFutureCall(
      PeriodicAutoFixBrokenScrappables(), 'periodicAutoFixBrokenScrappables');

  // Start the server.
  await pod.start();

  // Initialize OpenAI Vector Store with documentation files for the chat controller.
  // This creates a Vector Store containing static .md documentation that the model
  // can search via the file_search tool (replacing the previous input_file approach
  // which only supported PDF files).
  final openAiApiKey = pod.getPassword('openAiApiKey');
  if (openAiApiKey != null && openAiApiKey.isNotEmpty) {
    try {
      await ChatControllerOpenAiSdkImpl.init(openAiApiKey: openAiApiKey);
      // Success message is printed by init() itself
    } catch (e) {
      // ignore: avoid_print
      print('[Zenscrap] ERROR: Failed to initialize OpenAI Vector Store: $e');
    }
  } else {
    // ignore: avoid_print
    print(
        '[Zenscrap] WARNING: OpenAI API key not configured, skipping Vector Store initialization');
  }

  await pod.cancelFutureCall('periodicSetRequestsAnalytics');
  await pod.cancelFutureCall('periodicCleanupOldAnalyticsDetails');
  await pod.cancelFutureCall('periodicAutoFixBrokenScrappables');

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

  // Schedule periodic auto-fix for broken scrappables
  // Runs every 5 minutes to detect and fix scrappables with consecutive errors
  await pod.futureCallWithDelay(
    'periodicAutoFixBrokenScrappables',
    null,
    const Duration(seconds: 30), // Initial delay to let server fully initialize
    identifier: 'periodicAutoFixBrokenScrappables',
  );
}
