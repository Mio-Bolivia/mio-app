import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

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
  final ProductRepository _productRepository;

  ProductNotifier(this._productRepository) : super(const ProductState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final products = await _productRepository.getProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  return ProductNotifier(ref.read(productRepositoryProvider));
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).filteredProducts;
});
