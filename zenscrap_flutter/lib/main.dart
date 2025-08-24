import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/custom_talker_riverpod_observer.dart';
import 'package:zenscrap_flutter/src/core/utils/devide_utils.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/core/web/url_strategy.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/go_router_providers.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

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
void main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Configure URL strategy for web (removes the # from URLs)
  configureUrlStrategy();

  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
    connectionTimeout: Duration(minutes: 8),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  AdaptiveDialog.instance.updateConfiguration(
    defaultStyle:
        DeviceUtils.isApple ? AdaptiveStyle.iOS : AdaptiveStyle.material,
  );

  final sessionManager = SessionManager(caller: client.modules.auth);
  await sessionManager.initialize();

  final pref = await SharedPreferences.getInstance();

  runApp(
    RestartableApp(
      key: restartableAppKey, // Use the GlobalKey here
      client: client,
      sessionManager: sessionManager,
      sharedPreferences: pref,
    ),
  );
}

// Add a GlobalKey for the RestartableApp's state
final GlobalKey<RestartableAppState> restartableAppKey =
    GlobalKey<RestartableAppState>();

class RestartableApp extends StatefulWidget {
  final Client client;
  final SessionManager sessionManager;
  final SharedPreferences sharedPreferences;

  const RestartableApp({
    super.key, // Pass the key to the StatefulWidget
    required this.client,
    required this.sessionManager,
    required this.sharedPreferences,
  });

  static void restart() {
    // Using GlobalKey is robust for calling restart from anywhere.
    restartableAppKey.currentState?.restartApp();
  }

  @override
  State<RestartableApp> createState() => RestartableAppState();
}

class RestartableAppState extends State<RestartableApp> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TalkerWrapper(
      talker: talker,
      options: const TalkerWrapperOptions(
        enableErrorAlerts: kDebugMode,
        enableExceptionAlerts: kDebugMode,
      ),
      child: ProviderScope(
        key:
            _key, // This key change will re-create ProviderScope and its children
        observers: [
          if (kDebugMode)
            CustomTalkerRiverpodObserver(talker: talker, maxStateLength: 500)
        ],
        overrides: [
          clientProvider.overrideWithValue(widget.client),
          sessionManagerProvider.overrideWithValue(widget.sessionManager),
          sharedPreferencesProvider.overrideWithValue(widget.sharedPreferences),
        ],
        child: const MyApp(), // MyApp and its providers will be reset
      ),
    );
  }
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
      Future.delayed(const Duration(milliseconds: 300), () {
        next.mapOrNull(
          logged: (value) {
            ref
                .read(routerProvider)
                .go(DashboardNavigationType.userEndpoints.routeOnClick!);
          },
          notSignedIn: (_) {
            ref.read(routerProvider).go('/scrappable-form');
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
        useMaterial3: true,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(20, 50),
            maximumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return Consumer(
          child: child,
          builder: (context, ref, child) {
            final isGlobalLoading = ref.watch(isGlobalLoadingProvider);
            return IgnorePointer(ignoring: isGlobalLoading, child: child);
          },
        );
      },
    );
  }
}
