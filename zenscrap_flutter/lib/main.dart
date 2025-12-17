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
import 'package:zenscrap_flutter/src/core/utils/devide_utils.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/core/web/url_strategy.dart';
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

  client = Client(
    serverUrl,
    connectionTimeout: Duration(minutes: 3),
  )
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  // Initialize authentication services
  await client.auth.initialize();

  // Initialize Google Sign-In service
  client.auth.initializeGoogleSignIn();

  AdaptiveDialog.instance.updateConfiguration(
    defaultStyle:
        DeviceUtils.isApple ? AdaptiveStyle.iOS : AdaptiveStyle.material,
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
            CustomTalkerRiverpodObserver(talker: talker, maxStateLength: 500)
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Check if screen width is below 1000 pixels
                  if (constraints.maxWidth < 1000) {
                    return const _MobileNotAvailableScreen();
                  }
                  return IgnorePointer(ignoring: isGlobalLoading, child: child);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MobileNotAvailableScreen extends StatelessWidget {
  const _MobileNotAvailableScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVerySmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withAlpha(25),
              colorScheme.secondary.withAlpha(25),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isVerySmall ? 24 : 48,
                vertical: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon Area
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(51),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.devices,
                      size: isVerySmall ? 64 : 80,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: isVerySmall ? 32 : 48),

                  // App Name
                  Text(
                    'Zen Scrap',
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: isVerySmall ? 32 : 40,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Main Heading
                  Text(
                    'Mobile Experience\nComing Soon',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: isVerySmall ? 20 : 24,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withAlpha(77),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.construction_rounded,
                          color: colorScheme.secondary,
                          size: isVerySmall ? 32 : 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'We\'re working hard to bring you an amazing mobile experience.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: isVerySmall ? 14 : 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'For now, please access Zen Scrap from a device with a screen width of at least 1000 pixels.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha(179),
                            fontSize: isVerySmall ? 13 : 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Recommendations
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _RecommendationChip(
                          icon: Icons.laptop_mac,
                          label: 'Desktop',
                          colorScheme: colorScheme,
                          isSmall: isVerySmall,
                        ),
                        _RecommendationChip(
                          icon: Icons.tablet_mac,
                          label: 'Tablet (Landscape)',
                          colorScheme: colorScheme,
                          isSmall: isVerySmall,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isVerySmall ? 32 : 48),

                  // Footer
                  Text(
                    'Thank you for your patience!',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(128),
                      fontStyle: FontStyle.italic,
                      fontSize: isVerySmall ? 12 : 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final bool isSmall;

  const _RecommendationChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 16,
        vertical: isSmall ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withAlpha(77),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmall ? 16 : 18,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: isSmall ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
