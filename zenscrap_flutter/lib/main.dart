import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/go_router_providers.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

late final Client client;

late String serverUrl;

/*
 /$$$$$$$$  /$$$$$$  /$$$$$$$         /$$$$$$$  /$$$$$$$  /$$$$$$  /$$$$$$   /$$$$$$ 
|____ /$$/ /$$__  $$| $$__  $$       /$$_____/ /$$_____/ /$$__  $$|____  $$ /$$__  $$
   /$$$$/ | $$$$$$$$| $$  \ $$      |  $$$$$$ | $$      | $$  \__/ /$$$$$$$| $$  \ $$
  /$$__/  | $$_____/| $$  | $$       \____  $$| $$      | $$      /$$__  $$| $$  | $$
 /$$$$$$$$|  $$$$$$$| $$  | $$       /$$$$$$$/|  $$$$$$$| $$     |  $$$$$$$| $$$$$$$/
|________/ \_______/|__/  |__/      |_______/  \_______/|__/      \_______/| $$____/ 
                                                                           | $$      
                                                                           | $$      
                                                                           |__/      
*/
void main() {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(
    TalkerWrapper(
      talker: talker,
      options: const TalkerWrapperOptions(
        enableErrorAlerts: kDebugMode,
        enableExceptionAlerts: kDebugMode,
      ),
      child: ProviderScope(observers: [
        TalkerRiverpodObserver(),
      ], child: const MyApp()),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  void _setLoggoutIfNeeded() {
    final user = ref.read(sessionManagerProvider).signedInUser;
    if (user == null) {
      ref.read(sessionProvider).maybeMap(
            notSignedIn: (_) {},
            orElse: () {
              ref.read(sessionProvider.notifier).state =
                  SessionState.notSignedIn();
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionProvider, (previous, next) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(accountProvider.notifier).logOut();

        next.mapOrNull(
          logged: (value) {
            ref.read(routerProvider).go('/dashboard');
          },
          notSignedIn: (_) {
            ref.read(routerProvider).go('/create-scrappable');
          },
        );
      });
    });
    ref.listen(sessionManagerProvider, (previous, next) {
      _setLoggoutIfNeeded();
    });
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Zen Scrap',
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      locale: const Locale('en'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
