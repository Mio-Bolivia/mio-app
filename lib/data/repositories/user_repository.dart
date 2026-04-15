import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/user_endpoints.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<User> login({required String phone, required String countryCode});
  Future<User> createAccount({
    required String name,
    required String phone,
    required String countryCode,
  });
  Future<void> becomeSeller();
  Future<String> uploadIdentityDocument(String imagePath);
  Future<void> saveBankAccount(String accountNumber);
}

class MockUserRepository implements UserRepository {
  User? _currentUser;

  @override
  Future<User> login({required String phone, required String countryCode}) async {
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'User',
      phone: phone,
      countryCode: countryCode,
      role: UserRole.both,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> createAccount({
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      countryCode: countryCode,
      role: UserRole.both,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> becomeSeller() async {}

  @override
  Future<String> uploadIdentityDocument(String imagePath) async {
    return 'mock-doc-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> saveBankAccount(String accountNumber) async {}
}

class ApiUserRepository implements UserRepository {
  final ApiClient _apiClient;

  ApiUserRepository(this._apiClient);

  @override
  Future<User> login({required String phone, required String countryCode}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      UserEndpoints.myProfile,
      data: {'phone': phone, 'countryCode': countryCode},
    );
    final payload = _extractMapPayload(response);
    return User.fromJson(payload);
  }

  @override
  Future<User> createAccount({
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      UserEndpoints.updateProfile,
      data: {'name': name, 'phone': phone, 'countryCode': countryCode},
    );
    final payload = _extractMapPayload(response);
    return User.fromJson(payload);
  }

  @override
  Future<void> becomeSeller() async {
    await _apiClient.post(UserEndpoints.becomeSeller);
  }

  @override
  Future<String> uploadIdentityDocument(String imagePath) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(
        File(imagePath).path,
        filename: 'identity_document.jpg',
      ),
    });
    final response = await _apiClient.postFormData<Map<String, dynamic>>(
      UserEndpoints.identityDocument,
      formData,
    );
    final payload = _extractMapPayload(response);
    return payload['id']?.toString() ?? '';
  }

  @override
  Future<void> saveBankAccount(String accountNumber) async {
    await _apiClient.post(
      UserEndpoints.bankAccount,
      data: {'accountNumber': accountNumber},
    );
  }

  Map<String, dynamic> _extractMapPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data;
    return response;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockUserRepository();
  }
  return ApiUserRepository(ApiClient.instance);
});
