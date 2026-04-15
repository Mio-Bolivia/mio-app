import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/order_repository.dart';

class OrderState {
  final List<Order> orders;
  final bool isLoading;

  const OrderState({this.orders = const [], this.isLoading = false});

  OrderState copyWith({List<Order>? orders, bool? isLoading}) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _orderRepository;

  OrderNotifier(this._orderRepository) : super(const OrderState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true);
    try {
      final orders = await _orderRepository.getOrders();
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createOrder(Product product) async {
    state = state.copyWith(isLoading: true);
    try {
      final order = await _orderRepository.createOrder(product);
      state = state.copyWith(orders: [...state.orders, order], isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateStatus(String orderId, OrderStatus status) {
    final orders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: status,
          completedAt: status == OrderStatus.completed ? DateTime.now() : null,
        );
      }
      return order;
    }).toList();
    state = state.copyWith(orders: orders);
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.read(orderRepositoryProvider));
});

final ordersListProvider = Provider<List<Order>>((ref) {
  return ref.watch(orderProvider).orders;
});
