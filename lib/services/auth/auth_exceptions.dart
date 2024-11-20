part of 'auth_service.dart';

// Login Exception Classes
class UserNotFoundAuthException implements Exception {
  final String message = 'User Not Found';
}

class WrongPasswordAuthException implements Exception {
  final String message = 'Wrong password';
}

// Register Exception Classes
class EmailAlreadyInUseAuthException implements Exception {
  final String message = 'Email Already In Use';
}

class WeakPasswordAuthException implements Exception {
  final String message = 'Weak Password';
}

class TooManyRequestsAuthException implements Exception {
  final String message = 'Too Many Requests';
}

class InvalidEmailAuthException implements Exception {
  final String message = 'Invalid Email';
}

// generic exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {
  final String message = 'User Not Logged In';
}
