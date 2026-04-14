import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';

class ProductState {
  final List<Product> products;
  final String searchQuery;
  final bool isLoading;

  const ProductState({
    this.products = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  ProductState copyWith({
    List<Product>? products,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ProductState(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    final query = searchQuery.toLowerCase();
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.code.toLowerCase().contains(query),
        )
        .toList();
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier() : super(const ProductState()) {
    _loadProducts();
  }

  void _loadProducts() {
    state = state.copyWith(
      products: [
        const Product(
          code: 'PC-001',
          name: 'Laptop Gaming Pro X15',
          price: 1250.00,
          available: 15,
          image: 'https://picsum.photos/seed/prod1/400/500',
        ),
        const Product(
          code: 'PC-002',
          name: 'Smartphone Ultra Max',
          price: 899.50,
          available: 28,
          image: 'https://picsum.photos/seed/prod2/400/500',
        ),
        const Product(
          code: 'PC-003',
          name: 'Auriculares Wireless Pro',
          price: 149.99,
          available: 50,
          image: 'https://picsum.photos/seed/prod3/400/500',
        ),
        const Product(
          code: 'PC-004',
          name: 'Tablet 10.5 Pulgadas',
          price: 399.00,
          available: 12,
          image: 'https://picsum.photos/seed/prod4/400/500',
        ),
        const Product(
          code: 'PC-005',
          name: 'Smartwatch Sport Edition',
          price: 229.99,
          available: 35,
          image: 'https://picsum.photos/seed/prod5/400/500',
        ),
        const Product(
          code: 'PC-006',
          name: 'Cámara DSLR Profesional',
          price: 1599.00,
          available: 8,
          image: 'https://picsum.photos/seed/prod6/400/500',
        ),
        const Product(
          code: 'PC-007',
          name: 'Consola Gaming Next-Gen',
          price: 499.99,
          available: 20,
          image: 'https://picsum.photos/seed/prod7/400/500',
        ),
        const Product(
          code: 'PC-008',
          name: 'Teclado Mecánico RGB',
          price: 89.99,
          available: 45,
          image: 'https://picsum.photos/seed/prod8/400/500',
        ),
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  return ProductNotifier();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).filteredProducts;
});
