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
    apiKey: 'AIzaSyDx1MSHNBNGevpP3Mpi_4-4TT3bHQxsyyo',
    appId: '1:23627918416:web:4dad8600b3bb1db60df555',
    messagingSenderId: '23627918416',
    projectId: 'handinneed',
    authDomain: 'handinneed.firebaseapp.com',
    storageBucket: 'handinneed.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqCmKz_8-CqXZhXsH7b1-8qi2AL24ng2w',
    appId: '1:23627918416:android:fcd31babb3c33b2c0df555',
    messagingSenderId: '23627918416',
    projectId: 'handinneed',
    storageBucket: 'handinneed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtjaVz0GSl1-QR02L_UNzdQx1hG0qRDCg',
    appId: '1:23627918416:ios:b748c1876f6d37400df555',
    messagingSenderId: '23627918416',
    projectId: 'handinneed',
    storageBucket: 'handinneed.appspot.com',
    iosClientId: '23627918416-m3slnf2msianp2g7kl13m7sl3q0qcg5f.apps.googleusercontent.com',
    iosBundleId: 'io.github.adanglol.handInNeed',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtjaVz0GSl1-QR02L_UNzdQx1hG0qRDCg',
    appId: '1:23627918416:ios:b748c1876f6d37400df555',
    messagingSenderId: '23627918416',
    projectId: 'handinneed',
    storageBucket: 'handinneed.appspot.com',
    iosClientId: '23627918416-m3slnf2msianp2g7kl13m7sl3q0qcg5f.apps.googleusercontent.com',
    iosBundleId: 'io.github.adanglol.handInNeed',
  );
}
