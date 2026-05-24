import 'package:flutter/foundation.dart';
import 'package:mini_catalogo_produtos/features/auth/models/user.dart';

class AuthService {
  static const String _demoEmail = 'admin@catalogo.com';
  static const String _demoPassword = 'admin123';
  
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Simple login with hardcoded admin credentials
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      // Demo: hardcoded admin credentials
      if (email == _demoEmail && password == _demoPassword) {
        _currentUser = User(
          id: 'admin-user-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: 'Admin User',
          isAdmin: true,
          createdAt: DateTime.now(),
        );
        return _currentUser;
      } else {
        throw Exception('Credenciais inválidas. Use admin@catalogo.com / admin123');
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<void> logout() async {
    try {
      _currentUser = null;
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    return _currentUser != null;
  }
}
