// Widgets
// show key word for import get only show specific part could come it handy for importing a lot stf stl
// You can give alias with as and name ex as devtools
// print can print a object but log cannot it needs to be a string so we use .toString method that every Object class has
import 'dart:developer' as console show log;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_in_need/helpers/loading/loading_screen.dart';
// abstract firebase in UI code
import 'package:hand_in_need/services/auth/bloc/auth_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';
import 'package:hand_in_need/services/auth/firebase_auth_provider.dart';
import 'package:hand_in_need/views/forgot_password_view.dart';
// Register and Login View files for our App
import 'package:hand_in_need/views/login_view.dart';
import 'package:hand_in_need/views/notes/create_update_note_view.dart';
import 'package:hand_in_need/views/notes/notes_view.dart';
import 'package:hand_in_need/views/register_view.dart';
import 'package:hand_in_need/views/verify_email_view.dart';
// routes for various screens
import 'constants/routes.dart';

// 8:12 Stateless vs Stateful
// Hot reload keeps state
// State is just data that is mutated by application or both like pressing button
// Widgets
// Stateful Widget widget contains information that can be changed as user interacts or as time goes by or widget seems fit
// Stateless widget can not contain mutable pieces of information and does not manage any internally

// Main.dart is going to serve to be the homepage for our app
// help us move between signing in as well as transition and such

// Remember when using git
// git log
// git add --all
// git commit -am "step2"
// git push

// git tag ""
// git status
// git push --tags

// main function does not get called during hot reload

// 29 : 48 TIME STAMP
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),

    home: BlocProvider<AuthBloc>(
      // auth bloc require auth provider Firebase
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    // parameter called routes for linking different part of page like register and login
    // takes in map as argument
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // getting our Bloc Provider which is in our context refer line 50 inject AuthBlock
    // use get function
    // use AuthBlock functionality by using add
    // .add
    // initialized firebase
    context.read<AuthBloc>().add(const AuthEventInitialize());
    // need blocConsuner
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // handle loading
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          // if state not loading
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // depending on our state return different views within our application
            // logged in
            if (state is AuthStateLoggedIn) {
              return const NotesView();
              // need verify
            } else if (state is AuthStateNeedsVerification) {
              return const VerifyEmailView();
              // logged out
            } else if (state is AuthStateLoggedOut) {
              return const LoginView();
              // if they are registering state
            } else if (state is AuthStateRegistering) {
              return const RegisterView();
              // forgot password
            } else if (state is AuthStateForgotPassword) {
              return const ForgotPasswordView();
            } else {
              // loading but can add other states in future
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  } // Build Context
} // HomePage Class
