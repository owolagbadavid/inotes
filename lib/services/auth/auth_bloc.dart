part of 'auth_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthProvider provider)
      : super(const AuthenticationInitialState(isLoading: true)) {
    on<AuthenticationEvent>((event, emit) {});

    on<AuthEventInitialize>((event, emit) async {
      await provider.init();

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthLoggedOutState(isLoading: false));
      } else if (user.isEmailVerified) {
        emit(AuthenticationSuccessState(user, isLoading: false));
      } else {
        emit(const AuthenticationNeedsVerificationState(isLoading: false));
      }
    });

    on<SignUpUser>((event, emit) async {
      try {
        await provider.createUser(
          email: event.email,
          password: event.password,
        );
        await provider.sendEmailVerification();

        emit(const AuthenticationNeedsVerificationState(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<LoginUser>((event, emit) async {
      emit(const AuthLoggedOutState(
        isLoading: true,
        loadingText: 'Logging in',
      ));
      try {
        final user = await provider.login(
          email: event.email,
          password: event.password,
        );

        if (user.isEmailVerified == false) {
          emit(const AuthLoggedOutState(isLoading: false));
          emit(const AuthenticationNeedsVerificationState(isLoading: false));
        } else {
          emit(const AuthLoggedOutState(isLoading: false));
          emit(AuthenticationSuccessState(user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthLoggedOutState(exception: e, isLoading: false));
      }
    });

    on<SignOut>((event, emit) async {
      // emit(AuthenticationLoadingState(isLoading: true));
      try {
        await provider.logout();
        emit(const AuthLoggedOutState(isLoading: false));
      } on Exception catch (e) {
        emit(AuthLoggedOutState(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<SendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
  }
}
