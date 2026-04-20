import '../auth/secure_token_storage.dart';
import '../network/api_client.dart';

class AppLifecycleService {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  factory AppLifecycleService() => _instance;
  AppLifecycleService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final tokenStorage = SecureTokenStorage.instance;
    ApiClient.instance.initialize(tokenStorage: tokenStorage);
    await tokenStorage.preload();

    _isInitialized = true;
  }

  Future<void> dispose() async {}
}
