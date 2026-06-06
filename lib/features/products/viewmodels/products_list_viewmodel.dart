import 'package:flutter/material.dart';
import 'package:mini_catalogo_produtos/features/products/models/product.dart';
import 'package:mini_catalogo_produtos/features/products/services/firestore_service.dart';

class ProductsListViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> loadProducts(String createdBy) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (createdBy.isEmpty) {
        throw Exception('Usuário não autenticado.');
      }

      _allProducts = await _firestoreService.getAllProducts(createdBy);
      _filteredProducts = _allProducts;
      await _loadCategories(createdBy);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCategories(String createdBy) async {
    try {
      _categories = await _firestoreService.getCategories(createdBy);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar categorias: $e';
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _filteredProducts = _allProducts;
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts;

    // Filter by category
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredProducts = _filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query))
          .toList();
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id, String createdBy) async {
    try {
      if (createdBy.isEmpty) {
        throw Exception('Usuário não autenticado.');
      }

      await _firestoreService.deleteProduct(id, createdBy);
      _allProducts.removeWhere((product) => product.id == id);
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
