// Widgets
// show key word for import get only show specific part could come it handy for importing a lot stf stl
// You can give alias with as and name ex as devtools
// print can print a object but log cannot it needs to be a string so we use .toString method that every Object class has
import 'dart:developer' as console show log;
import 'package:flutter/material.dart';
// abstract firebase in UI code
import 'package:hand_in_need/services/auth/auth_service.dart';
// Register and Login View files for our App
import 'package:hand_in_need/views/login_view.dart';
import 'package:hand_in_need/views/notes_view.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),

    home: const HomePage(),
    // parameter called routes for linking different part of page like register and login
    // takes in map as argument
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

// Ensure that the current user in app is non null and email is verified
// We are gon send email to this email and click link
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //remove scaffold in our main we dont want embed others
    return FutureBuilder(
      // dont wanna push widgets in future builder
      // for future references and implementation
      // remedy future we are going to auth service so we are not directly talking firebase in UI
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // Check our current user logged in to our app
            final user = AuthService.firebase().currentUser;
            // print(user); debugg purposes and prints current user crendentials

            // accomodate condition to return correct widget if user verified print verfied
            // if user is present or not null
            if (user != null) {
              //check if the user email is verified
              if (user.isEmailVerified) {
                // when user is present and email has been verified take us to our app home widget
                return const NotesView();
              } else {
                // need to verify email
                return const VerifyEmailView();
              }
            } else {
              // if user is null send them to login view to login
              return const LoginView();
            }
          // fault back to if not done or loading in this case
          default:
            //instead of returning loading we can use widget to do so
            // need to fix presentation
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
