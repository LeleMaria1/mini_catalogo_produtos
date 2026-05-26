import 'package:mini_catalogo_produtos/features/auth/models/user.dart';

class AuthService {
  static const String _demoEmail = 'admin@catalogo.com';
  static const String _demoPassword = 'admin123';
  
  final Map<String, User> _userStore = {};
  final Map<String, String> _passwordStore = {};
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<User> _createUser(String name, String email, String password, {bool isAdmin = false}) async {
    final user = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      isAdmin: isAdmin,
      createdAt: DateTime.now(),
    );

    _userStore[email] = user;
    _passwordStore[email] = password;

    return user;
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      if (email == _demoEmail && password == _demoPassword) {
        _currentUser = await _createUser('Admin User', email, password, isAdmin: true);
        return _currentUser;
      }

      if (_passwordStore.containsKey(email) && _passwordStore[email] == password) {
        _currentUser = _userStore[email];
        return _currentUser;
      }

      throw Exception('Credenciais inválidas. Use email e senha corretos.');
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<User> registerWithEmail(String name, String email, String password) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Preencha todos os campos para se cadastrar.');
      }

      if (_passwordStore.containsKey(email) || email == _demoEmail) {
        throw Exception('Este email já está cadastrado.');
      }

      final user = await _createUser(name, email, password);
      _currentUser = user;
      return user;
    } catch (e) {
      throw Exception('Erro ao cadastrar usuário: $e');
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
