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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json['code']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      available: (json['available'] as num?)?.toInt() ?? 0,
      image: json['image']?.toString() ?? '',
      storeId: json['storeId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'price': price,
      'available': available,
      'image': image,
      'storeId': storeId,
    };
  }
}
