import 'package:flutter/material.dart';
import 'package:mini_catalogo_produtos/features/products/models/product.dart';
import 'package:mini_catalogo_produtos/features/products/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class AddProductViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<String> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  AddProductViewModel() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      _categories = await _firestoreService.getCategories();
      // Add "Novo" category option
      if (!_categories.contains('Novo')) {
        _categories.insert(0, 'Novo');
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar categorias: $e';
      notifyListeners();
    }
  }

  Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required String createdBy,
    String? newCategory,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      String finalCategory = category;
      
      // If "Novo" was selected and a new category was provided
      if (category == 'Novo' && newCategory != null && newCategory.isNotEmpty) {
        finalCategory = newCategory;
      }

      final product = Product(
        id: const Uuid().v4(),
        name: name,
        description: description,
        price: price,
        category: finalCategory,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await _firestoreService.addProduct(product);
      _successMessage = 'Produto adicionado com sucesso!';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
