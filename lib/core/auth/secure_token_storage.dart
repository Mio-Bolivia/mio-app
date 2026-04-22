import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  SecureTokenStorage._();

  static final SecureTokenStorage instance = SecureTokenStorage._();

  static const _kAccessToken = 'access_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _memoryToken;

  Future<void> preload() async {
    await readAccessToken();
  }

  Future<String?> readAccessToken() async {
    _memoryToken ??= await _storage.read(key: _kAccessToken);
    return _memoryToken;
  }

  Future<void> writeAccessToken(String token) async {
    _memoryToken = token;
    await _storage.write(key: _kAccessToken, value: token);
  }

  Future<void> clearAccessToken() async {
    _memoryToken = null;
    await _storage.delete(key: _kAccessToken);
  }
}
