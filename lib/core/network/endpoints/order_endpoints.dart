import '../api_endpoints.dart';

class OrderEndpoints extends ApiEndpoints {
  static const createOrder = '/orders/create';
  static const myOrders = '/orders';
  static const orderDetail = '/orders/{id}';
  static const orderStatus = '/orders/{id}/status';
  static const cancelOrder = '/orders/{id}/cancel';
  static const confirmPayment = '/orders/{id}/payment';
  static const pendingOrders = '/orders/pending';
  static const completedOrders = '/orders/completed';
}
