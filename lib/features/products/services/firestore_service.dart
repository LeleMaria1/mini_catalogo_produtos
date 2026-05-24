import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_catalogo_produtos/features/products/models/product.dart';

class FirestoreService {
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categorias';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    try {
      final snapshot = await _firestore
          .collection(productsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(productsCollection)
          .where('category', isEqualTo: category)
          .get();

      final products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();

      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return products;
    } catch (e) {
      throw Exception('Erro ao buscar produtos por categoria: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final masterSnapshot =
          await _firestore.collection(categoriesCollection).get();
      final productSnapshot =
          await _firestore.collection(productsCollection).get();

      final categories = {
        ...masterSnapshot.docs.map((doc) => doc.data()['nome'] as String?),
        ...productSnapshot.docs.map((doc) => doc.data()['category'] as String?),
      }.whereType<String>().where((category) => category.isNotEmpty).toList();

      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  Future<String> addProduct(Product product) async {
    try {
      await _firestore
          .collection(productsCollection)
          .doc(product.id)
          .set(product.toMap());

      await _firestore.collection(categoriesCollection).doc(_docId(
            product.category,
          )).set(
        {'nome': product.category},
        SetOptions(merge: true),
      );

      return product.id;
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection(productsCollection)
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(productsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(productsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final products = await getAllProducts();
      final searchQuery = query.toLowerCase();

      return products
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery) ||
              product.description.toLowerCase().contains(searchQuery))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  String _docId(String value) {
    return value
        .toLowerCase()
        .replaceAll('ô', 'o')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ã', 'a')
        .replaceAll('õ', 'o')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
