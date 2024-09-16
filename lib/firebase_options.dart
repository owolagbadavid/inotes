// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUDQUU252HIvRD8Ux-m_WfMlja_XA988U',
    appId: '1:782909183220:web:83353fb6e760d68aa2baa1',
    messagingSenderId: '782909183220',
    projectId: 'init-s-notes',
    authDomain: 'init-s-notes.firebaseapp.com',
    storageBucket: 'init-s-notes.appspot.com',
    measurementId: 'G-5Z1XKBSNVQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1i8T400-TOkgMa1dY3J-cN7qOhFojjhs',
    appId: '1:782909183220:android:582fdc3add4111c4a2baa1',
    messagingSenderId: '782909183220',
    projectId: 'init-s-notes',
    storageBucket: 'init-s-notes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHlThEKni-7AzeHhbADX83kq_nsUv3pgM',
    appId: '1:782909183220:ios:92cf0ac938ace5c2a2baa1',
    messagingSenderId: '782909183220',
    projectId: 'init-s-notes',
    storageBucket: 'init-s-notes.appspot.com',
    iosBundleId: 'tech.oreosinit.inotes',
  );
}
