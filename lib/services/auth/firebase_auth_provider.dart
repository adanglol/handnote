// abstract firebase authentication into our own
// file will grow in size

// we need to import auth exceptins provider and users made previously
import 'package:hand_in_need/services/auth/auth_exceptions.dart'; // abstract auth errors and generic errors
import 'package:hand_in_need/services/auth/auth_provider.dart'; //  class auth user implementation
import 'package:hand_in_need/services/auth/auth_user.dart'; // login create user function need return auth user
// also need to import firebase as well also other libraries files associated
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import '../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// fire base auth class implements auth provider

class FirebaseAuthProvider implements AuthProvider {
  // initializing firebase
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // create user
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // Want to get our Firebase user and turn it to our Auth User
  // check if there is user or not equal null then create it with Auth User else null
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFireBase(user);
    } else {
      return null;
    }
  }

  // fire base login
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // add a timer show loading before loggin in
      await Future.delayed(const Duration(seconds: 2));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  } // async function

  // log out
  @override
  Future<void> logOut() async {
    // check if user exists before logging out
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  //email verification
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      // if user not logged in
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      // try to send password reset through firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
      // firebase auth exception when trying reset password for our user
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // email is invalid
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        // user not found within our application
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        // in any other case
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      //if anything happens during process of sending password reset email throw exception
      throw GenericAuthException();
    }
  }
} // Auth Provider
