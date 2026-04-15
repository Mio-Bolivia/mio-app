import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final UserRole role;
  final DateTime createdAt;
  final String? bankAccount;
  final String? identityDocumentId;
  final bool isSeller;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.role,
    required this.createdAt,
    this.bankAccount,
    this.identityDocumentId,
    this.isSeller = false,
  });

  String get fullPhone => '$countryCode$phone';

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? countryCode,
    UserRole? role,
    DateTime? createdAt,
    String? bankAccount,
    String? identityDocumentId,
    bool? isSeller,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      bankAccount: bankAccount ?? this.bankAccount,
      identityDocumentId: identityDocumentId ?? this.identityDocumentId,
      isSeller: isSeller ?? this.isSeller,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '+57',
      role: _roleFromString(json['role']?.toString()),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      bankAccount: json['bankAccount']?.toString(),
      identityDocumentId: json['identityDocumentId']?.toString(),
      isSeller: json['isSeller'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'countryCode': countryCode,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'bankAccount': bankAccount,
      'identityDocumentId': identityDocumentId,
      'isSeller': isSeller,
    };
  }

  static UserRole _roleFromString(String? rawRole) {
    switch (rawRole) {
      case 'buyer':
        return UserRole.buyer;
      case 'seller':
        return UserRole.seller;
      case 'both':
      default:
        return UserRole.both;
    }
  }
}

enum UserRole { buyer, seller, both }

class CountryCode {
  final String code;
  final String name;
  final String flag;

  const CountryCode({
    required this.code,
    required this.name,
    required this.flag,
  });

  static const List<CountryCode> available = [
    CountryCode(code: '+57', name: 'Colombia', flag: '🇨🇴'),
    CountryCode(code: '+1', name: 'USA', flag: '🇺🇸'),
    CountryCode(code: '+34', name: 'España', flag: '🇪🇸'),
    CountryCode(code: '+52', name: 'México', flag: '🇲🇽'),
    CountryCode(code: '+54', name: 'Argentina', flag: '🇦🇷'),
    CountryCode(code: '+56', name: 'Chile', flag: '🇨🇱'),
    CountryCode(code: '+51', name: 'Perú', flag: '🇵🇪'),
    CountryCode(code: '+58', name: 'Venezuela', flag: '🇻🇪'),
  ];
}
