part of 'auth_service.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;

  const AuthUser({required this.isEmailVerified, required this.email});

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(isEmailVerified: user.emailVerified, email: user.email);
  }
}
