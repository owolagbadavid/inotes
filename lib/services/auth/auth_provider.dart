part of 'auth_service.dart';

abstract class AuthProvider {
  Future<void> init();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  AuthUser? get currentUser;
}
