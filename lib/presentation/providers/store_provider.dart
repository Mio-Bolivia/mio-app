import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/store_model.dart';
import '../../data/repositories/store_repository.dart';

final storesProvider = FutureProvider<List<Store>>((ref) async {
  final repository = ref.read(storeRepositoryProvider);
  return repository.getStores();
});

final selectedStoreProvider = StateProvider<Store?>((ref) => null);
