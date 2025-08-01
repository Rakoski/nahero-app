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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAkYmuiXD-85sGhNyIoS9BHtb7ZSPvtxsI',
    appId: '1:395630491846:web:c15cdd4e91d395d8087fc7',
    messagingSenderId: '395630491846',
    projectId: 'nahero-app',
    authDomain: 'nahero-app.firebaseapp.com',
    storageBucket: 'nahero-app.firebasestorage.app',
    measurementId: 'G-LND00V4PP1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdquN2n8Von7T7onacrvxlahIPUFvLbWY',
    appId: '1:395630491846:android:657b786194e45900087fc7',
    messagingSenderId: '395630491846',
    projectId: 'nahero-app',
    storageBucket: 'nahero-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0ovDIxnq-XOPzG8YRYxmOxOwLMLB5rpY',
    appId: '1:395630491846:ios:2fa25dd26b7e4ec3087fc7',
    messagingSenderId: '395630491846',
    projectId: 'nahero-app',
    storageBucket: 'nahero-app.firebasestorage.app',
    iosBundleId: 'com.example.flutterAppHelio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0ovDIxnq-XOPzG8YRYxmOxOwLMLB5rpY',
    appId: '1:395630491846:ios:2fa25dd26b7e4ec3087fc7',
    messagingSenderId: '395630491846',
    projectId: 'nahero-app',
    storageBucket: 'nahero-app.firebasestorage.app',
    iosBundleId: 'com.example.flutterAppHelio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAkYmuiXD-85sGhNyIoS9BHtb7ZSPvtxsI',
    appId: '1:395630491846:web:9e78c985ab79d393087fc7',
    messagingSenderId: '395630491846',
    projectId: 'nahero-app',
    authDomain: 'nahero-app.firebaseapp.com',
    storageBucket: 'nahero-app.firebasestorage.app',
    measurementId: 'G-LVVJRTSXTH',
  );
}
