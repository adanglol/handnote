// Widgets
//show key word for import get only show specific part could come it handy for importing a lot
// You can give alias with as and name ex as devtools
import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Register and Login View files for our App
import 'package:hand_in_need/views/login_view.dart';
import 'package:hand_in_need/views/register_view.dart';
import 'package:hand_in_need/views/verify_email_view.dart';

import 'firebase_options.dart';

// 8:12 Stateless vs Stateful
// Hot reload keeps state
// State is just data that is mutated by application or both like pressing button
//Widgets
// Stateful Widget widget contains information that can be changed as user interacts or as time goes by or widget seems fit
// Stateless widget can not contain mutable pieces of information and does not manage any internally

// Main.dart is going to serve to be the homepage for our app
// help us move between signing in as well as transition and such

// Remember when using git
// git log
// git add --all
// git commit -am "step2"
// git push
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
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // Check our current user logged in to our app
            final user = FirebaseAuth.instance.currentUser;
            // print(user); debugg purposes and prints current user crendentials

            // accomodate condition to return correct widget if user verified print verfied
            // if user is present or not null
            if (user != null) {
              //check if the user email is verified
              if (user.emailVerified) {
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

// Create an enumeration for our Popup Menu items for popup menu button for giving user option in our app and logging out

enum MenuAction { logout }

// Create a new statful widget called notesView main UI for people login of our app

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        // Where our menu button and popup items will be under action param
        actions: [
          // PopUp menu button where our enum above is integrated and managed by button
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              // log is good tool for debug like console log in JS
              // can use too string since devtools.log expects string
              //devtools.log(value.toString());
              // switch statement to display our dialogue upoun logging out
              switch (value) {
                case MenuAction.logout:
                  // display our alert
                  final shouldLogOut = await showLogOutDialog(context);
                  devtools.log(shouldLogOut.toString());
                  // we need to make user logout first we need set up a condition for it
                  if (shouldLogOut) {
                    // Log out our user
                    await FirebaseAuth.instance.signOut();
                    // after logging out lets take them to login view reroute them to
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
              }
            },
            itemBuilder: (context) {
              // return list with our logout button connect with enum val for it
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Logout'))
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

// Create a future function for logout that returns either true or false

// show dialog - future funciton returns optional value
// alert dialog - stateless widget defines dialouge display to user itself
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    // help create an alert dialog for user
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        // buttons within our dialouge so two text buttons a yes or no
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
        ],
      );
    },
    // if the optional boolean not returned so if user leaves without pressing button we use then to set as false
    // if value present or not using then function
  ).then((value) => value ?? false);
}
