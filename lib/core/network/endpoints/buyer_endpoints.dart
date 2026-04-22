import 'api_endpoints.dart';

class BuyerEndpoints extends ApiEndpoints {
  static const myFavorites = '/buyer/favorites';
  static const addFavorite = '/buyer/favorites/add';
  static const removeFavorite = '/buyer/favorites/remove';
  static const myCart = '/buyer/cart';
  static const addToCart = '/buyer/cart/add';
  static const removeFromCart = '/buyer/cart/remove';
  static const clearCart = '/buyer/cart/clear';
  static const myPurchases = '/buyer/purchases';
  static const history = '/buyer/history';
  static const purchaseDetail = '/buyer/purchases/{id}';
  static const favoriteStores = '/buyer/stores/favorites';
}
