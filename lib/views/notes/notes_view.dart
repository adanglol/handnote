// Create a new statful widget called notesView main UI for people login of our app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/cloud/cloud_note.dart';
import 'package:hand_in_need/services/cloud/firebase_cloud_storage.dart';
// comment out crud transition to cloud
// import 'package:hand_in_need/services/crud/notes_service.dart';
import 'package:hand_in_need/utilities/dialogs/logout_dialouge.dart';
import 'package:hand_in_need/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import 'dart:developer' as console show log;

import '../../services/auth/bloc/auth_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // grabbing instance of notes service so we can work with it
  late final FirebaseCloudStorage _notesService;
  // read current user ID
  String get userId => AuthService.firebase().currentUser!.id;

  // what happen when class is made will do once each time called init like python
  @override
  void initState() {
    // instance
    _notesService = FirebaseCloudStorage();
    super.initState();
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
              Navigator.of(context).pushNamed(
                createOrUpdateNoteRoute,
              );
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
                  final shouldLogOut = await logoutDialouge(context);
                  console.log(shouldLogOut.toString());
                  // we need to make user logout first we need set up a condition for it
                  if (shouldLogOut) {
                    // Log out our user
                    context.read<AuthBloc>().add(const AuthEventLogout());
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
      // UPDATE!!!
      // since we don't  need to create or get user from local data base we are going to cloud then we dont need future builder anymore
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // implicit fall through
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                // grab data
                final allNotes = snapshot.data as Iterable<CloudNote>;
                // list view
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
