import '../network/api_client.dart';

class AppLifecycleService {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  factory AppLifecycleService() => _instance;
  AppLifecycleService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    ApiClient.instance.initialize();

    _isInitialized = true;
  }

  Future<void> dispose() async {}
}
