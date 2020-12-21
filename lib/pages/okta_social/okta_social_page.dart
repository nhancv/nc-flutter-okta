import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../../services/safety/base_stateful.dart';
import '../../widgets/p_appbar_empty.dart';
import '../../widgets/w_dismiss_keyboard.dart';

class OktaSocialPage extends StatefulWidget {
  @override
  _OktaSocialPageState createState() => _OktaSocialPageState();
}

class _OktaSocialPageState extends BaseStateful<OktaSocialPage> {
  String info;

  bool get isLogged => info != null && info.isNotEmpty;

  @override
  void initDependencies(BuildContext context) {}

  @override
  void afterFirstBuild(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

      final String result = await FlutterWebAuth.authenticate(
        url:
            'https://dev-6782369.okta.com/oauth2/v1/authorize?idp=${idps[idName]}&client_id=0oa1nd3mf9SjX014I5d6&response_type=id_token token&response_mode=fragment&scope=${scopes[idName]}&redirect_uri=okta://com.okta.dev-6782369&state=any&nonce=any&prompt=login',
        callbackUrlScheme: 'okta',
      );

      print('result $result');

      // Extract token from resulting url
      final Uri token = Uri.parse(result);
      // Just for easy parsing
      final String normalUrl = 'http://website/index.html?${token.fragment}';
      final String accessToken =
          Uri.parse(normalUrl).queryParameters['access_token'];
      setState(() {
        info = 'accessToken: $accessToken';
      });
    } catch (e) {
      print(e);
    }
  }

}
