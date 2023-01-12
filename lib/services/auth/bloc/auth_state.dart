// this is where we will have the different states of our authentication within our bloc
// either user is logged in, or logged out, can also be logged out with an error
// three different states for our authentication within our application

// how bloc work
// bloc(event) => some state
// states are usually immutable
// counter state is generic state and is abstract

import 'package:flutter/material.dart';
import 'package:hand_in_need/services/auth/auth_user.dart';
// import equatable so we dont have to overrid hascode comparison compare classes
import 'package:equatable/equatable.dart';
// lets create our generic state
// OUR STATES - outputs

// added isLoading to higher level to authstate so any authstate could be in loading state

@immutable
abstract class AuthState {
  // add isLoading so all states can be loading
  final bool isLoading;
  final String? loadingText;
  // make const constructor in case other states and events need constant constructor
  const AuthState({
    required this.isLoading,
    // we dont need required but we can give some text to wait moment
    this.loadingText = 'Please wait a moment',
  });
}

// state show that firebase and auth is not initialized within our application
class AuthStateUnintialized extends AuthState {
  // super pass isLoading
  const AuthStateUnintialized({required bool isLoading})
      : super(isLoading: isLoading);
}

// we need create registrating state when registering either goes well or some exceptions
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

// Logged In State
class AuthStateLoggedIn extends AuthState {
  // when have logged in what we need is the current user
  // moving to bloc, makes sense to grab current user logged in from application from current state from our Auth Bloc
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

// IMPORTANT - example below with Login failure
// states should carry with them all information the UI or consumer of Bloc requires in order fulfill requirements

// need take care of verification state within bloc
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

// logged out state
// we can bring in equality using mixin because already have extend
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  // three types of state of all same class
  // ------------------
  // no exception false
  // no exception true
  // exception false
  // -----------------
  // add flag isloading
  // loading state as bool T/F
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    // param indicate may want customize the text later authstate loading text
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );
  // we need return list of properties when equatable package compares
  // we have list that is computing exception and isloading
  // reason equatable to help produce various mutations of authstate logged out
  // those mutations with various exceptions and isloading need be distinguishable thats why
  @override
  List<Object?> get props => [exception, isLoading];
}
