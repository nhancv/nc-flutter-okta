# OKTA

## Create dev account

You can create Developer Edition Account at https://developer.okta.com/signup/

## Okta rest api

https://developer.okta.com/code/rest/ 

## Setup open-id

### Create OpenId Application

- Go to `Dashboard console`
- Create New Application
- Get OpenId info
```
Client ID: 0oa1nd3mf9SjX014I5d6
Login redirect URIs: com.okta.dev-6782369:/callback	
Issuer = Okta URL: https://dev-6782369.okta.com/oauth2/default
Discovery Uri: https://dev-6782369.okta.com/oauth2/default/.well-known/openid-configuration
```

### Setup Android

1. Update `android/app/build.gradle`. Replace `<your_custom_scheme>` with the desired value. Ex: Login redirect domain

```
...
android {
    ...
    defaultConfig {
        ...
        manifestPlaceholders = [
                'appAuthRedirectScheme': '<your_custom_scheme>'
        ]
    }
}
```

2. Make sure your `minSdkVersion` is `19`.

### Setup iOS

Update `ios/Runner/Info.plist`. Replace `<your_custom_scheme>` with the desired value. Ex: Login redirect domain

```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><your_custom_scheme></string>
        </array>
    </dict>
</array>
```

### Dart

- Install lib
```
  # Standard library for OAuth 2.0 and OpenID Connect
  flutter_appauth: ^0.9.2+6
```

--------------

### Register

- Rest api: https://developer.okta.com/docs/reference/api/users/#create-user-with-password
```
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
  "profile": {
    "firstName": "Isaac",
    "lastName": "Brock",
    "email": "isaac.brock@example.com",
    "login": "isaac.brock@example.com",
    "mobilePhone": "555-415-1337"
  },
  "credentials": {
    "password" : { "value": "tlpWENT2m" }
  }
}' "https://${yourOktaDomain}/api/v1/users?activate=true"
```

### Social login

https://developer.okta.com/docs/guides/add-an-external-idp/google/before-you-begin/

#### Google

https://developer.okta.com/docs/guides/add-an-external-idp/google/create-an-app-at-idp/

* Create an App at the Identity Provider
- Access: https://console.developers.google.com/
- Select Credentials => Create Credentials => OAuth client ID => Select the Web application application type 
=> Name your OAuth 2.0 client => Fill Authorized redirect URIs: add the Okta redirect URI. (ex: https://dev-6782369.okta.com/oauth2/v1/authorize/callback) 
=> click Create => Save the OAuth Client ID and Client Secret values so you can add them to the Okta configuration in the next section.

* Create an Identity Provider in Okta
- Access: https://dev-6782369-admin.okta.com/dev/console
- Hover over Users and then select Social & Identity Providers
- Add Identity Provider -> Add an Identity Provider -> Add Google
- Fill Client ID and Client Secret from previous step (Google OAuth credentials)
* Register an App in Okta
- In your Okta org, click Applications, and then Add Application
- Select the appropriate platform for your use case, enter a name for your new application, and then click Next.
- In Allowed grant types: Enable Implicit + Check both Allow ID Token with implicit grant type + Allow Access Token with implicit grant type 
- Add Custom Login redirect URIs: okta://com.okta.dev-6782369
- Scroll to the Client Credentials section and copy the client ID that you use to complete the Authorize URL in the next step
* Create the Authorization URL
https://${yourOktaDomain}/oauth2/v1/authorize?idp=0oaaq9pjc2ujmFZexample&client_id=GkGw4K49N4UEE1example&response_type=id_token&response_mode=fragment&scope=openid%20email&redirect_uri=https%3A%2F%2FyourAppUrlHere.com%2F&state=WM6D&nonce=YsG76jo
Ex: https://dev-6782369.okta.com/oauth2/v1/authorize?idp=0oa2s9urd0fKsBsG15d6&client_id=0oa1nd3mf9SjX014I5d6&response_type=id_token%20token&response_mode=fragment&scope=openid%20profile%20email&redirect_uri=okta://com.okta.dev-6782369&state=any&nonce=any&prompt=login

> After successful authentication, the user is redirected to the redirect URI that you specified, along with an #id_token= and &access_token fragment in the URL
> Get user info from access token: 
```
curl --location --request GET 'https://dev-6782369.okta.com/oauth2/v1/userinfo' \
--header 'Accept: application/json' \
--header 'Authorization: Bearer access_token'
```

##### Integrate to flutter 
- Install lib
```
  flutter_web_auth: ^0.2.4
```

- Android config `AndroidManifest.xml`
```
<manifest>
    <application>
        .....

        <activity android:name="com.linusu.flutter_web_auth.CallbackActivity" >
            <intent-filter android:label="flutter_web_auth">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="okta" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

- Example
```
// Present the dialog to the user
// https://developer.okta.com/docs/reference/api/oidc/#authorize
final String result = await FlutterWebAuth.authenticate(
  url: 'https://dev-6782369.okta.com/oauth2/v1/authorize?idp=0oa2s9urd0fKsBsG15d6&client_id=0oa1nd3mf9SjX014I5d6&response_type=id_token%20token&response_mode=fragment&scope=openid%20profile%20email&redirect_uri=okta://com.okta.dev-6782369&state=any&nonce=any&prompt=login',
  callbackUrlScheme: 'okta',
);

// Extract token from resulting url
final Uri token = Uri.parse(result);
// Just for easy parsing
final String normalUrl = 'http://website/index.html?${token.fragment}';
final String accessToken = Uri.parse(normalUrl).queryParameters['access_token'];
print('token');
print(accessToken);
```
