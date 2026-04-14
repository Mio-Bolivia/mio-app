import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/buyer/store_detail_screen.dart';
import '../../presentation/screens/seller/seller_store_screen.dart';
import '../../presentation/screens/seller/add_product_screen.dart';
import '../../presentation/screens/seller/seller_requirements_screen.dart';
import '../../presentation/screens/payment/payment_screen.dart';
import 'route_names.dart';

final routerProvider = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: RouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/store',
      name: RouteNames.store,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return StoreDetailScreen(
          storeName: extra?['storeName'] ?? '',
          storeImage: extra?['storeImage'] ?? '',
          storeAvatar: extra?['storeAvatar'] ?? '',
          stars: extra?['stars'] ?? 0.0,
          reviews: extra?['reviews'] ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/seller/store',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SellerStoreScreen(
          storeName: extra?['storeName'] ?? '',
          storeImage: extra?['storeImage'] ?? '',
          storeAvatar: extra?['storeAvatar'] ?? '',
          stars: extra?['stars'] ?? 0.0,
          reviews: extra?['reviews'] ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/seller/store/:id',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SellerStoreScreen(
          storeName: extra?['storeName'] ?? '',
          storeImage: extra?['storeImage'] ?? '',
          storeAvatar: extra?['storeAvatar'] ?? '',
          stars: extra?['stars'] ?? 0.0,
          reviews: extra?['reviews'] ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/seller/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/seller-requirements',
      builder: (context, state) => const SellerRequirementsScreen(),
    ),
    GoRoute(
      path: '/payment',
      name: RouteNames.payment,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PaymentScreen(
          productName: extra['productName'] ?? '',
          productCode: extra['productCode'] ?? '',
          productPrice: extra['productPrice'] ?? 0.0,
          productImage: extra['productImage'] ?? '',
        );
      },
    ),
  ],
);
