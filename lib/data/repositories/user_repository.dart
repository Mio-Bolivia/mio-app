import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_token_parser.dart';
import '../../core/auth/secure_token_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints/auth_endpoints.dart';
import '../../core/network/endpoints/user_endpoints.dart';
import '../models/user_model.dart';
import 'base_repository.dart';

abstract class UserRepository {
  Future<User> login({required String email, required String password});
  Future<User> createAccount({required String email, required String password});
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? bankAccount,
    String? shippingAddress,
  });
  Future<void> becomeSeller();
  Future<String> uploadIdentityDocument(String imagePath);
  Future<void> saveBankAccount(String accountNumber);
}

class MockUserRepository implements UserRepository {
  User? _currentUser;

  @override
  Future<User> login({required String email, required String password}) async {
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      role: UserRole.both,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> createAccount({
    required String email,
    required String password,
  }) async {
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      role: UserRole.both,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? bankAccount,
    String? shippingAddress,
  }) async {
    _currentUser = _currentUser?.copyWith(
      name: name,
      phone: phone,
      bankAccount: bankAccount,
      shippingAddress: shippingAddress,
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

class ApiUserRepository extends BaseRepository implements UserRepository {
  final ApiClient _apiClient;
  final SecureTokenStorage _tokenStorage;

  ApiUserRepository(this._apiClient, this._tokenStorage);

  Future<void> _persistTokenIfPresent(Map<String, dynamic> response) async {
    final token = AuthTokenParser.extract(response);
    if (token != null) {
      await _tokenStorage.writeAccessToken(token);
    }
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.login,
      data: {'email': email, 'password': password},
    );
    await _persistTokenIfPresent(response);
    final payload = extractMapPayload(response);
    return User.fromJson(payload);
  }

  @override
  Future<User> createAccount({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.register,
      data: {'email': email, 'password': password},
    );
    await _persistTokenIfPresent(response);
    final payload = extractMapPayload(response);
    return User.fromJson(payload);
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? bankAccount,
    String? shippingAddress,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (bankAccount != null) data['bankAccount'] = bankAccount;
    if (shippingAddress != null) data['shippingAddress'] = shippingAddress;

    final response = await _apiClient.post<Map<String, dynamic>>(
      UserEndpoints.updateProfile,
      data: data,
    );
    final payload = extractMapPayload(response);
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
    final payload = extractMapPayload(response);
    return payload['id']?.toString() ?? '';
  }

  @override
  Future<void> saveBankAccount(String accountNumber) async {
    await _apiClient.post(
      UserEndpoints.bankAccount,
      data: {'accountNumber': accountNumber},
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  if (AppConstants.useMockRepositories) {
    return MockUserRepository();
  }
  return ApiUserRepository(ApiClient.instance, SecureTokenStorage.instance);
});
