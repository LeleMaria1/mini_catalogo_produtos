import 'package:flutter/material.dart';
import 'package:mini_catalogo_produtos/core/seeder/data_seeder.dart';
import 'package:mini_catalogo_produtos/features/auth/viewmodels/login_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/models/product.dart';
import 'package:mini_catalogo_produtos/features/products/viewmodels/products_list_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/views/add_product_screen.dart';
import 'package:mini_catalogo_produtos/features/products/views/edit_product_screen.dart';
import 'package:mini_catalogo_produtos/shared/widgets/category_chip.dart';
import 'package:mini_catalogo_produtos/shared/widgets/custom_app_bar.dart';
import 'package:mini_catalogo_produtos/shared/widgets/product_card.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  late TextEditingController _searchController;

  String get _currentUserKey {
    return context.read<LoginViewModel>().user?.email ?? '';
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsListViewModel>().loadProducts(_currentUserKey);
    });
  }

  Future<void> _seedMasterData() async {
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicializando dados mestres...')),
      );

      await DataSeeder.seedData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados mestres inicializados com sucesso.'),
          backgroundColor: Color(0xFF00B894),
        ),
      );

      await context.read<ProductsListViewModel>().loadProducts(_currentUserKey);
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString();
      final permissionMessage = errorMessage.contains('permission-denied') ||
              errorMessage.contains('restrita a administradores')
          ? 'Operação restrita a administradores no Firestore. Verifique as regras ou use autenticação admin.'
          : 'Erro ao inicializar dados mestres: $errorMessage';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(permissionMessage),
          backgroundColor: const Color(0xFFFF7675),
        ),
      );
    }
  }

  void _showProductActions(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(product.name),
                subtitle: const Text('Escolha uma ação para este produto'),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  _editProduct(product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFFF7675)),
                title: const Text('Excluir'),
                textColor: const Color(0xFFFF7675),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(product.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editProduct(Product product) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProductScreen(product: product),
      ),
    );

    if (!mounted) return;
    if (updated == true) {
      await context.read<ProductsListViewModel>().loadProducts(_currentUserKey);
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content:
              const Text('Deseja realmente excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await context
                    .read<ProductsListViewModel>()
                    .deleteProduct(id, _currentUserKey);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Color(0xFFFF7675)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Catálogo de Produtos',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'seed') {
                    _seedMasterData();
                  } else if (value == 'logout') {
                    context.read<LoginViewModel>().logout();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'seed',
                    child: Text('Inicializar Dados Mestres'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProductsListViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: viewModel.search,
                  decoration: InputDecoration(
                    hintText: 'Buscar produtos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.search('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _seedMasterData,
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Inicializar Dados Mestres'),
                  ),
                ),
              ),
              // Categories
              if (viewModel.categories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CategoryChip(
                        label: 'Todos',
                        isSelected: viewModel.selectedCategory == null,
                        onTap: () => viewModel.filterByCategory(null),
                      ),
                      const SizedBox(width: 8),
                      ...viewModel.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            label: category,
                            isSelected: viewModel.selectedCategory == category,
                            onTap: () =>
                                viewModel.filterByCategory(category),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              // Products Grid
              if (viewModel.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                )
              else if (viewModel.products.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum produto encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: viewModel.products.length,
                    itemBuilder: (context, index) {
                      final product = viewModel.products[index];
                      return ProductCard(
                        name: product.name,
                        description: product.description,
                        price: product.price,
                        imageUrl: product.imageUrl,
                        onTap: () => _showProductActions(product),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final productAdded = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const AddProductScreen(),
            ),
          );

          if (!context.mounted) return;

          if (productAdded == true) {
            await context
                .read<ProductsListViewModel>()
                .loadProducts(_currentUserKey);
          }
        },
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
