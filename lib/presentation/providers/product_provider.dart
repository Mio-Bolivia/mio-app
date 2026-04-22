import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductState {
  final List<Product> products;
  final List<Product> searchResults;
  final String searchQuery;
  final bool isLoading;
  final bool isSearching;
  final int currentPage;
  final int pageSize;
  final String? error;

  const ProductState({
    this.products = const [],
    this.searchResults = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isSearching = false,
    this.currentPage = 1,
    this.pageSize = 20,
    this.error,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? searchResults,
    String? searchQuery,
    bool? isLoading,
    bool? isSearching,
    int? currentPage,
    int? pageSize,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }

  List<Product> get displayedProducts =>
      searchQuery.isEmpty ? products : searchResults;

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    final query = searchQuery.toLowerCase();
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query) ||
              product.code.toLowerCase().contains(query),
        )
        .toList();
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _productRepository;

  ProductNotifier(this._productRepository) : super(const ProductState()) {
    loadProducts();
  }

  Future<void> loadProducts({int page = 1}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _productRepository.getProducts(
        page: page,
        limit: state.pageSize,
      );
      state = state.copyWith(
        products: products,
        isLoading: false,
        currentPage: page,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        searchResults: [],
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(searchQuery: query, isSearching: true, error: null);

    try {
      final results = await _productRepository.searchProducts(query);
      state = state.copyWith(searchResults: results, isSearching: false);
    } catch (e) {
      state = state.copyWith(isSearching: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> loadNextPage() async {
    final nextPage = state.currentPage + 1;
    await loadProducts(page: nextPage);
  }

  Future<void> refresh() async {
    await loadProducts(page: 1);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  return ProductNotifier(ref.read(productRepositoryProvider));
});

final displayedProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).displayedProducts;
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).filteredProducts;
});

final productSearchProvider = FutureProvider.family<List<Product>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  return ref.read(productRepositoryProvider).searchProducts(query);
});
