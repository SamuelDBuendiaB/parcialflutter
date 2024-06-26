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
    apiKey: 'AIzaSyC7kQyIaKIc5QZm3d_7Z-kPhVdpPI_ot_c',
    appId: '1:299205345489:web:6c5f75a065c3c16bcb85f0',
    messagingSenderId: '299205345489',
    projectId: 'proyfinal-58701',
    authDomain: 'proyfinal-58701.firebaseapp.com',
    databaseURL: 'https://proyfinal-58701-default-rtdb.firebaseio.com',
    storageBucket: 'proyfinal-58701.appspot.com',
    measurementId: 'G-TKTWE5SLS1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNCMK8owlGnH0ipCy14y1kl2k4hJMg7Mo',
    appId: '1:299205345489:android:1334903aa08b6fb9cb85f0',
    messagingSenderId: '299205345489',
    projectId: 'proyfinal-58701',
    databaseURL: 'https://proyfinal-58701-default-rtdb.firebaseio.com',
    storageBucket: 'proyfinal-58701.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2tWVnjBKpmZI4x142tNt9vDPnmJlD16Q',
    appId: '1:299205345489:ios:17748cf0e16bcecfcb85f0',
    messagingSenderId: '299205345489',
    projectId: 'proyfinal-58701',
    databaseURL: 'https://proyfinal-58701-default-rtdb.firebaseio.com',
    storageBucket: 'proyfinal-58701.appspot.com',
    iosBundleId: 'com.example.app1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2tWVnjBKpmZI4x142tNt9vDPnmJlD16Q',
    appId: '1:299205345489:ios:17748cf0e16bcecfcb85f0',
    messagingSenderId: '299205345489',
    projectId: 'proyfinal-58701',
    databaseURL: 'https://proyfinal-58701-default-rtdb.firebaseio.com',
    storageBucket: 'proyfinal-58701.appspot.com',
    iosBundleId: 'com.example.app1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC7kQyIaKIc5QZm3d_7Z-kPhVdpPI_ot_c',
    appId: '1:299205345489:web:e3b3160eb1c6cd15cb85f0',
    messagingSenderId: '299205345489',
    projectId: 'proyfinal-58701',
    authDomain: 'proyfinal-58701.firebaseapp.com',
    databaseURL: 'https://proyfinal-58701-default-rtdb.firebaseio.com',
    storageBucket: 'proyfinal-58701.appspot.com',
    measurementId: 'G-MNQPGBTYZR',
  );
}
