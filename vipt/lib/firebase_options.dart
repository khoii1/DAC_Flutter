
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
    apiKey: 'AIzaSyDpQdi2vh78WqtYf76Wmh8-_9z9N8fynBI',
    appId: '1:706032496846:web:9cfd36624c7d22544b209f',
    messagingSenderId: '706032496846',
    projectId: 'dadnt-flutter',
    authDomain: 'dadnt-flutter.firebaseapp.com',
    storageBucket: 'dadnt-flutter.firebasestorage.app',
    measurementId: 'G-0MG68Y2BSX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDo8DGXKAC-Qftzy7mOZ52_rOzHVxm8KsA',
    appId: '1:706032496846:android:e1af7ea95978ac2a4b209f',
    messagingSenderId: '706032496846',
    projectId: 'dadnt-flutter',
    storageBucket: 'dadnt-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACEnZ9KqjcV_7FG8ox8lmCQlHY5odz7Vs',
    appId: '1:706032496846:ios:e6cc19bfe2ce08e24b209f',
    messagingSenderId: '706032496846',
    projectId: 'dadnt-flutter',
    storageBucket: 'dadnt-flutter.firebasestorage.app',
    iosBundleId: 'com.example.vipt',
  );

}