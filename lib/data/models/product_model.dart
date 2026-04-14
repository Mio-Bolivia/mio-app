import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String code;
  final String name;
  final double price;
  final int available;
  final String image;
  final String? storeId;

  const Product({
    required this.code,
    required this.name,
    required this.price,
    required this.available,
    required this.image,
    this.storeId,
  });

  bool get isAvailable => available > 0;

  Product copyWith({
    String? code,
    String? name,
    double? price,
    int? available,
    String? image,
    String? storeId,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      available: available ?? this.available,
      image: image ?? this.image,
      storeId: storeId ?? this.storeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
