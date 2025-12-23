import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seo/seo.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/custom_talker_riverpod_observer.dart';
import 'package:zenscrap_flutter/src/core/utils/device_utils.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/core/web/url_strategy.dart';
import 'package:zenscrap_flutter/src/providers/auth_state_sync_provider.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/go_router_providers.dart';
import 'package:zenscrap_flutter/src/providers/language_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/core/theme/app_theme.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_provider.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

late final Client client;

/*
 /$$$$$$$$  /$$$$$$  /$$$$$$$      /$$$$$$$  /$$$$$$$  /$$$$$$  /$$$$$$   /$$$$$$ 
|____ /$$/ /$$__  $$| $$__  $$    /$$_____/ /$$_____/ /$$__  $$|____  $$ /$$__  $$
   /$$$$/ | $$$$$$$$| $$  \ $$   |  $$$$$$ | $$      | $$  \__/ /$$$$$$$| $$  \ $$
  /$$__/  | $$_____/| $$  | $$    \____  $$| $$      | $$      /$$__  $$| $$  | $$
 /$$$$$$$$|  $$$$$$$| $$  | $$    /$$$$$$$/|  $$$$$$$| $$     |  $$$$$$$| $$$$$$$/
|________/ \_______/|__/  |__/   |_______/  \_______/|__/      \_______/| $$____/ 
                                                                        | $$      
                                                                        | $$      
                                                                        |__/      
*/
void main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Configure URL strategy for web (removes the # from URLs)
  configureUrlStrategy();

  // IMPORTANT: Must use const with String.fromEnvironment for Flutter web release mode
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');

  // Determine the server URL based on environment and debug mode
  final String serverUrl;
  if (serverUrlFromEnv.isNotEmpty) {
    serverUrl = serverUrlFromEnv;
  } else if (kDebugMode) {
    serverUrl = 'http://$localhost:8080/';
  } else {
    serverUrl = 'https://api.zenscrap.com/';
  }

  client =
      Client(
          serverUrl,
          connectionTimeout: Duration(minutes: 4),
          streamingConnectionTimeout: Duration(minutes: 10),
        )
        ..connectivityMonitor = FlutterConnectivityMonitor()
        ..authSessionManager = FlutterAuthSessionManager();

  // Initialize authentication services
  await client.auth.initialize();

  // Initialize Google Sign-In service
  client.auth.initializeGoogleSignIn();

  AdaptiveDialog.instance.updateConfiguration(
    defaultStyle: DeviceUtils.isApple
        ? AdaptiveStyle.iOS
        : AdaptiveStyle.material,
  );

  final pref = await SharedPreferences.getInstance();

  runApp(
    RestartableApp(
      key: restartableAppKey, // Use the GlobalKey here
      client: client,
      sharedPreferences: pref,
    ),
  );
}

// Add a GlobalKey for the RestartableApp's state
final GlobalKey<RestartableAppState> restartableAppKey =
    GlobalKey<RestartableAppState>();

class RestartableApp extends StatefulWidget {
  final Client client;
  final SharedPreferences sharedPreferences;

  const RestartableApp({
    super.key, // Pass the key to the StatefulWidget
    required this.client,
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
            CustomTalkerRiverpodObserver(talker: talker, maxStateLength: 500),
        ],
        overrides: [
          clientProvider.overrideWithValue(widget.client),
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
  @override
  Widget build(BuildContext context) {
    // Initialize auth state sync provider early to listen for external auth changes
    // (e.g., token expiration, sign-out from another device)
    ref.watch(authStateSyncProvider);

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
    final router = ref.watch(routerProvider);
    final themeState = ref.watch(themeProvider);
    final seedColor = Color(themeState.colorValue);
    final locale = ref.watch(appLocaleProvider);

    // SeoController enables SEO (meta, body tag) support on Web
    // It listens to widget tree changes and updates the HTML document tree
    // Use kIsWeb to only enable on web platform for performance
    return SeoController(
      enabled: kIsWeb,
      tree: WidgetTree(context: context),
      child: MaterialApp.router(
        title: 'ZenScrap - AI-Powered Web Scraping',
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        darkTheme: buildAppTheme(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        themeMode: themeModeFromBrightness(themeState.brightness),
        builder: (context, child) {
          return Consumer(
            child: child,
            builder: (context, ref, child) {
              final isGlobalLoading = ref.watch(isGlobalLoadingProvider);
              return IgnorePointer(ignoring: isGlobalLoading, child: child);
            },
          );
        },
      ),
    );
  }
}
