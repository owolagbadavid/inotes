part of 'auth_service.dart';

abstract class AuthenticationState {
  const AuthenticationState();

  List<Object?> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  AuthenticationLoadingState({required this.isLoading});
}

class AuthenticationSuccessState extends AuthenticationState {
  final AuthUser? user;

  const AuthenticationSuccessState(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LogoutConfirmationState extends AuthenticationState {}

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

class ConfirmLogoutRequested extends AuthenticationEvent {}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<ConfirmLogoutRequested>((event, emit) {
      // Emit a state that tells the UI to show the confirmation dialog
      emit(LogoutConfirmationState());
    });

    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        await AuthService.firebase()
            .createUser(email: event.email, password: event.password);

        emit(AuthenticationSuccessState(AuthService.firebase().currentUser));
      } on WeakPasswordAuthException {
        emit(const AuthenticationFailureState('Weak Password'));
      } on InvalidEmailAuthException {
        emit(const AuthenticationFailureState('Invalid Email'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      } on EmailAlreadyInUseAuthException {
        emit(const AuthenticationFailureState('Email Already In Use'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<LoginUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        await AuthService.firebase()
            .login(email: event.email, password: event.password);
        emit(AuthenticationSuccessState(AuthService.firebase().currentUser));
      } on WrongPasswordAuthException {
        emit(const AuthenticationFailureState('Wrong Password'));
      } on UserNotFoundAuthException {
        emit(const AuthenticationFailureState('User Not Found'));
      } on InvalidEmailAuthException {
        emit(const AuthenticationFailureState('Invalid Email'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        await AuthService.firebase().logout();
        emit(const AuthenticationSuccessState(null));
      } on UserNotLoggedInAuthException {
        emit(const AuthenticationFailureState('User Not Logged In'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SendEmailVerification>((event, emit) async {
      try {
        emit(AuthenticationLoadingState(isLoading: true));
        await AuthService.firebase().sendEmailVerification();

        emit(AuthenticationSuccessState(AuthService.firebase().currentUser));
      } on TooManyRequestsAuthException {
        emit(const AuthenticationFailureState('Too Many Requests'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      } finally {
        emit(AuthenticationLoadingState(isLoading: false));
      }
    });
  }
}
