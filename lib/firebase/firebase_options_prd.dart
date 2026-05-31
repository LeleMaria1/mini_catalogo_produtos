import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyDjOuCJfKvhCpm3o_iKQqylbESMRCOPyy8",
        authDomain: "mini-catalogo-produtos.firebaseapp.com",
        projectId: "mini-catalogo-produtos",
        storageBucket: "mini-catalogo-produtos.firebasestorage.app",
        messagingSenderId: "123382549576",
        appId: "1:123382549576:web:67879afec9db5fb7f25c7d",
      );
    }
    // Para Android/iOS 
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }
}
