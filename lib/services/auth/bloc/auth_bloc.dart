// this is where our auth bloc will be
// being another layer between the UI and our firebase code

import 'package:bloc/bloc.dart';
import 'package:hand_in_need/services/auth/auth_provider.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';

// // creating our Bloc taking in out Auth state and event param as event => state
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   // have our bloc take in a provider like our auth service
//   // initial state of uninit
//   // {} after super to go to actual constructor of Auth Bloc
//   AuthBloc(AuthProvider provider)
//       : super(const AuthStateUnintialized(isLoading: true)) {
//     // handle various events
//     // based on events return different states for our app
//     // --------------------------------------------------------

//     // send email verifiction event
//     on<AuthEventSendEmailVerification>(
//       (event, emit) async {
//         // we need call and tell provider to send email verification
//         await provider.sendEmailVerification();
//         // emit same state we are in since its just sending email verify no need to switch screens
//         emit(state);
//       },
//     );

//     // Register Event
//     on<AuthEventRegister>(
//       (event, emit) async {
//         // register with provider passing in email and password from auth event register
//         // event = AuthEvent register for reference
//         final email = event.email;
//         final password = event.password;
//         // use try block in case we catch exceptions
//         try {
//           // try registering or create user
//           await provider.createUser(
//             email: email,
//             password: password,
//           );
//           // upon registering also send email verification once so user does not have to
//           await provider.sendEmailVerification();
//           // know that when users register need verification so we should emit
//           emit(const AuthStateNeedsVerification(isLoading: false));
//           // for exceptions
//         } on Exception catch (e) {
//           emit(AuthStateRegistering(
//             exception: e,
//             isLoading: false,
//           ));
//         }
//       },
//     );

//     // Initializing event
//     on<AuthEventInitialize>(
//       (event, emit) async {
//         // call our provider and initialize
//         await provider.initialize();
//         final user = provider.currentUser;
//         // if auth user is null after initialize then we know state should be logged out
//         if (user == null) {
//           // when user initializes application by default they are logged out if user null
//           emit(const AuthStateLoggedOut(
//             exception: null,
//             isLoading: false,
//           ));
//           // if there is user but if they are not verified we will take them to verify email state
//         } else if (!user.isEmailVerified) {
//           // not loading anything
//           emit(const AuthStateNeedsVerification(isLoading: false));
//         } else {
//           // if they are not logged out and are verified then we can log them in
//           // user is not const so we cant use const constructor
//           emit(AuthStateLoggedIn(
//             user: user,
//             isLoading: false,
//           ));
//         }
//       },
//     );
//     // Loggin in event
//     on<AuthEventLogin>(
//       (event, emit) async {
//         // Loading
//         emit(const AuthStateLoggedOut(
//           exception: null,
//           isLoading: true,
//         ));

//         // grab email and password for loggin in from auth event login state
//         final email = event.email;
//         final password = event.password;
//         // try and catch to try login
//         try {
//           final user = await provider.logIn(
//             email: email,
//             password: password,
//           );

//           // we also need to check if the user is verified their email
//           if (!user.isEmailVerified) {
//             // update our loading
//             emit(
//               const AuthStateLoggedOut(
//                 exception: null,
//                 isLoading: false,
//               ),
//             );
//             // then take them to email verification state
//             emit(const AuthStateNeedsVerification(isLoading: false));
//           } else {
//             // if user email is verified
//             // -------------------------
//             // update our loading
//             emit(const AuthStateLoggedOut(
//               exception: null,
//               isLoading: false,
//             ));
//             // if no exceptions so no trouble logging in then we are going to emit
//             emit(AuthStateLoggedIn(
//               user: user,
//               isLoading: false,
//             ));
//           }
//           // any exception happen emit login failure
//         } on Exception catch (e) {
//           // exception in dart can be anything
//           // need add on Exception since  is expecting one also add not loading
//           emit(AuthStateLoggedOut(
//             isLoading: false,
//             exception: e,
//           ));
//         }
//       },
//     );
//     // Logging out event
//     on<AuthEventLogout>(
//       (event, emit) async {
//         try {
//           // try to log out
//           await provider.logOut();
//           // emit new state logged out no exceptions
//           emit(const AuthStateLoggedOut(
//             exception: null,
//             isLoading: false,
//           ));
//           // any exceptions when logging out
//         } on Exception catch (e) {
//           emit(AuthStateLoggedOut(
//             exception: e,
//             isLoading: false,
//           ));
//         }
//       },
//     );
//   }
// }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnintialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });

    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    // log in
    on<AuthEventLogin>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // log out
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}
