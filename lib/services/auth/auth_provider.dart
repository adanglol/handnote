// This file will help with users and using providers like google fb etc to login with our app auth provider

// import out auth user file
import 'package:hand_in_need/services/auth/auth_user.dart';

// create a abstract class for auth provider fb google etc return current user also conforms to our class and what we specify
abstract class AuthProvider {
  // we need function to initilize FireBase
  Future<void> initialize();
  // return us current auth user
  AuthUser?
      get currentUser; // any auth provider need be able to option return current auth user

  // need to log user in
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  // Create our user
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // LogOut and send Email verification
  Future<void> logOut();
  Future<void> sendEmailVerification();
  // also need send reset password func
  Future<void> sendPasswordReset({required String toEmail});
}
