import 'package:flutter/foundation.dart';

@immutable
class Store {
  final String id;
  final String name;
  final String image;
  final String avatar;
  final double stars;
  final int reviews;
  final String? ownerId;
  final String? description;

  const Store({
    required this.id,
    required this.name,
    required this.image,
    required this.avatar,
    required this.stars,
    required this.reviews,
    this.ownerId,
    this.description,
  });

  Store copyWith({
    String? id,
    String? name,
    String? image,
    String? avatar,
    double? stars,
    int? reviews,
    String? ownerId,
    String? description,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      avatar: avatar ?? this.avatar,
      stars: stars ?? this.stars,
      reviews: reviews ?? this.reviews,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Store && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      stars: (json['stars'] as num?)?.toDouble() ?? 0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      ownerId: json['ownerId']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'avatar': avatar,
      'stars': stars,
      'reviews': reviews,
      'ownerId': ownerId,
      'description': description,
    };
  }
}
