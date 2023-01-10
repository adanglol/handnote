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
