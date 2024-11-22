import 'package:firebase_auth/firebase_auth.dart'
    show User, FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:inotes/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// import 'package:meta/meta.dart';

part 'auth_exceptions.dart';
part 'auth_provider.dart';
part 'auth_user.dart';
part 'firebase_auth_provider.dart';
part 'auth_bloc.dart';
part 'auth_state.dart';
part 'auth_event.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => _firebaseInstance;

  static final _firebaseInstance = AuthService(
    FirebaseAuthProvider(),
  );

  @override
  Future<void> init() => provider.init();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
