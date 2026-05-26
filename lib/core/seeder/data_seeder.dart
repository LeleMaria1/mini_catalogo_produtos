import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _configCollection = 'system_config';
  static const String _initializationDocument = 'initialization';

  static const List<String> _categorias = [
    'Eletrônicos',
    'Vestuário',
    'Alimentos',
    'Livros',
    'Beleza',
    'Casa',
  ];

  static const List<String> _statusProduto = [
    'Ativo',
    'Inativo',
    'Em Falta',
    'Descontinuado',
  ];

  static const Map<String, dynamic> _adminUsuario = {
    'nome': 'Administrador',
    'email': 'admin@exemplo.com',
    'role': 'admin',
    'senha': '123456',
  };

  static Future<void> seedData() async {
    final batch = _firestore.batch();

    _addMasterDataToBatch(
      batch: batch,
      collectionPath: 'categorias',
      values: _categorias,
    );
    _addMasterDataToBatch(
      batch: batch,
      collectionPath: 'status_produto',
      values: _statusProduto,
    );

    batch.set(
      _firestore.collection('usuarios').doc('admin_exemplo_com'),
      {
        ..._adminUsuario,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    batch.set(
      _firestore.collection(_configCollection).doc(_initializationDocument),
      {
        'seedCompleted': true,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();

    debugPrint('Dados mestres inicializados com sucesso.');
  }

  static void _addMasterDataToBatch({
    required WriteBatch batch,
    required String collectionPath,
    required List<String> values,
  }) {
    for (final value in values) {
      batch.set(
        _firestore.collection(collectionPath).doc(_docId(value)),
        {
          'nome': value,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  static String _docId(String value) {
    const replacements = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'é': 'e',
      'ê': 'e',
      'í': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ú': 'u',
      'ü': 'u',
      'ç': 'c',
    };

    var normalized = value.toLowerCase();
    replacements.forEach((from, to) {
      normalized = normalized.replaceAll(from, to);
    });

    return normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
