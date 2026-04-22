import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/route_names.dart';
import '../../providers/product_provider.dart';
import '../../widgets/seller_store_header.dart';
import '../../widgets/seller_product_card.dart';

class SellerStoreScreen extends ConsumerStatefulWidget {
  final String storeName;
  final String storeImage;
  final String storeAvatar;
  final double stars;
  final int reviews;

  const SellerStoreScreen({
    super.key,
    required this.storeName,
    required this.storeImage,
    required this.storeAvatar,
    required this.stars,
    required this.reviews,
  });

  @override
  ConsumerState<SellerStoreScreen> createState() => _SellerStoreScreenState();
}

class _SellerStoreScreenState extends ConsumerState<SellerStoreScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openAddProductScreen() async {
    await context.pushNamed(RouteNames.addProduct);
    if (!mounted) return;
    await ref.read(productProvider.notifier).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductScreen,
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SellerStoreHeader(
              storeName: widget.storeName,
              storeAvatar: widget.storeAvatar,
              stars: widget.stars,
              reviews: widget.reviews,
              onBackPressed: () => Navigator.of(context).pop(),
              onSearchChanged: (value) {
                ref.read(productProvider.notifier).setSearchQuery(value);
              },
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SellerProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
