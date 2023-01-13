// this is where our auth events will be implemented
import 'package:flutter/material.dart';

// define a abstract class that engulfs all other events (Generic Auth Event)
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

// initialize auth event for firebase
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

// Auth event for logging in
// login with email and a password
class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password);
}

// Auth event for logging out
// no param needed just logging out current user
class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

// need a event within email verify view to send email verification we need move it to our event
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

// need register event
class AuthEventRegister extends AuthEvent {
  // when we register we require email and password
  final String email;
  final String password;
  // make these required
  const AuthEventRegister({
    required this.email,
    required this.password,
  });
}

// need should register event - means if havent really registered user
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

// user forgot password event - means if user forgot password login we are going to restart it
class AuthEventForgotPassword extends AuthEvent {
  // we need grab user email so that we can send them one to reset
  final String? email;
  const AuthEventForgotPassword({this.email});
}
