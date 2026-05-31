import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyA_dxkqKNgVu8IK5JFljmQmBGAkZhD2m5w",
        authDomain: "mini-catalogo-dev.firebaseapp.com",
        projectId: "mini-catalogo-dev",
        storageBucket: "mini-catalogo-dev.firebasestorage.app",
        messagingSenderId: "519849534479",
        appId: "1:519849534479:web:92c12f2c7892065c5daf7a",
      );
    }
    // Para Android/iOS 
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }
}
