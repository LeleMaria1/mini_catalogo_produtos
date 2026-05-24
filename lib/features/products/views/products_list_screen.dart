import 'package:flutter/material.dart';
import 'package:mini_catalogo_produtos/core/services/data_seeder.dart';
import 'package:mini_catalogo_produtos/features/auth/viewmodels/login_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/viewmodels/products_list_viewmodel.dart';
import 'package:mini_catalogo_produtos/features/products/views/add_product_screen.dart';
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
  bool _isSeeding = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsListViewModel>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seedData() async {
    if (_isSeeding) return;

    setState(() {
      _isSeeding = true;
    });

    try {
      await DataSeeder.seedData();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados inicializados com sucesso.'),
          backgroundColor: Color(0xFF00B894),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao inicializar dados: $e'),
          backgroundColor: const Color(0xFFFF7675),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSeeding = false;
        });
      }
    }
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
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Logout'),
                    onTap: () => context.read<LoginViewModel>().logout(),
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
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSeeding ? null : _seedData,
                        icon: _isSeeding
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.storage_outlined),
                        label: Text(
                          _isSeeding
                              ? 'Inicializando...'
                              : 'Inicializar Dados',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
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
                          borderSide:
                              const BorderSide(color: Color(0xFFE8E8E8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE8E8E8)),
                        ),
                      ),
                    ),
                  ],
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
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} - R\$ ${product.price}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Excluir Produto'),
                              content: Text(
                                  'Tem certeza que deseja excluir ${product.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    viewModel.deleteProduct(product.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Excluir',
                                    style: TextStyle(color: Color(0xFFFF7675)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
            await context.read<ProductsListViewModel>().loadProducts();
          }
        },
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
