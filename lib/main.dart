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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError {
    // Firebase options are currently configured only for web, Android, and iOS.
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductsListViewModel()),
        ChangeNotifierProvider(create: (_) => AddProductViewModel()),
      ],
      child: MaterialApp(
        title: 'Mini Catálogo de Produtos',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

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
