import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/seller_endpoints.dart';
import '../models/product_model.dart';
import 'base_repository.dart';
import 'mock/mock_seed_data.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int page = 1, int limit = 20});
  Future<Product> getProduct(String productCode);
  Future<List<Product>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  });
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    final start = (page - 1) * limit;
    final end = start + limit;
    return MockSeedData.products.sublist(
      start,
      end > MockSeedData.products.length ? MockSeedData.products.length : end,
    );
  }

  @override
  Future<Product> getProduct(String productCode) async {
    return MockSeedData.products.firstWhere(
      (product) => product.code == productCode,
      orElse: () => throw Exception('Product not found'),
    );
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final filtered = MockSeedData.products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.code.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    final start = (page - 1) * limit;
    final end = start + limit;
    return filtered.sublist(
      start,
      end > filtered.length ? filtered.length : end,
    );
  }
}

class ApiProductRepository extends BaseRepository implements ProductRepository {
  final ApiClient _apiClient;

  ApiProductRepository(this._apiClient);

  @override
  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get<dynamic>(
      SellerEndpoints.myProducts,
      queryParameters: {'page': page, 'limit': limit},
    );
    final payload = extractListPayload(response);
    return payload.map((item) => Product.fromJson(item)).toList();
  }

  @override
  Future<Product> getProduct(String productCode) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/products/$productCode',
    );
    final payload = extractMapPayload(response);
    return Product.fromJson(payload);
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<dynamic>(
      '/products/search',
      queryParameters: {'q': query, 'page': page, 'limit': limit},
    );
    final payload = extractListPayload(response);
    return payload.map((item) => Product.fromJson(item)).toList();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockProductRepository();
  }
  return ApiProductRepository(ApiClient.instance);
});
