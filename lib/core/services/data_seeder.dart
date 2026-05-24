import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _categorias = [
    'Eletrônicos',
    'Vestuário',
    'Alimentos',
    'Livros',
    'Beleza',
  ];

  static const List<String> _statusProduto = [
    'Ativo',
    'Inativo',
    'Em Falta',
  ];

  static Future<void> seedData() async {
    final batch = _firestore.batch();

    for (final categoria in _categorias) {
      final ref = _firestore.collection('categorias').doc(_docId(categoria));
      batch.set(
        ref,
        {
          'nome': categoria,
        },
        SetOptions(merge: true),
      );
    }

    for (final status in _statusProduto) {
      final ref = _firestore.collection('status_produto').doc(_docId(status));
      batch.set(
        ref,
        {
          'nome': status,
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _firestore.collection('usuarios').doc('admin_exemplo_com'),
      {
        'email': 'admin@exemplo.com',
        'nome': 'Administrador',
        'role': 'admin',
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  static String _docId(String value) {
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
