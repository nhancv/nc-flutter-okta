import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:okta/generated/l10n.dart';
import 'package:okta/pages/okta_social/webview_example.dart';
import 'package:okta/services/app/app_dialog.dart';
import 'package:okta/services/app/app_loading.dart';
import 'package:okta/services/cache/credential.dart';
import 'package:okta/services/cache/storage.dart';
import 'package:okta/services/cache/storage_preferences.dart';
import 'package:okta/services/app/locale_provider.dart';
import 'package:okta/services/rest_api/api_user.dart';
import 'package:okta/utils/app_constant.dart';
import 'package:okta/utils/app_route.dart';
import 'package:okta/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> myMain() async {
  /// Start services later
  WidgetsFlutterBinding.ensureInitialized();

  /// Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  /// Run Application
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AppRoute>(create: (_) => AppRoute()),
        Provider<Storage>(create: (_) => StoragePreferences()),
        ChangeNotifierProvider<Credential>(
            create: (BuildContext context) =>
                Credential(context.read<Storage>())),
        ProxyProvider<Credential, ApiUser>(
            create: (_) => ApiUser(),
            update: (_, Credential credential, ApiUser userApi) {
              return userApi..token = credential.token;
            }),
        Provider<AppLoadingProvider>(create: (_) => AppLoadingProvider()),
        Provider<AppDialogProvider>(create: (_) => AppDialogProvider()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<AppThemeProvider>(
            create: (_) => AppThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // Get providers
    final AppRoute appRoute = context.watch<AppRoute>();
    final LocaleProvider localeProvider = context.watch<LocaleProvider>();
    final AppTheme appTheme = context.theme();
    // Build Material app
    return MaterialApp(
      navigatorKey: appRoute.navigatorKey,
      locale: localeProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: appTheme.buildThemeData(),
      //https://stackoverflow.com/questions/57245175/flutter-dynamic-initial-route
      //https://github.com/flutter/flutter/issues/12454
      //home: (appRoute.generateRoute(
      ///            const RouteSettings(name: AppConstant.rootPageRoute))
      ///        as MaterialPageRoute<dynamic>)
      ///    .builder(context),
      // initialRoute: AppConstant.rootPageRoute,
      // onGenerateRoute: appRoute.generateRoute,
      home: WebViewExample(),
      navigatorObservers: <NavigatorObserver>[appRoute.routeObserver],
    );
  }
}
