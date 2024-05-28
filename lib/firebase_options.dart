// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
// del show quité el kIsWeb , porque no se va usar en web
/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// 
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    /*
    if (kIsWeb) {
      return web;
    }
    */
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        //return ios;
      case TargetPlatform.macOS:
        //return macos;
      case TargetPlatform.windows:
        //return windows;
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
    apiKey: 'AIzaSyClUC8JYtYOaUmb1zVucILXZbKLNCJirm4',
    appId: '1:901887741088:web:2b2dec0c2d056172fb4dc5',
    messagingSenderId: '901887741088',
    projectId: 'tesisapp-bd1ec',
    authDomain: 'tesisapp-bd1ec.firebaseapp.com',
    storageBucket: 'tesisapp-bd1ec.appspot.com',
  );



  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWT6Qr9bDy2BCAfVS4aMDo6pPYcjMa5dg',
    appId: '1:901887741088:android:ee459e8847400f01fb4dc5',
    messagingSenderId: '901887741088',
    projectId: 'tesisapp-bd1ec',
    storageBucket: 'tesisapp-bd1ec.appspot.com',
  );



  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZjUdOV0Jl0hivocpqJRqyeKLP-E8TMHs',
    appId: '1:901887741088:ios:21a0c3615793bc15fb4dc5',
    messagingSenderId: '901887741088',
    projectId: 'tesisapp-bd1ec',
    storageBucket: 'tesisapp-bd1ec.appspot.com',
    iosClientId: '901887741088-f47fnmcm8ns1b3iek58k5sdq3qh037ve.apps.googleusercontent.com',
    iosBundleId: 'com.example.appHealthConnect',
  );

/*
*/

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZjUdOV0Jl0hivocpqJRqyeKLP-E8TMHs',
    appId: '1:901887741088:ios:21a0c3615793bc15fb4dc5',
    messagingSenderId: '901887741088',
    projectId: 'tesisapp-bd1ec',
    storageBucket: 'tesisapp-bd1ec.appspot.com',
    iosClientId: '901887741088-f47fnmcm8ns1b3iek58k5sdq3qh037ve.apps.googleusercontent.com',
    iosBundleId: 'com.example.appHealthConnect',
  );

/*
*/

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyClUC8JYtYOaUmb1zVucILXZbKLNCJirm4',
    appId: '1:901887741088:web:892100085add64c6fb4dc5',
    messagingSenderId: '901887741088',
    projectId: 'tesisapp-bd1ec',
    authDomain: 'tesisapp-bd1ec.firebaseapp.com',
    storageBucket: 'tesisapp-bd1ec.appspot.com',
  );

/*
*/
}