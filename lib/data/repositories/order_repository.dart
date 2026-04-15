import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/order_endpoints.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> createOrder(Product product);
}

class MockOrderRepository implements OrderRepository {
  final List<Order> _orders = [];

  @override
  Future<List<Order>> getOrders() async {
    return _orders;
  }

  @override
  Future<Order> createOrder(Product product) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    _orders.add(order);
    return order;
  }
}

class ApiOrderRepository implements OrderRepository {
  final ApiClient _apiClient;

  ApiOrderRepository(this._apiClient);

  @override
  Future<List<Order>> getOrders() async {
    final response = await _apiClient.get<dynamic>(OrderEndpoints.myOrders);
    final payload = _extractListPayload(response);
    return payload.map((item) => Order.fromJson(item)).toList();
  }

  @override
  Future<Order> createOrder(Product product) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      OrderEndpoints.createOrder,
      data: {'productCode': product.code},
    );
    final payload = _extractMapPayload(response);
    if (!payload.containsKey('product')) {
      payload['product'] = product.toJson();
    }
    return Order.fromJson(payload);
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

  Map<String, dynamic> _extractMapPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data;
    return response;
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockOrderRepository();
  }
  return ApiOrderRepository(ApiClient.instance);
});
