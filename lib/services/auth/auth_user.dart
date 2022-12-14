// file will be for our auth user with Firebase help with auth and help not expose it to our UI
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'dart:developer' as console show log;

// immutable - annotation tells that classes or subclasses are never gonna be changed on initialization
@immutable
class AuthUser {
  // every user that comes into application should have id
  final String id;
  final String email;
  // have a bool value to check whether our User is verified or not
  final bool isEmailVerified;
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
  }); // add {} and required for require param
  // create a factory constructor that creates AuthUser from Firebase User
  // useful want object X want create object Y from that
  // Given our user from firebase create an instance with our Auth User class
  factory AuthUser.fromFireBase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
      );
}
