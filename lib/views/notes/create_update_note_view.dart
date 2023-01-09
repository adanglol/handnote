// when create notes in our UI this will be what shows brand new one
import 'package:flutter/material.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import 'package:hand_in_need/utilities/generics/get_arguements.dart';

// import our cloud database to our create notes UI
import 'package:hand_in_need/services/cloud/cloud_note.dart';
import 'package:hand_in_need/services/cloud/firebase_cloud_storage.dart';
import 'package:hand_in_need/services/cloud/cloud_storage_exceptions.dart';

// import from local database we are moving to the cloud \
// import 'package:sqflite/sqflite.dart';
// import 'package:hand_in_need/services/crud/notes_service.dart';

// left off at 21 hour mark creating new notes
//left off at abotu 22 hour on delete notes

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // keep hold current note so it does not repeat creating note over and over again
  CloudNote? _note;
  // keep reference to note service changed to firebase service because we going to cloud
  late final FirebaseCloudStorage _notesService;
  // need text editing controller for user to type in new notes
  late final TextEditingController _textController;

  // when new note view starts
  @override
  void initState() {
    // make sure we create an instance of noteservice and text controller
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  // function check if note has text and will update save it continously
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  // function first removes listerner from controller if added and adds again
  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // create new note
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // checking our database note for arguments
    final widgetNote = context.getArguement<CloudNote>();
    // eiter have note or dont or tapped on plus
    // existing note
    if (widgetNote != null) {
      // save in note variable
      _note = widgetNote;
      // make sure text field on screen should be prepopulated with notes text
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    // check if we have created note before inside _note var
    final exitingNote = _note;
    if (exitingNote != null) {
      return exitingNote;
    }
    final currentUser = AuthService.firebase()
        .currentUser!; // should expect have current user ! not case will crash
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    // saving our note
    _note = newNote;
    // return latest version of note
    return newNote;
  }

  // function that when disposed on new note if no text delete it we dont want invisible cells for user
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    // text input field is empty and note is not null so if it was created
    if (_textController.text.isEmpty && note != null) {
      // delete it
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  // function that allows user to save automatically if there is text usualy good for mobile not to include a save button

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    // if there is text and have note then update in database
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  // when we dispose our new note view
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      // utilizing functionality in UI usign future builder
      body: FutureBuilder(
        // create new note or get if it exists
        future: createOrGetExistingNote(context),
        // what kind build we want return widget
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // where want listen text changes in main UI
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                // allow user enter multiple lines of text
                keyboardType: TextInputType.multiline,
                // creating text field in multiline have to assign null in in maxline param
                maxLines: null,
                // adding hint indicate where user should type
                decoration: const InputDecoration(
                  hintText: 'Start typing your note here',
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
