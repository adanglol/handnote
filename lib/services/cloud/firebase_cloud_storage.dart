// handling cloud storage in firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_in_need/services/cloud/cloud_note.dart';
import 'package:hand_in_need/services/cloud/cloud_storage_constants.dart';
import 'package:hand_in_need/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // grab all notes from cloud storage
  // stream to read and write to
  final notes = FirebaseFirestore.instance.collection('notes');

  // function allow create new notes
  // we need this function not be void and actually return our new note
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    // this is our snapshot that will contain data of our doc
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // function allows us to update notes
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      // /notes/documentId within firestore
      // where we are updating
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  // function that allows us to delete notes
  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  // function allows us to retrieve all notes for a specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    // want to grab stream of data as its evolving wanna be able subscribe all changed want use snapshot
    // get takes snapshot at that point in time and returns
    // want be updated live need subscribe
    final allNotes = notes
        // where clause is exposing user notes wiht user without it exposes all user notes to user
        // filter before we get result of stream which is all our notes security reasons
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  // creating a singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
