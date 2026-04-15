abstract class ApiEndpoints {
  static const String baseUrl = 'https://api.mio.app/v1';

  static final String _auth = '/auth';
  static final String _comprador = '/comprador';
  static final String _vendedor = '/vendedor';
  static final String _orden = '/orden';
  static final String _usuario = '/usuario';

  static String get authBase => _auth;
  static String get compradorBase => _comprador;
  static String get vendedorBase => _vendedor;
  static String get ordenBase => _orden;
  static String get usuarioBase => _usuario;

  static String buildPath(String base, Map<String, String> params) {
    String path = base;
    params.forEach((key, value) {
      path = path.replaceAll('{$key}', value);
    });
    return path;
  }
}
