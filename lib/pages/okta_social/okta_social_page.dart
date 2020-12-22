import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/safety/base_stateful.dart';
import '../../widgets/p_appbar_empty.dart';
import '../../widgets/w_dismiss_keyboard.dart';

class OktaSocialPage extends StatefulWidget {
  @override
  _OktaSocialPageState createState() => _OktaSocialPageState();
}

class _OktaSocialPageState extends BaseStateful<OktaSocialPage> {

  String info;

  String idToken;

  bool get isLogged => info != null && info.isNotEmpty;

  @override
  void initDependencies(BuildContext context) {}

  @override
  Future<void> afterFirstBuild(BuildContext context) async {
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WebView(
      gestureNavigationEnabled: true,
      initialUrl:
          'https://dev-6782369.okta.com/oauth2/v1/authorize?idp=0oa2selzkzc1nrq4z5d6&client_id=0oa1nd3mf9SjX014I5d6&response_type=id_token%20token&response_mode=fragment&scope=openid&redirect_uri=okta://com.okta.dev-6782369&state=any&nonce=any&prompt=login',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (_) {
        print('onWebViewCreated');
      },
      onPageStarted: (String msg) {
        print('onPageStarted: $msg');
      },
      onPageFinished: (String msg) {
        print('onPageFinished: $msg');
      },
    );
    return PAppBarEmpty(
      child: WDismissKeyboard(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SelectableText('Info:\n$info'),
                RaisedButton(
                  onPressed: () {
                    if (isLogged == false) {
                      login('google');
                    } else {
                      logout();
                    }
                  },
                  child: Text(isLogged == false ? 'Google' : 'Logout'),
                ),
                RaisedButton(
                  onPressed: () {
                    if (isLogged == false) {
                      login('facebook');
                    } else {
                      logout();
                    }
                  },
                  child: Text(isLogged == false ? 'Facebook' : 'Logout'),
                ),
                RaisedButton(
                  onPressed: () {
                    if (isLogged == false) {
                      login('linkedin');
                    } else {
                      logout();
                    }
                  },
                  child: Text(isLogged == false ? 'LinkedIn' : 'Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logout
  void logout() {
    setState(() {
      info = null;
    });
  }

  // Login social
  Future<void> login(String idName) async {
    // https://developer.okta.com/docs/reference/api/oidc/#authorize
    try {
      final Map<String, String> idps = {
        // https://console.developers.google.com/
        'google': '0oa2s9urd0fKsBsG15d6',
        // https://developers.facebook.com/
        'facebook': '0oa2se89h0ciMY7Us5d6',
        // https://www.linkedin.com/developers/
        'linkedin': '0oa2selzkzc1nrq4z5d6',
      };

      final Map<String, String> scopes = <String, String>{
        // https://developers.google.com/identity/protocols/googlescopes#google_sign-in
        'google': 'openid',
        // https://developers.facebook.com/docs/facebook-login/permissions/v2.8
        'facebook': 'openid',
        // https://developer.linkedin.com/docs/fields
        'linkedin': 'openid',
      };

      const String _loginRedirectUri = 'okta://com.okta.dev-6782369';
      const String _logoutRedirectUri = 'okta:/logout';
      final String authorizationUrl =
          'https://dev-6782369.okta.com/oauth2/v1/authorize?idp=${idps[idName]}&client_id=0oa1nd3mf9SjX014I5d6&response_type=id_token%20token&response_mode=fragment&scope=${scopes[idName]}&redirect_uri=$_loginRedirectUri&state=any&nonce=any&prompt=login';
      final String logoutUrl = this.idToken == null
          ? null
          : 'https://dev-6782369.okta.com/oauth2/v1/logout?id_token_hint=${this.idToken}&post_logout_redirect_uri=$_logoutRedirectUri';
      final String loginUrl = logoutUrl ?? authorizationUrl;
      final String result = await FlutterWebAuth.authenticate(
          url: loginUrl, callbackUrlScheme: 'okta');

      print('result $result');

      // Extract token from resulting url
      final Uri token = Uri.parse(result);
      // Just for easy parsing
      final String normalUrl = 'http://website/index.html?${token.fragment}';
      final String idToken = Uri.parse(normalUrl).queryParameters['id_token'];
      final String accessToken =
          Uri.parse(normalUrl).queryParameters['access_token'];
      print('accessToken: $accessToken');
      setState(() {
        info = 'accessToken: $accessToken\nidToken: $idToken';
        this.idToken = idToken;
      });
    } catch (e) {
      print(e);
    }
  }
}
