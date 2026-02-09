import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_reset_email.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_validation_email.dart';
import 'package:zenscrap_server/src/core/auto_fix/periodic_auto_fix_scrappables.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart';
import 'package:zenscrap_server/src/future_calls/cleanup_expired_ip_spending_future_call.dart';
import 'package:zenscrap_server/src/future_calls/cleanup_expired_ip_validation_cache_future_call.dart';
import 'package:zenscrap_server/src/future_calls/cleanup_expired_pending_commits_future_call.dart';
import 'package:zenscrap_server/src/future_calls/email_idp_cleanup_future_call.dart';
import 'package:zenscrap_server/src/routes/scrappable_api_route.dart';
import 'package:zenscrap_server/src/webhooks/stripe_webhook.dart';
import 'package:zenscrap_server/src/web/routes/terms_of_service_route.dart';
import 'package:zenscrap_server/src/web/routes/privacy_policy_route.dart';
import 'package:zenscrap_server/src/web/routes/payment_success_route.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

/// Middleware to add Cross-Origin-Opener-Policy header for Google Sign-In compatibility.
///
/// Google Sign-In popups require `same-origin-allow-popups` to communicate back
/// to the opener window via postMessage. Without this header, window.opener is null
/// and the auth flow fails with a blank popup.
///
/// See: https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid#cross_origin_opener_policy
class GoogleSignInCoopMiddleware extends MiddlewareObject {
  const GoogleSignInCoopMiddleware();

  @override
  Handler call(Handler next) {
    return (Request req) async {
      final result = await next(req);

      // Only modify Response objects
      if (result is Response) {
        return result.copyWith(
          headers: result.headers.transform((mh) {
            mh.crossOriginOpenerPolicy =
                CrossOriginOpenerPolicyHeader.sameOriginAllowPopups;
          }),
        );
      }

      return result;
    };
  }
}

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services with Serverpod 3.1 IDP system
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      // Google OAuth authentication
      GoogleIdpConfig(
        clientSecret: GoogleClientSecret.fromJsonString(
          pod.getPassword('googleClientSecret')!,
        ),
      ),
      // Email/password authentication
      EmailIdpConfig(
        secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
        sendRegistrationVerificationCode: onSendRegistrationVerificationCode,
        sendPasswordResetVerificationCode: onSendPasswordResetVerificationCode,
        passwordValidationFunction: (password) {
          if (password.length < 8 || password.length > 64) return false;
          if (!password.contains(RegExp(r'[A-Z]'))) return false;
          if (!password.contains(RegExp(r'[a-z]'))) return false;
          if (!password.contains(RegExp(r'[0-9]'))) return false;
          return true;
        },
        // Rate limiting configuration
        // Failed login: 5 attempts per 15 minutes (more lenient than default 5 per 5 min)
        failedLoginRateLimit: RateLimit(
          maxAttempts: 5,
          timeframe: Duration(minutes: 15),
        ),
        // Password reset: 3 attempts per hour (same as default)
        maxPasswordResetAttempts: RateLimit(
          maxAttempts: 3,
          timeframe: Duration(hours: 1),
        ),
        // Registration verification: 30 minutes lifetime, 5 attempts
        // (more lenient than default 15 min, 3 attempts)
        registrationVerificationCodeLifetime: Duration(minutes: 30),
        registrationVerificationCodeAllowedAttempts: 5,
        // Password reset verification: 30 minutes lifetime, 5 attempts
        // (more lenient than default 15 min, 3 attempts)
        passwordResetVerificationCodeLifetime: Duration(minutes: 30),
        passwordResetVerificationCodeAllowedAttempts: 5,
        // Security monitoring callbacks
        onAfterAccountCreated:
            (
              session, {
              required email,
              required authUserId,
              required emailAccountId,
              required transaction,
            }) async {
              session.log(
                'New email account created: $email '
                '(authUserId: $authUserId, emailAccountId: $emailAccountId)',
                level: LogLevel.info,
              );
            },
        onPasswordResetCompleted:
            (session, {required emailAccountId, required transaction}) {
              session.log(
                'Password reset completed for emailAccountId: $emailAccountId',
                level: LogLevel.info,
              );
            },
      ),
    ],
  );

  // Apply COOP middleware to all web routes for Google Sign-In popup compatibility.
  // This sets Cross-Origin-Opener-Policy: same-origin-allow-popups which allows
  // Google's popup to call window.opener.postMessage() after authentication.
  pod.webServer.addMiddleware(const GoogleSignInCoopMiddleware().call, '/');

  // Register API routes FIRST (before catch-all routes)
  pod.webServer.addRoute(StripeWebhookRoute(), '/stripe/webhook');

  // Register Scrappable API routes
  pod.webServer.addRoute(
    ScrappableApiRoute(isProd: false),
    '/api/scrappable/test',
  );
  pod.webServer.addRoute(
    ScrappableApiRoute(isProd: true),
    '/api/scrappable/prod',
  );

  // Serve all files in the /static directory using Serverpod 3.0 StaticRoute
  // Note: StaticRoute.directory internally uses '/**' path, so we only specify '/static'
  pod.webServer.addRoute(
    StaticRoute.directory(Directory('web/static')),
    '/static',
  );

  // Register legal pages (Terms of Service and Privacy Policy)
  pod.webServer.addRoute(TermsOfServiceRoute(), '/terms-of-service');
  pod.webServer.addRoute(PrivacyPolicyRoute(), '/privacy-policy');

  // Register payment success page (shown after successful Stripe checkout)
  pod.webServer.addRoute(PaymentSuccessRoute(), '/success');

  // Setup Flutter web app using SpaRoute (catch-all for remaining routes)
  //
  // NOTE: We use SpaRoute instead of FlutterRoute because:
  // - FlutterRoute adds Cross-Origin-Opener-Policy: same-origin which breaks Google Sign-In
  // - We need Cross-Origin-Opener-Policy: same-origin-allow-popups for Google Sign-In popup
  //   to call window.opener.postMessage() after authentication
  // - The googleSignInCoopMiddleware() above adds the correct COOP header
  // - Flutter WASM still works in single-threaded mode (which is still faster than JS)
  //
  // See: https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid#cross_origin_opener_policy
  final flutterAppDir = Directory('web/app');
  if (flutterAppDir.existsSync()) {
    pod.webServer.addRoute(
      SpaRoute(flutterAppDir, fallback: File('web/app/index.html')),
      '/',
    );
  } else {
    // ignore: avoid_print
    print(
      '[Zenscrap] Warning: Flutter web app not found at ${flutterAppDir.path}',
    );
  }

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
      '[Zenscrap] WARNING: OpenAI API key not configured, skipping Vector Store initialization',
    );
  }

  await pod.futureCalls.cancel(PeriodicSetRequestsAnalytics.callName);
  await pod.futureCalls.cancel(PeriodicCleanupOldAnalyticsDetails.callName);
  await pod.futureCalls.cancel(PeriodicAutoFixBrokenScrappables.callName);
  await pod.futureCalls.cancel(CleanupExpiredIpSpendingFutureCall.callName);
  await pod.futureCalls.cancel(
    CleanupExpiredIpValidationCacheFutureCall.callName,
  );
  await pod.futureCalls.cancel(EmailIdpCleanupFutureCall.callName);
  await pod.futureCalls.cancel(CleanupExpiredPendingCommitsFutureCall.callName);

  // Schedule future calls only if not applying migrations
  // (when applying migrations, the future call tables may not exist yet)
  // final isApplyingMigrations = args.contains('--apply-migrations');

  // Schedule periodic analytics batching
  await pod.futureCalls
      .callWithDelay(
        const Duration(minutes: 2),
        identifier: PeriodicSetRequestsAnalytics.callName,
      )
      .periodicSetRequestsAnalytics
      .run();

  await pod.futureCalls
      .callWithDelay(
        const Duration(hours: 1),
        identifier: PeriodicCleanupOldAnalyticsDetails.callName,
      )
      .periodicCleanupOldAnalyticsDetails
      .run();

  // Schedule periodic auto-fix for broken scrappables
  // Runs every 5 minutes to detect and fix scrappables with consecutive errors
  await pod.futureCalls
      .callWithDelay(
        const Duration(seconds: 30),
        identifier: PeriodicAutoFixBrokenScrappables.callName,
      )
      .periodicAutoFixBrokenScrappables
      .run();

  // Schedule periodic cleanup of expired anonymous IP spending records
  // Runs every hour to delete records older than 7 days
  await pod.futureCalls
      .callWithDelay(
        const Duration(minutes: 5),
        identifier: CleanupExpiredIpSpendingFutureCall.callName,
      )
      .cleanupExpiredIpSpending
      .run();

  // Schedule periodic cleanup of expired IP validation cache entries
  // Runs every 24 hours to delete entries older than 72 hours
  await pod.futureCalls
      .callWithDelay(
        const Duration(minutes: 10),
        identifier: CleanupExpiredIpValidationCacheFutureCall.callName,
      )
      .cleanupExpiredIpValidationCache
      .run();

  // Schedule periodic cleanup of expired email authentication data
  // Runs daily to delete expired account requests, password reset requests,
  // and failed login attempts older than 30 days
  await pod.futureCalls
      .callWithDelay(
        const Duration(minutes: 15),
        identifier: EmailIdpCleanupFutureCall.callName,
      )
      .emailIdpCleanup
      .run();

  // Schedule periodic cleanup of expired pending session commits
  // Runs hourly to delete pending commits older than 24 hours
  await pod.futureCalls
      .callWithDelay(
        const Duration(minutes: 20),
        identifier: CleanupExpiredPendingCommitsFutureCall.callName,
      )
      .cleanupExpiredPendingCommits
      .run();
}
