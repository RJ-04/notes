/* sign in */

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

/* sign up  */

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

/* general  */

class GeneralAuthException implements Exception {}

class UserNotloggedInAuthException implements Exception {}
