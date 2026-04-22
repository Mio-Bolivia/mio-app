import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;

  const CartState({this.cart, this.isLoading = false, this.error});

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get itemCount => cart?.itemCount ?? 0;
  double get total => cart?.total ?? 0.0;
  int get totalQuantity => cart?.totalQuantity ?? 0;
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _cartRepository;

  CartNotifier(this._cartRepository) : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartRepository.getCart();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartRepository.addToCart(product, quantity: quantity);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartRepository.removeFromCart(cartItemId);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartRepository.updateItemQuantity(cartItemId, quantity);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartRepository.clearCart();
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(cartRepositoryProvider));
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.items ?? [];
});
