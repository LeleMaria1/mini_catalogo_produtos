import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_catalogo_produtos/core/themes/app_theme.dart';
import 'package:mini_catalogo_produtos/features/auth/viewmodels/login_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/auth/views/login_screen.dart';
import 'package:mini_catalogo_produtos/features/products/viewmodels/add_product_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/viewmodels/products_list_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/views/products_list_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> testFirebaseConnection() async {
  try {
    await FirebaseFirestore.instance
        .collection('test_connection')
        .doc('connection_test')
        .set({
      'connectedAt': DateTime.now().toUtc().toIso8601String(),
      'status': 'ok',
    });

    debugPrint('Firebase test connection successful: document written to test_connection');
  } catch (error, stackTrace) {
    debugPrint('Firebase test connection failed: $error');
    debugPrint('$stackTrace');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await testFirebaseConnection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductsListViewModel()),
        ChangeNotifierProvider(create: (_) => AddProductViewModel()),
      ],
      child: MaterialApp(
        title: 'Mini Catalogo de Produtos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.isAuthenticated) {
          return const ProductsListScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
