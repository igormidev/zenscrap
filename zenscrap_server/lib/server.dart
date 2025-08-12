import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';

import 'package:zenscrap_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  final String? scrapingBeeApiKey = pod.getPassword('scrapingBeeApiKey');
  ScrapingBee.initialize(scrapingBeeApiKey ?? '');
  final String? openAiApiKey = pod.getPassword('openAiApiKey');
  openAiClient = OpenAIClient(apiKey: openAiApiKey);

  // Initialize Gemini
  final String? geminiApiKey = pod.getPassword('geminiApiKey');
  if (geminiApiKey != null) {
    geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      // model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    );
  }

  // Start the server.
  await pod.start();
}

final ScrapingBee scrapingBee = ScrapingBee();
late final OpenAIClient openAiClient;
late final GenerativeModel geminiModel;
