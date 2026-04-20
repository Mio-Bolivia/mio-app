/// Extracts a bearer token from typical auth JSON responses.
class AuthTokenParser {
  AuthTokenParser._();

  static String? extract(Map<String, dynamic> response) {
    String? fromMap(Map<String, dynamic> m) {
      for (final key in ['access_token', 'accessToken', 'token']) {
        final v = m[key];
        if (v is String && v.isNotEmpty) return v;
      }
      return null;
    }

    final direct = fromMap(response);
    if (direct != null) return direct;

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return fromMap(data);
    }
    return null;
  }
}
