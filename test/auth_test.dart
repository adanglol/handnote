// will be our test for our Auth Service
// make a mock provider to run in our Auth service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_in_need/services/auth/auth_exceptions.dart';
import 'package:hand_in_need/services/auth/auth_provider.dart';
import 'package:hand_in_need/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  // create group test
  // run test in terminal
  // flutter test filepath
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    // writing first test checking that our intialization is equal false if true then fails test
    // our provider should not be initialized to begin with
    test('Should not be intialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    // Test Logging out before intitialization
    test('Cannot log out if not intialized', () {
      // execute logout function and testing result of function against matcher
      // matcher is type exception go against
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    // Testing provider intialization
    test('Should be able to be intitalized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    // After intialization user should be null another test
    test('User should be null after intialization', () {
      expect(provider.currentUser, null);
    });

    // Testing time required to intialize
    // test should fail if intialize on provider takes longer than x amount of seconds
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      // timer as soon as it calls async function
      timeout: const Timeout(Duration(seconds: 2)),
    );
    // Test creating a user with badEmailUser and email param as well as password param
    test('Create User should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      // check wrong password test in create user
      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      // checking if provider user is equal to our Auth User class
      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      // test if user login isverified = false
      expect(user.isEmailVerified, false);
    });
    //test email verification functonality
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      // check if user verification set isEmailverified true
      expect(user!.isEmailVerified, true);
    });
    // Test loggin out and   loggin in again it should just work
    test('Should be able to log out log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  }); // group test
} // main

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false; // _ make property private to mockauth provider
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    // if mock provider not initialized throw error
    if (!isInitialized) throw NotInitializedException();
    // return future delay
    await Future.delayed(const Duration(seconds: 1));
    // return result of logging in
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    // add fake functionaility to run tests on them
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    // email param
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: 'foo@bar.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    // check if user is null then not found
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    // create new user assign it to current user
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      // param
      email: 'foo@bar.com',
    );
    _user = newUser;
  }

  // Excersice create test
  // implement states and events to help do so
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
