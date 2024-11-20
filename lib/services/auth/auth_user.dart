part of 'auth_service.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;

  const AuthUser({
    required this.isEmailVerified,
    required this.email,
    required this.id,
  });

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(
      isEmailVerified: user.emailVerified,
      email: user.email!,
      id: user.uid,
    );
  }
}
