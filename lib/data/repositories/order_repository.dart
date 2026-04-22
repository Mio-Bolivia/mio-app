import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/order_endpoints.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import 'base_repository.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> createOrder(Product product);
  Future<Order> getOrderDetail(String orderId);
  Future<void> confirmPayment(String orderId, Map<String, dynamic> paymentData);
  Future<void> cancelOrder(String orderId);
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

  @override
  Future<Order> getOrderDetail(String orderId) async {
    return _orders.firstWhere(
      (order) => order.id == orderId,
      orElse: () => throw Exception('Order not found'),
    );
  }

  @override
  Future<void> confirmPayment(
    String orderId,
    Map<String, dynamic> paymentData,
  ) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = order.copyWith(status: OrderStatus.paid);
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = order.copyWith(status: OrderStatus.cancelled);
    }
  }
}

class ApiOrderRepository extends BaseRepository implements OrderRepository {
  final ApiClient _apiClient;

  ApiOrderRepository(this._apiClient);

  @override
  Future<List<Order>> getOrders() async {
    final response = await _apiClient.get<dynamic>(OrderEndpoints.myOrders);
    final payload = extractListPayload(response);
    return payload.map((item) => Order.fromJson(item)).toList();
  }

  @override
  Future<Order> createOrder(Product product) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      OrderEndpoints.createOrder,
      data: {'productCode': product.code},
    );
    final payload = extractMapPayload(response);
    if (!payload.containsKey('product')) {
      payload['product'] = product.toJson();
    }
    return Order.fromJson(payload);
  }

  @override
  Future<Order> getOrderDetail(String orderId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      OrderEndpoints.orderDetail.replaceFirst('{id}', orderId),
    );
    final payload = extractMapPayload(response);
    return Order.fromJson(payload);
  }

  @override
  Future<void> confirmPayment(
    String orderId,
    Map<String, dynamic> paymentData,
  ) async {
    await _apiClient.post(
      OrderEndpoints.confirmPayment.replaceFirst('{id}', orderId),
      data: paymentData,
    );
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await _apiClient.delete(
      OrderEndpoints.cancelOrder.replaceFirst('{id}', orderId),
    );
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockOrderRepository();
  }
  return ApiOrderRepository(ApiClient.instance);
});
