import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

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
  OrderNotifier() : super(const OrderState());

  void createOrder(Product product) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(orders: [...state.orders, order]);
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
  return OrderNotifier();
});

final ordersListProvider = Provider<List<Order>>((ref) {
  return ref.watch(orderProvider).orders;
});
