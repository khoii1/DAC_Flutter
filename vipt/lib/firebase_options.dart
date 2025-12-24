
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
    apiKey: 'AIzaSyCQA6RFzBrg_dUWA3HtinT10xRBlJpawtA',
    appId: '1:54970661382:web:58697cf01454ccb153e187',
    messagingSenderId: '54970661382',
    projectId: 'da-flutter-2829b',
    authDomain: 'da-flutter-2829b.firebaseapp.com',
    storageBucket: 'da-flutter-2829b.firebasestorage.app',
    measurementId: 'G-2Z16CBGB49',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpt_S-g2mIlAE_9tratbel7yyIPR_wkX0',
    appId: '1:54970661382:android:45bf617fa02cf3ca53e187',
    messagingSenderId: '54970661382',
    projectId: 'da-flutter-2829b',
    storageBucket: 'da-flutter-2829b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9NoiESDXJKG9Ge-F6BkFLhQ0LSM21iTM',
    appId: '1:54970661382:ios:a3c92d55ced6258c53e187',
    messagingSenderId: '54970661382',
    projectId: 'da-flutter-2829b',
    storageBucket: 'da-flutter-2829b.firebasestorage.app',
    iosBundleId: 'com.example.vipt',
  );

}