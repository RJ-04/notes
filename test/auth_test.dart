import 'package:project/services/auth/auth_exceptions.dart';
import 'package:project/services/auth/auth_provider.dart';
import 'package:project/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvidier();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('cannot log out if not initialized', () {
      expect(
        provider.signOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'should be able to intialize in 2 sec',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user shd delegate to signIn function', () async {
      final bademailuser = provider.createUser(
          email: 'riyanshjain2004@gmail.com', password: 'anypassword');

      expect(bademailuser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badpassworduser =
          provider.createUser(email: 'rj@gmail.com', password: 'rj_2004');

      expect(badpassworduser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'rj', password: 'jain');

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('signIn user shd be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;

      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('shd be able to log out and log in again', () async {
      await provider.signOut();
      await provider.signIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvidier implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AuthUser? _user;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return signIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser =
        AuthUser(isEmailVerified: true, email: 'rj@gmail.com', id: 'my_id');
    _user = newUser;
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (email == 'riyanshjain2004@gmail.com') {
      throw UserNotFoundAuthException();
    }
    if (password == 'rj_2004') {
      throw WrongPasswordAuthException();
    }
    const user =
        AuthUser(isEmailVerified: false, email: 'rj@gmail.com', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> signOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
