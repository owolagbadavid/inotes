part of 'auth_service.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(isEmailVerified: user.emailVerified);
  }
}
