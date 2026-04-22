import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/buyer_endpoints.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'base_repository.dart';

abstract class CartRepository {
  Future<Cart> getCart();
  Future<CartItem> addToCart(Product product, {int quantity = 1});
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();
  Future<void> updateItemQuantity(String cartItemId, int quantity);
}

class MockCartRepository implements CartRepository {
  Cart? _currentCart;

  @override
  Future<Cart> getCart() async {
    _currentCart ??= Cart(
      id: 'mock-cart-1',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentCart!;
  }

  @override
  Future<CartItem> addToCart(Product product, {int quantity = 1}) async {
    _currentCart ??= Cart(
      id: 'mock-cart-1',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final existingItem =
        _currentCart!.items.firstWhere(
              (item) => item.product.code == product.code,
              orElse: () => null as dynamic,
            )
            as CartItem?;

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        addedAt: existingItem.addedAt,
      );
      final updatedItems = _currentCart!.items
          .map((item) => item.product.code == product.code ? updatedItem : item)
          .toList();
      _currentCart = _currentCart!.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
      return updatedItem;
    }

    final newItem = CartItem(
      id: 'item-${DateTime.now().millisecondsSinceEpoch}',
      product: product,
      quantity: quantity,
      addedAt: DateTime.now(),
    );

    _currentCart = _currentCart!.copyWith(
      items: [..._currentCart!.items, newItem],
      updatedAt: DateTime.now(),
    );

    return newItem;
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    _currentCart ??= Cart(
      id: 'mock-cart-1',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _currentCart = _currentCart!.copyWith(
      items: _currentCart!.items
          .where((item) => item.id != cartItemId)
          .toList(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> clearCart() async {
    _currentCart = Cart(
      id: 'mock-cart-1',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    _currentCart ??= Cart(
      id: 'mock-cart-1',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final updatedItems = _currentCart!.items.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    _currentCart = _currentCart!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
  }
}

class ApiCartRepository extends BaseRepository implements CartRepository {
  final ApiClient _apiClient;

  ApiCartRepository(this._apiClient);

  @override
  Future<Cart> getCart() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      BuyerEndpoints.myCart,
    );
    final payload = extractMapPayload(response);
    return Cart.fromJson(payload);
  }

  @override
  Future<CartItem> addToCart(Product product, {int quantity = 1}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      BuyerEndpoints.addToCart,
      data: {'productCode': product.code, 'quantity': quantity},
    );
    final payload = extractMapPayload(response);
    return CartItem.fromJson(payload);
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await _apiClient.post(
      BuyerEndpoints.removeFromCart,
      data: {'itemId': cartItemId},
    );
  }

  @override
  Future<void> clearCart() async {
    await _apiClient.delete(BuyerEndpoints.clearCart);
  }

  @override
  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    await _apiClient.put(
      BuyerEndpoints.myCart,
      data: {'itemId': cartItemId, 'quantity': quantity},
    );
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockCartRepository();
  }
  return ApiCartRepository(ApiClient.instance);
});
