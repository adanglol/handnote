// this file will help with Firebase Auth exceptions for our user
// we will be creating a class for each type of exception
// Creating exception class represents exception using implement keyword

// These Two classes are for our Login View Exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Now we have to manage our Registration View Exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic exceptions

class GenericAuthException implements Exception {}

// User not logged in auth exception -  exception firebase provider throw if user is null after registering

class UserNotLoggedInAuthException implements Exception {}
