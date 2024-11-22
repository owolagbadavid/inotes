part of 'auth_service.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUpUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SendEmailVerification extends AuthenticationEvent {}

class LoginUser extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOut extends AuthenticationEvent {}

class AuthEventShouldRegister extends AuthenticationEvent {}

class AuthEventInitialize extends AuthenticationEvent {}
