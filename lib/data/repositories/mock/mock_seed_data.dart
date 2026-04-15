import '../../models/product_model.dart';
import '../../models/store_model.dart';

class MockSeedData {
  static const List<Store> stores = [
    Store(
      id: '1',
      name: 'TechZone Colombia',
      image: 'https://picsum.photos/seed/store1/800/400',
      avatar: 'https://picsum.photos/seed/avatar1/100/100',
      stars: 4.8,
      reviews: 234,
      description: 'Los mejores Gadgets y tecnologia de ultima generacion',
    ),
    Store(
      id: '2',
      name: 'ElectroShop',
      image: 'https://picsum.photos/seed/store2/800/400',
      avatar: 'https://picsum.photos/seed/avatar2/100/100',
      stars: 4.5,
      reviews: 156,
      description: 'Electrodomesticos y accesorios para el hogar',
    ),
    Store(
      id: '3',
      name: 'Digital World',
      image: 'https://picsum.photos/seed/store3/800/400',
      avatar: 'https://picsum.photos/seed/avatar3/100/100',
      stars: 4.9,
      reviews: 89,
      description: 'Computadoras, moviles y accesorios gaming',
    ),
  ];

  static const List<Product> products = [
    Product(
      code: 'p1',
      name: 'iPhone 15 Pro',
      price: 5999000,
      available: 10,
      image: 'https://picsum.photos/seed/prod1/200/200',
      storeId: '1',
    ),
    Product(
      code: 'p2',
      name: 'Samsung S24',
      price: 4899000,
      available: 15,
      image: 'https://picsum.photos/seed/prod2/200/200',
      storeId: '1',
    ),
    Product(
      code: 'p3',
      name: 'AirPods Pro',
      price: 899000,
      available: 30,
      image: 'https://picsum.photos/seed/prod3/200/200',
      storeId: '1',
    ),
    Product(
      code: 'p4',
      name: 'MacBook Air M3',
      price: 5499000,
      available: 5,
      image: 'https://picsum.photos/seed/prod4/200/200',
      storeId: '1',
    ),
    Product(
      code: 'p5',
      name: 'Nevera Samsung',
      price: 2199900,
      available: 8,
      image: 'https://picsum.photos/seed/prod5/200/200',
      storeId: '2',
    ),
    Product(
      code: 'p6',
      name: 'Lavadora LG',
      price: 1899000,
      available: 12,
      image: 'https://picsum.photos/seed/prod6/200/200',
      storeId: '2',
    ),
    Product(
      code: 'p7',
      name: 'Microondas',
      price: 450000,
      available: 20,
      image: 'https://picsum.photos/seed/prod7/200/200',
      storeId: '2',
    ),
    Product(
      code: 'p8',
      name: 'PS5 Console',
      price: 2199000,
      available: 7,
      image: 'https://picsum.photos/seed/prod8/200/200',
      storeId: '3',
    ),
    Product(
      code: 'p9',
      name: 'RTX 4090',
      price: 7999000,
      available: 3,
      image: 'https://picsum.photos/seed/prod9/200/200',
      storeId: '3',
    ),
    Product(
      code: 'p10',
      name: 'Mouse G Pro',
      price: 350000,
      available: 50,
      image: 'https://picsum.photos/seed/prod10/200/200',
      storeId: '3',
    ),
  ];
}
