import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.role,
    required this.createdAt,
  });

  String get fullPhone => '$countryCode$phone';

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? countryCode,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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
