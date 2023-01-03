// Create a new statful widget called notesView main UI for people login of our app
import 'package:flutter/material.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import 'package:hand_in_need/services/auth/auth_user.dart';
import 'package:hand_in_need/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import 'dart:developer' as console show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // grabbing instance of notes service so we can work with it
  late final NotesService _notesService;
  // read current user's email in notes view
  String get userEmail => AuthService.firebase().currentUser!.email!;

  // what happen when class is made will do once each time called init like python
  @override
  void initState() {
    // instance
    _notesService = NotesService();
    // open database
    _notesService.open();
    super.initState();
  }

  // get rid of functon what will happen
  @override
  void dispose() {
    // close database
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        // Where our menu button and popup items will be under action param
        actions: [
          // Icon button to add new notes and take us to new notes view
          IconButton(
            onPressed: () {
              // takes us to new notes view
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
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
      // in body we need create a user or get current user from database if already exist
      // use getter in notes view put in email param for future
      body: FutureBuilder(
        // get or create our user
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes to render...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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
