# OKTA

## Create dev account

You can create Developer Edition Account at https://developer.okta.com/signup/

## Setup open-id

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






