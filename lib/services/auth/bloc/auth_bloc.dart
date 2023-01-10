// this is where our auth bloc will be
// being another layer between the UI and our firebase code

import 'package:bloc/bloc.dart';
import 'package:hand_in_need/services/auth/auth_provider.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';

// creating our Bloc taking in out Auth state and event param as event => state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // have our bloc take in a provider like our auth service
  // initial state of loading
  // {} after super to go to actual constructor of Auth Bloc
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // handle various events
    // based on events return different states for our app
    // --------------------------------------------------------
    // Initializing event
    on<AuthEventInitialize>(
      (event, emit) async {
        // call our provider and initialize
        await provider.initialize();
        final user = provider.currentUser;
        // if auth user is null after initialize then we know state should be logged out
        if (user == null) {
          emit(const AuthStateLoggedOut());
          // if there is user but if they are not verified we will take them to verify email state
        } else if (user.isEmailVerified == false) {
          emit(const AuthStateNeedsVerification());
        } else {
          // if they are not logged out and are verified then we can log them in
          // user is not const so we cant use const constructor
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    // Loggin in event
    on<AuthEventLogin>(
      (event, emit) async {
        // need to load maybe make API calls to login
        emit(const AuthStateLoading());
        // grab email and password for loggin in from auth event login state
        final email = event.email;
        final password = event.password;
        // try and catch to try login
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          // if no exceptions so no trouble logging in then we are going to emit
          emit(AuthStateLoggedIn(user));
          // any exception happen emit login failure
        } on Exception catch (e) {
          // exception in dart can be anything
          // need add on Exception since AuthStateLoginFailure is expecting one
          emit(AuthStateLoginFailure(e));
        }
      },
    );
    // Logging out event
    on<AuthEventLogout>(
      (event, emit) async {
        // try logging out if not emit exception
        try {
          // Loading
          emit(const AuthStateLoading());
          // logging out
          await provider.logOut();
          // after logging out if goes through emit to logged out
          emit(const AuthStateLoggedOut());
        } on Exception catch (e) {
          emit(AuthStateLogoutFailure(e));
        }
      },
    );
  }
}
