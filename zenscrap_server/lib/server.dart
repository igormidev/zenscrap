import 'package:openai_dart/openai_dart.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_reset_email.dart';
import 'package:zenscrap_server/src/auth/handlers/on_send_validation_email.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_claude_sdk_impl.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart';
import 'package:zenscrap_server/src/web/routes/root.dart';
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

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: onSendValidationEmail,
    sendPasswordResetEmail: onSendResetEmail,
  ));

  final String? scrapingBeeApiKey = pod.getPassword('scrapingBeeApiKey');
  ScrapingBee.initialize(scrapingBeeApiKey ?? '');
  final String? openAiApiKey = pod.getPassword('openAiApiKey');
  openAiClient = OpenAIClient(apiKey: openAiApiKey);

  await ChatControllerClaudeSdkImpl.initialize(
    claudeApiKey: pod.getPassword('claudeCodeApiKey') ?? '',
    scrapingBeeApiKey: scrapingBeeApiKey ?? '',
  );
  ChatControllerGeminiApiImpl.initialize(
    geminiApiKey: pod.getPassword('geminiApiKey') ?? '',
  );

  // Start the server.
  await pod.start();
}

final ScrapingBee scrapingBee = ScrapingBee();
late final OpenAIClient openAiClient;
