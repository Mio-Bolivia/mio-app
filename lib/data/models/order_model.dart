import 'package:flutter/foundation.dart';
import 'product_model.dart';

@immutable
class Order {
  final String id;
  final Product product;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Order({
    required this.id,
    required this.product,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  Order copyWith({
    String? id,
    Product? product,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Order(
      id: id ?? this.id,
      product: product ?? this.product,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      product: Product.fromJson((json['product'] as Map<String, dynamic>?) ?? {}),
      status: _statusFromString(json['status']?.toString()),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      completedAt: DateTime.tryParse(json['completedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  static OrderStatus _statusFromString(String? rawStatus) {
    switch (rawStatus) {
      case 'paid':
        return OrderStatus.paid;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}

enum OrderStatus { pending, paid, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.paid:
        return 'Pagado';
      case OrderStatus.completed:
        return 'Completado';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }
}
