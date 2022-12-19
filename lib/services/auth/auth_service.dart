// going implement auth provider for service
// abstract functionality from UI
//import provider and user in this file
import 'package:hand_in_need/services/auth/auth_provider.dart';
import 'package:hand_in_need/services/auth/auth_user.dart';
import 'package:hand_in_need/services/auth/firebase_auth_provider.dart';

// why auth service an auth provider ? - relays messages of given auth provider but can have more logic
class AuthService implements AuthProvider {
  // Auth service that takes a provider
  final AuthProvider provider;
  const AuthService(this.provider);

  // responsibility is to return instance of auth service already configured with firebase auth provider
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );
  @override
  AuthUser? get currentUser => provider.currentUser;
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );
  @override
  Future<void> logOut() => provider.logOut();
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  @override
  Future<void> initialize() => provider.initialize();
}
