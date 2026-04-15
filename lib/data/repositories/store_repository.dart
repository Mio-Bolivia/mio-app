import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/seller_endpoints.dart';
import '../models/store_model.dart';
import 'mock/mock_seed_data.dart';

abstract class StoreRepository {
  Future<List<Store>> getStores();
}

class MockStoreRepository implements StoreRepository {
  @override
  Future<List<Store>> getStores() async {
    return MockSeedData.stores;
  }
}

class ApiStoreRepository implements StoreRepository {
  final ApiClient _apiClient;

  ApiStoreRepository(this._apiClient);

  @override
  Future<List<Store>> getStores() async {
    final response = await _apiClient.get<dynamic>(SellerEndpoints.myStores);
    final payload = _extractListPayload(response);
    return payload.map((item) => Store.fromJson(item)).toList();
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

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockStoreRepository();
  }
  return ApiStoreRepository(ApiClient.instance);
});
