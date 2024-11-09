import 'package:inotes/services/auth/auth_service.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();

    test('Should not be intialized', () {
      assert(provider.isInitialized == false);
    });

    test('Cant log out when not intializaed', () {
      expect(provider.logout(), throwsA(isA<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.init();
      assert(provider.isInitialized == true);
    });

    test('User should be null', () {
      assert(provider.currentUser == null);
    });

    test('Should be able to intialze after 2 seconds', () async {
      await provider.init();
      assert(provider.isInitialized == true);
    }, timeout: const Timeout(Duration(seconds: 3)));

    test('Create User should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anyPass',
      );

      expect(badEmailUser, throwsA(isA<UserNotFoundAuthException>()));

      final badPassword = provider.createUser(
        email: 'any@email.com',
        password: 'foobar',
      );

      expect(badPassword, throwsA(isA<WrongPasswordAuthException>()));

      final user = await provider.createUser(
          email: 'email@me.com', password: "password");

      expect(provider.currentUser, user);

      assert(user.isEmailVerified == false);
    });

    test('Should verify logged in user', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;

      expect(user, isNot(Null));
      assert(user!.isEmailVerified == true);
    });

    test('Log out and log in again', () async {
      await provider.logout();
      assert(provider.currentUser == null);

      final user = await provider.login(
        email: 'email',
        password: 'pass',
      );

      expect(user, provider.currentUser);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 5));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'email@email.cm');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotLoggedInAuthException();
    }
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotLoggedInAuthException();
    }

    const newUser = AuthUser(isEmailVerified: true, email: 'ema@il.com');
    _user = newUser;
  }
}
