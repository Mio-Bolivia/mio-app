import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String email;
  final String password;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final DateTime createdAt;
  final String? bankAccount;
  final String? identityDocumentId;
  final bool isSeller;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    this.name,
    this.phone,
    this.avatarUrl,
    this.bankAccount,
    this.identityDocumentId,
    this.isSeller = false,
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    String? bankAccount,
    String? identityDocumentId,
    bool? isSeller,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
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
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
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
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
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
