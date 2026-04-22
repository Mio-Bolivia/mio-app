import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/buyer_endpoints.dart';
import '../models/product_model.dart';
import 'base_repository.dart';

abstract class FavoritesRepository {
  Future<List<Product>> getFavorites();
  Future<void> addToFavorites(Product product);
  Future<void> removeFromFavorites(String productCode);
  Future<bool> isFavorite(String productCode);
}

class MockFavoritesRepository implements FavoritesRepository {
  final Set<String> _favoriteIds = {};

  @override
  Future<List<Product>> getFavorites() async {
    // would return products with IDs in _favoriteIds
    return [];
  }

  @override
  Future<void> addToFavorites(Product product) async {
    _favoriteIds.add(product.code);
  }

  @override
  Future<void> removeFromFavorites(String productCode) async {
    _favoriteIds.remove(productCode);
  }

  @override
  Future<bool> isFavorite(String productCode) async {
    return _favoriteIds.contains(productCode);
  }
}

class ApiFavoritesRepository extends BaseRepository
    implements FavoritesRepository {
  final ApiClient _apiClient;

  ApiFavoritesRepository(this._apiClient);

  @override
  Future<List<Product>> getFavorites() async {
    final response = await _apiClient.get<dynamic>(BuyerEndpoints.myFavorites);
    final payload = extractListPayload(response);
    return payload.map((item) => Product.fromJson(item)).toList();
  }

  @override
  Future<void> addToFavorites(Product product) async {
    await _apiClient.post(
      BuyerEndpoints.addFavorite,
      data: {'productCode': product.code},
    );
  }

  @override
  Future<void> removeFromFavorites(String productCode) async {
    await _apiClient.post(
      BuyerEndpoints.removeFavorite,
      data: {'productCode': productCode},
    );
  }

  @override
  Future<bool> isFavorite(String productCode) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((product) => product.code == productCode);
    } catch (_) {
      return false;
    }
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockFavoritesRepository();
  }
  return ApiFavoritesRepository(ApiClient.instance);
});
