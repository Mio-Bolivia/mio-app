import 'api_endpoints.dart';

class AuthEndpoints extends ApiEndpoints {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const googleLogin = '/auth/google';
  static const googleCallback = '/auth/google/callback';
  static const logout = '/auth/logout';
  static const refreshToken = '/auth/refresh';
  static const verificarToken = '/auth/verificar';
  static const perfil = '/usuario/perfil';
}
