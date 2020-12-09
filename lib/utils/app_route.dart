import 'package:flutter/material.dart';
import 'package:okta/pages/counter/counter_page.dart';
import 'package:okta/pages/home/home_page.dart';
import 'package:okta/pages/login/login_page.dart';
import 'package:okta/utils/app_constant.dart';
import 'package:provider/provider.dart';

class AppRoute {
  /// App global navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // App route observer
  final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();

  // Get app context
  BuildContext get appContext => navigatorKey.currentContext;

  /// Generate route for app here
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.counterPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) =>
                CounterPage(argument: settings.arguments as String));

      case AppConstant.homePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => const HomePage());

      case AppConstant.loginPageRoute:
      case AppConstant.rootPageRoute:
      default:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => const LoginPage());
    }
  }
}

extension AppRouteExt on BuildContext {
  AppRoute route() {
    return Provider.of<AppRoute>(this, listen: false);
  }

  NavigatorState navigator() {
    return route().navigatorKey.currentState;
  }
}
