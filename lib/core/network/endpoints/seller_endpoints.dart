import 'api_endpoints.dart';

class SellerEndpoints extends ApiEndpoints {
  static const myStores = '/stores';
  static const createStore = '/seller/stores/create';
  static const updateStore = '/seller/stores/{id}/update';
  static const deleteStore = '/seller/stores/{id}/delete';
  static const myProducts = '/seller/products';
  static const createProduct = '/seller/products/create';
  static const updateProduct = '/seller/products/{id}/update';
  static const deleteProduct = '/seller/products/{id}/delete';
  static const mySales = '/seller/sales';
  static const pendingOrders = '/seller/orders/pending';
  static const completedOrders = '/seller/orders/completed';
  static const updateOrderStatus = '/seller/orders/{id}/status';
  static const statistics = '/seller/statistics';
  static const earnings = '/seller/earnings';
}
