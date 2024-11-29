# iNotes



### APK

[![1](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891988/inotes/apk/1_vbtpcm.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/1_vbtpcm.png) [![2](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891988/inotes/apk/2_o6tmci.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/2_o6tmci.png)  [![3](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891988/inotes/apk/3_kilyrj.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/3_kilyrj.png) [![4](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891989/inotes/apk/5_hfg3xe.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/5_hfg3xe.png) [![5](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891988/inotes/apk/4_vk32ur.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/4_vk32ur.png) [![6](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732891989/inotes/apk/6_yor5nu.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/6_yor5nu.png)


### IOS
[![1](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890742/inotes/ios/1_lxsdgd.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890742/inotes/ios/1_lxsdgd.png) [![3](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890731/inotes/ios/3_ywftle.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/3_ywftle.png) [![2](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890731/inotes/ios/2_wrumg9.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/2_wrumg9.png)  [![4](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890731/inotes/ios/4_ptsoep.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/4_ptsoep.png) [![5](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890731/inotes/ios/5_k6vemu.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/5_k6vemu.png) [![6](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890732/inotes/ios/6_k63fuu.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890732/inotes/ios/6_k63fuu.png)  [![7](https://res.cloudinary.com/dfpby8w8f/image/upload/w_50,h_100/v1732890733/inotes/ios/7_lopmo8.png)](https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890733/inotes/ios/7_lopmo8.png) 




## Installation

Requires [Flutter](https://flutter.dev/) v3+ to run.

Edit `firebase_options.dart` and add the necessary credentials for web, iOS, and Android platforms.

```dart
static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('WEB_API_KEY'),
    appId: String.fromEnvironment('WEB_APP_ID'),
    messagingSenderId: '782909183220',
    projectId: 'init-s-notes',
    authDomain: 'init-s-notes.firebaseapp.com',
    storageBucket: 'init-s-notes.appspot.com',
    measurementId: 'G-5Z1XKBSNVQ',
  );
```


Install the dependencies and run.

```sh
flutter pub get
flutter run --dart-define=APK_API_KEY=[firebase_api_key] \
--dart-define=APK_APP_ID=[firebase_app_id]
```




