// Create a new statful widget called notesView main UI for people login of our app
import 'package:flutter/material.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_actions.dart';
import 'dart:developer' as console show log;

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
                  console.log(shouldLogOut.toString());
                  // we need to make user logout first we need set up a condition for it
                  if (shouldLogOut) {
                    // Log out our user
                    await AuthService.firebase().logOut();
                    // after logging out lets take them to login view reroute them to
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
