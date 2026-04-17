abstract class ApiEndpoints {
  static const String baseUrl = 'http://localhost:3000';

  static const String _auth = '/auth';
  static const String _tiendas = '/tiendas';
  static const String _productos = '/productos';
  static const String _ordenes = '/ordenes';

  static const login = _auth;
  static const register = _auth;
  static const logout = _auth;

  static const tiendas = _tiendas;
  static String tienda(String id) => '$_tiendas/$id';

  static const productos = _productos;
  static String producto(String id) => '$_productos/$id';

  static const ordenes = _ordenes;
  static const createOrden = '$_ordenes/create';
}
