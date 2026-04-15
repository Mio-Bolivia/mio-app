import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/store_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/store_repository.dart';
import 'product_provider.dart';

final storesProvider = FutureProvider<List<Store>>((ref) async {
  final repository = ref.read(storeRepositoryProvider);
  return repository.getStores();
});

final productsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).products;
});

final selectedStoreProvider = StateProvider<Store?>((ref) => null);
