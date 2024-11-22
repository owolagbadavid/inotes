part of 'auth_service.dart';

abstract class AuthenticationState {
  final bool isLoading;
  final String loadingText;

  const AuthenticationState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });

  List<Object?> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {
  const AuthenticationInitialState({required super.isLoading});
}

class AuthStateRegistering extends AuthenticationState {
  final Exception? exception;
  // final bool isLoading;

  const AuthStateRegistering({
    // required this.isLoading,
    this.exception,
    required super.isLoading,
  });
}

class AuthenticationSuccessState extends AuthenticationState {
  final AuthUser? user;

  const AuthenticationSuccessState(this.user, {required super.isLoading});
  @override
  List<Object?> get props => [user];
}

//

class AuthenticationNeedsVerificationState extends AuthenticationState {
  const AuthenticationNeedsVerificationState({required super.isLoading});
}

class AuthLoggedOutState extends AuthenticationState with EquatableMixin {
  final Exception? exception;

  const AuthLoggedOutState({
    required super.isLoading,
    this.exception,
    super.loadingText,
  });

  @override
  List<Object?> get props => [isLoading, exception];
}

class AuthStateShouldRegister extends AuthenticationState {
  AuthStateShouldRegister({required super.isLoading});
}
