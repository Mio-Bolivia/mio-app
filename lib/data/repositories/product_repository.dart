import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/seller_endpoints.dart';
import '../models/product_model.dart';
import 'mock/mock_seed_data.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return MockSeedData.products;
  }
}

class ApiProductRepository implements ProductRepository {
  final ApiClient _apiClient;

  ApiProductRepository(this._apiClient);

  @override
  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get<dynamic>(SellerEndpoints.myProducts);
    final payload = _extractListPayload(response);
    return payload.map((item) => Product.fromJson(item)).toList();
  }

  List<Map<String, dynamic>> _extractListPayload(dynamic response) {
    if (response is List) {
      return response.whereType<Map<String, dynamic>>().toList();
    }
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const [];
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockProductRepository();
  }
  return ApiProductRepository(ApiClient.instance);
});
