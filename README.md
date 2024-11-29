# iNotes



### APK

<a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/1_vbtpcm.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/1_vbtpcm.png" width="50" height="100" alt="APK Image 1">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/2_o6tmci.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/2_o6tmci.png" width="50" height="100" alt="APK Image 2">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/3_kilyrj.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/3_kilyrj.png" width="50" height="100" alt="APK Image 3">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/5_hfg3xe.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/5_hfg3xe.png" width="50" height="100" alt="APK Image 4">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/4_vk32ur.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891988/inotes/apk/4_vk32ur.png" width="50" height="100" alt="APK Image 5">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/6_yor5nu.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732891989/inotes/apk/6_yor5nu.png" width="50" height="100" alt="APK Image 6">
    </a>

### IOS
<a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890742/inotes/ios/1_lxsdgd.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890742/inotes/ios/1_lxsdgd.png" width="50" height="100" alt="IOS Image 1">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/3_ywftle.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/3_ywftle.png" width="50" height="100" alt="IOS Image 2">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/2_wrumg9.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/2_wrumg9.png" width="50" height="100" alt="IOS Image 3">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/4_ptsoep.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/4_ptsoep.png" width="50" height="100" alt="IOS Image 4">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/5_k6vemu.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890731/inotes/ios/5_k6vemu.png" width="50" height="100" alt="IOS Image 5">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890732/inotes/ios/6_k63fuu.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890732/inotes/ios/6_k63fuu.png" width="50" height="100" alt="IOS Image 6">
    </a>&nbsp;
    <a href="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890733/inotes/ios/7_lopmo8.png">
        <img src="https://res.cloudinary.com/dfpby8w8f/image/upload/v1732890733/inotes/ios/7_lopmo8.png" width="50" height="100" alt="IOS Image 7">
    </a>



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




