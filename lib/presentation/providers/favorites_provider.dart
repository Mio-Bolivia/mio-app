import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesState {
  final List<Product> favorites;
  final Set<String> favoriteIds; // Fast search
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Product>? favorites,
    Set<String>? favoriteIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool isFavorite(String productCode) => favoriteIds.contains(productCode);
  int get count => favorites.length;
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesNotifier(this._favoritesRepository) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final favorites = await _favoritesRepository.getFavorites();
      final favoriteIds = {for (final p in favorites) p.code};
      state = state.copyWith(
        favorites: favorites,
        favoriteIds: favoriteIds,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addToFavorites(Product product) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _favoritesRepository.addToFavorites(product);
      await loadFavorites();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> removeFromFavorites(String productCode) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _favoritesRepository.removeFromFavorites(productCode);
      await loadFavorites();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFavorite(Product product) async {
    if (state.isFavorite(product.code)) {
      await removeFromFavorites(product.code);
    } else {
      await addToFavorites(product);
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier(ref.read(favoritesRepositoryProvider));
    });

final isFavoriteProvider = Provider.family<bool, String>((ref, productCode) {
  return ref.watch(favoritesProvider).isFavorite(productCode);
});
