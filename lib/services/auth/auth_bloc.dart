part of 'auth_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthProvider provider)
      : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<AuthEventInitialize>((event, emit) async {
      await provider.init();

      final user = provider.currentUser;

      if (user == null) {
        emit(AuthLoggedOutState());
      } else if (user.isEmailVerified) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(const AuthenticationNeedsVerificationState());
      }
    });

    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final user = await provider.createUser(
          email: event.email,
          password: event.password,
        );

        if (user.isEmailVerified == false) {
          emit(const AuthenticationNeedsVerificationState());
        } else {
          emit(AuthenticationSuccessState(user));
        }
      } on WeakPasswordAuthException {
        emit(const AuthenticationFailureState('Weak Password'));
      } on InvalidEmailAuthException {
        emit(const AuthenticationFailureState('Invalid Email'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      } on EmailAlreadyInUseAuthException {
        emit(const AuthenticationFailureState('Email Already In Use'));
      }
      // emit(AuthenticationLoadingState(isLoading: false));
    });

    on<LoginUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final user =
            await provider.login(email: event.email, password: event.password);

        if (user.isEmailVerified == false) {
          emit(const AuthenticationNeedsVerificationState());
        } else {
          emit(AuthenticationSuccessState(user));
        }
      } on WrongPasswordAuthException {
        emit(const AuthenticationFailureState('Wrong Password'));
      } on UserNotFoundAuthException {
        emit(const AuthenticationFailureState('User Not Found'));
      } on InvalidEmailAuthException {
        emit(const AuthenticationFailureState('Invalid Email'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      }
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        await provider.logout();
        emit(AuthLoggedOutState());
      } on UserNotLoggedInAuthException {
        emit(const AuthenticationFailureState('User Not Logged In'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      }
      // emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SendEmailVerification>((event, emit) async {
      try {
        emit(AuthenticationLoadingState(isLoading: true));
        await provider.sendEmailVerification();

        emit(const AuthenticationNeedsVerificationState());
      } on TooManyRequestsAuthException {
        emit(const AuthenticationFailureState('Too Many Requests'));
      } on GenericAuthException {
        emit(const AuthenticationFailureState('An Error Occurred'));
      } finally {}
    });
  }
}
