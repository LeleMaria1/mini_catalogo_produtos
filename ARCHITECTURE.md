# 🏗️ Arquitetura MVVM

Este documento explica a arquitetura MVVM (Model-View-ViewModel) utilizada no projeto Mini Catálogo de Produtos.

## 📐 O que é MVVM?

MVVM é um padrão arquitetural que separa a apresentação da lógica de negócio:

```
┌─────────────────────────────────────────────┐
│               View (UI)                      │
│        (Flutter Widgets/Screens)            │
│                                              │
│  - LoginScreen                               │
│  - ProductsListScreen                        │
│  - AddProductScreen                          │
└────────────────┬────────────────────────────┘
                 │
                 │ Data Binding
                 │ (Provider)
                 │
┌────────────────▼────────────────────────────┐
│          ViewModel (Logic)                   │
│      (ChangeNotifier Providers)             │
│                                              │
│  - LoginViewModel                            │
│  - ProductsListViewModel                     │
│  - AddProductViewModel                       │
└────────────────┬────────────────────────────┘
                 │
                 │ Business Logic
                 │
┌────────────────▼────────────────────────────┐
│            Model (Data)                      │
│       (Services & Data Models)              │
│                                              │
│  - Product                                   │
│  - User                                      │
│  - AuthService                               │
│  - FirestoreService                          │
└─────────────────────────────────────────────┘
```

## 🔄 Fluxo de Dados

### 1. **Model (Camada de Dados)**

Responsável pelos modelos de dados e serviços:

```dart
// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  // ... outros campos
  
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    // Converte dados do Firestore para objeto Dart
  }
  
  Map<String, dynamic> toMap() {
    // Converte objeto para JSON (salva no Firestore)
  }
}
```

```dart
// lib/services/firestore_service.dart
class FirestoreService {
  Future<List<Product>> getAllProducts() async {
    // Busca produtos do Firestore
  }
  
  Future<String> addProduct(Product product) async {
    // Adiciona produto ao Firestore
  }
  
  Future<void> deleteProduct(String id) async {
    // Deleta produto do Firestore
  }
}
```

### 2. **ViewModel (Camada de Lógica)**

Gerencia o estado e a lógica de negócio:

```dart
// lib/viewmodels/products_list_viewmodel.dart
class ProductsListViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String? _selectedCategory;
  
  // Expõe os dados para a View
  List<Product> get products => _filteredProducts;
  String? get selectedCategory => _selectedCategory;
  
  // Métodos que alteram o estado
  Future<void> loadProducts() async {
    _allProducts = await _firestoreService.getAllProducts();
    _filteredProducts = _allProducts;
    notifyListeners(); // Notifica a View sobre mudanças
  }
  
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners(); // Atualiza a View
  }
  
  void _applyFilters() {
    // Lógica de filtro
  }
}
```

### 3. **View (Camada de Apresentação)**

Renderiza a UI e reage a mudanças no ViewModel:

```dart
// lib/views/screens/products_list_screen.dart
class ProductsListScreen extends StatefulWidget {
  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega dados quando a tela é criada
    context.read<ProductsListViewModel>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsListViewModel>(
      builder: (context, viewModel, _) {
        // Reconstrói quando o ViewModel notificar
        return ListView.builder(
          itemCount: viewModel.products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: viewModel.products[index],
            );
          },
        );
      },
    );
  }
}
```

## 🔗 Data Binding com Provider

O Provider estabelece a conexão entre View e ViewModel:

```dart
// main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductsListViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => AddProductViewModel(),
    ),
  ],
  child: MyApp(),
)
```

### Tipos de Consumers

#### 1. **Consumer**
Reconstrói quando o ViewModel muda:

```dart
Consumer<ProductsListViewModel>(
  builder: (context, viewModel, child) {
    return Text('Total: ${viewModel.products.length}');
  },
)
```

#### 2. **context.read()**
Acessa o ViewModel sem reconstruir:

```dart
onPressed: () {
  context.read<ProductsListViewModel>().filterByCategory('Eletrônicos');
}
```

#### 3. **context.watch()**
Observa e reconstrói em cada mudança:

```dart
Widget build(BuildContext context) {
  final viewModel = context.watch<ProductsListViewModel>();
  return Text('Total: ${viewModel.products.length}');
}
```

## 📊 Diagrama de Interação

### Cenário: Adicionar Produto

```
┌─────────────────────────────────────────────────────┐
│ 1. Usuário clica "Adicionar Produto"                 │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 2. AddProductScreen exibe formulário                 │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 3. Usuário preenche dados e clica "Salvar"           │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 4. View chama AddProductViewModel.addProduct()       │
│    (via context.read())                              │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 5. ViewModel executa lógica de validação             │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 6. ViewModel chama FirestoreService.addProduct()     │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 7. Service envia dados para Firestore                │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 8. Firestore confirma salvamento                     │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 9. Service retorna ID do produto                     │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 10. ViewModel notifica listeners (View)              │
│     viewModel.notifyListeners()                      │
└───────────────┬─────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────┐
│ 11. View reconstrói com sucesso                      │
│     Exibe mensagem de confirmação                    │
└─────────────────────────────────────────────────────┘
```

## 🎯 Benefícios da Arquitetura MVVM

### ✅ Separação de Responsabilidades
- **View**: Apenas renderiza a UI
- **ViewModel**: Gerencia lógica e estado
- **Model**: Gerencia dados

### ✅ Testabilidade
- ViewModels podem ser testados sem UI
- Services podem ser mockados
- Lógica é isolada

### ✅ Reusabilidade
- Mesma ViewModel pode ser usada em múltiplas Views
- Services são reutilizáveis
- Modelos são compartilhados

### ✅ Manutenibilidade
- Código organizado e estruturado
- Fácil de entender e debugar
- Mudanças na UI não afetam lógica

### ✅ Escalabilidade
- Fácil adicionar novas features
- Estrutura cresce organicamente
- Padrão consistente

## 📝 Boas Práticas

### 1. ViewModel nunca acessa View diretamente
```dart
// ❌ ERRADO
class ProductViewModel extends ChangeNotifier {
  void deleteProduct(BuildContext context) {
    // Não acessa BuildContext diretamente
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
}

// ✅ CORRETO
class ProductViewModel extends ChangeNotifier {
  String? _message;
  String? get message => _message;
  
  void deleteProduct() {
    _message = 'Produto deletado';
    notifyListeners();
  }
}
```

### 2. View não contém lógica de negócio
```dart
// ❌ ERRADO
Consumer<ProductsListViewModel>(
  builder: (context, viewModel, _) {
    // Lógica de filtro na View
    final filtered = viewModel.products
        .where((p) => p.price < 100)
        .toList();
    return ListView(children: ...);
  },
)

// ✅ CORRETO
Consumer<ProductsListViewModel>(
  builder: (context, viewModel, _) {
    // Apenas renderiza
    return ListView(
      children: viewModel.filteredProducts.map(...),
    );
  },
)
```

### 3. Usar `notifyListeners()` corretamente
```dart
// ✅ BOM
Future<void> loadProducts() async {
  _isLoading = true;
  notifyListeners();
  
  try {
    _products = await _service.getProducts();
  } catch(e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

## 🔍 Estrutura Recomendada de Pastas

```
lib/
├── models/           # Modelos de dados (imutáveis)
├── viewmodels/       # ViewModels (ChangeNotifier)
├── views/
│   ├── screens/      # Telas da app
│   └── widgets/      # Widgets reutilizáveis
├── services/         # Serviços de dados/API
├── themes/           # Estilos e temas
├── constants/        # Constantes da app
└── utils/            # Utilitários
```

## 📚 Recursos

- [Provider Documentation](https://pub.dev/packages/provider)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Flutter Architecture](https://flutter.dev/docs/app-architecture)

---

**Versão**: 1.0.0  
**Data**: 2024
