// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyBaqh-bTVDHgrYqmyz0vtFJ88UssGJLO8w',
    appId: '1:689353880570:web:282ee26b01d854535aaa43',
    messagingSenderId: '689353880570',
    projectId: 'chat-app-40011',
    authDomain: 'chat-app-40011.firebaseapp.com',
    storageBucket: 'chat-app-40011.appspot.com',
    measurementId: 'G-1JBEF4NG7M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARy6mCh1p8Sbv4-1SCwBcFAq-oyVL44Pk',
    appId: '1:689353880570:android:42a671947b257ea95aaa43',
    messagingSenderId: '689353880570',
    projectId: 'chat-app-40011',
    storageBucket: 'chat-app-40011.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAk4eavmnOZfi0kS1UJZiSgjkd9CgKHpBg',
    appId: '1:689353880570:ios:23ca567ef461a3a25aaa43',
    messagingSenderId: '689353880570',
    projectId: 'chat-app-40011',
    storageBucket: 'chat-app-40011.appspot.com',
    iosClientId: '689353880570-d2464v7od339t4tris1a29bj2cag2ibt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAk4eavmnOZfi0kS1UJZiSgjkd9CgKHpBg',
    appId: '1:689353880570:ios:23ca567ef461a3a25aaa43',
    messagingSenderId: '689353880570',
    projectId: 'chat-app-40011',
    storageBucket: 'chat-app-40011.appspot.com',
    iosClientId: '689353880570-d2464v7od339t4tris1a29bj2cag2ibt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
