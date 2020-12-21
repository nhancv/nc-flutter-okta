import 'package:flutter/material.dart';
import 'package:okta/pages/okta_openid/okta_openid_page.dart';
import 'package:okta/pages/okta_register/okta_register_page.dart';
import 'package:okta/pages/okta_rest/okta_rest_page.dart';
import 'package:okta/pages/okta_social/okta_social_page.dart';
import 'package:okta/utils/app_constant.dart';
import 'package:provider/provider.dart';

import 'app_constant.dart';

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
      // case AppConstant.rootPageRoute:
      case AppConstant.oktaRestPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => OktaRestPage());

      // case AppConstant.rootPageRoute:
      case AppConstant.oktaOpenIdPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => OktaOpenIdPage());

      // case AppConstant.rootPageRoute:
      case AppConstant.oktaRegisterPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => OktaRegisterPage());

      case AppConstant.rootPageRoute:
      case AppConstant.oktaSocialPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => OktaSocialPage());

      default:
        return null;
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
