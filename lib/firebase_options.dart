// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUMMYKEY1234567890', // ⬅️ سنغيرها لاحقاً
    appId: '1:1234567890:android:abcd1234abcd1234',
    messagingSenderId: '1234567890',
    projectId: 'the-vision-dummy',
    storageBucket: 'the-vision-dummy.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUMMYKEY1234567890',
    appId: '1:1234567890:ios:abcd1234abcd1234',
    messagingSenderId: '1234567890',
    projectId: 'the-vision-dummy',
    storageBucket: 'the-vision-dummy.appspot.com',
    androidClientId: '1234567890-abcdefg.apps.googleusercontent.com',
    iosClientId: '1234567890-abcdefg.apps.googleusercontent.com',
    iosBundleId: 'com.sks.vision',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUMMYKEY1234567890',
    appId: '1:1234567890:ios:abcd1234abcd1234',
    messagingSenderId: '1234567890',
    projectId: 'the-vision-dummy',
    storageBucket: 'the-vision-dummy.appspot.com',
    androidClientId: '1234567890-abcdefg.apps.googleusercontent.com',
    iosClientId: '1234567890-abcdefg.apps.googleusercontent.com',
    iosBundleId: 'com.sks.vision',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUMMYKEY1234567890',
    authDomain: 'the-vision-dummy.firebaseapp.com',
    projectId: 'the-vision-dummy',
    storageBucket: 'the-vision-dummy.appspot.com',
    messagingSenderId: '1234567890',
    appId: '1:1234567890:web:abcd1234abcd1234',
  );
}
