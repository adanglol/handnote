// this is where we will have the different states of our authentication within our bloc
// either user is logged in, or logged out, can also be logged out with an error
// three different states for our authentication within our application

// how bloc work
// bloc(event) => some state
// states are usually immutable
// counter state is generic state and is abstract

import 'package:flutter/material.dart';
import 'package:hand_in_need/services/auth/auth_provider.dart';
import 'package:hand_in_need/services/auth/auth_user.dart';

// lets create our generic state
// OUR STATES - outputs

@immutable
abstract class AuthState {
  // make const constructor in case other states and events need constant constructor
  const AuthState();
}

// Loading state for our AuthState
// can use the state of loading
// use it for open application and is initializing
// also use it for tapping login button in order login and communicate with firebase
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

// Logged In State
class AuthStateLoggedIn extends AuthState {
  // when have logged in what we need is the current user
  // moving to bloc, makes sense to grab current user logged in from application from current state from our Auth Bloc
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

// IMPORTANT - example below with Login failure
// states should carry with them all information the UI or consumer of Bloc requires in order fulfill requirements

// need take care of verification state within bloc
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// logged out state
// if we
class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

// define our log out errors states
class AuthStateLogoutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogoutFailure(this.exception);
}
