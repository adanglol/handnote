// list of notes in main UI of our application
// dont want to use notes service in list view be better to delegate it to our notes view
// better when working with code
import 'package:flutter/material.dart';
import 'package:hand_in_need/services/cloud/cloud_note.dart';
// comment away our crud moving to cloud
// import 'package:hand_in_need/services/crud/notes_service.dart';
import 'package:hand_in_need/utilities/dialogs/delete_dialouge.dart';

// define a function that we are going to use in note list view as callback when user deletes note or updates it
typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  // list of notes to display required param
  final Iterable<CloudNote> notes;
  // Our delete note callback
  final NoteCallback onDeleteNote;
  // Our tapping tile list callback
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // current note when work with list index like list[index]
        // for iterables you do elementAt(index)
        final note = notes.elementAt(index);
        return ListTile(
          // when the user click on the note displayed
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          // specify widge at end
          // where put trash can icon
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // make it show delete dialouge to display dialouge to prompt user whether to delete dialouge or not
              // return true or false depend whether deleted or not
              final shouldDelete = await showDeleteDialouge(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
