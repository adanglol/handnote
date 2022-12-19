// file will be for our auth user with Firebase help with auth and help not expose it to our UI
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'dart:developer' as console show log;

// immutable - annotation tells that classes or subclasses are never gonna be changed on initialization
@immutable
class AuthUser {
  // have a bool value to check whether our User is verified or not
  final bool isEmailVerified;
  const AuthUser(
      {required this.isEmailVerified}); // add {} and required for require param
  // create a factory constructor that creates AuthUser from Firebase User
  // useful want object X want create object Y from that
  // Given our user from firebase create an instance with our Auth User class
  factory AuthUser.fromFireBase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
