// faciliate actions in main UI of our app
// We are commenting everything because we are moving away from local storage and working with cloud storage

// import 'dart:async';
// // import 'dart:html';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:hand_in_need/lists/filter.dart';
// import 'package:hand_in_need/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesService {
//   Database? _db;
//   // cache our note data before immidetly interacting with database
//   List<DatabaseNote> _notes = [];

//   // define a current user so only notes releveant to user are shown
//   DatabaseUser? _user;
//   // want make sure user is set before grab list of notes
//   // notes service if want read all notes need make sure to set current user
//   // if not we need to set an exception to catch that

//   // we need to make this class a singleton so we dont have to make an instance over and over and over
//   // in case of using this for notes view we should not have multiple instances just one that is continuously used
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       // called when new listen subscribe to note stream controllers stream
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;
//   // add Stream controller so that our UI can reactively interact with data and work with code
//   // have pipeline to manipulate data continuosly
//   // broadcast saying ok to create to new listeners to new changes to stream controller
//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   // function that allows to retrieve all notes in note service
//   Stream<List<DatabaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   // function that allows us to read all available notes in our database and cache in our notes and controller
//   // private prefix _
//   Future<void> _cacheNotes() async {
//     // get all of our notes
//     final allNotes = await getAllNotes();
//     // assign it to our _notes needs be list since allNotes is Iterable
//     _notes = allNotes.toList();
//     // update our stream controller
//     _notesStreamController.add(_notes);
//   }

//   // function allows us to get or create user that is tied to our firebase user in our app
//   // parameter that also sets as current user
//   //
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     // try get user from database if it does not exist than we create one
//     try {
//       // this case we could get user
//       final user = await getUser(email: email);
//       // if we could retrieve user and bool is true set own user to this user
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       // we need create user
//       final createdUser = await createUser(email: email);
//       // if we had create user and param true then we have to set current user to created user
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//       // cheap way of making code easy debug
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // function allows us create notes in application return note takes in user as param
//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // make sure owner exists in the database with correct ID
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     // creating our note within our app
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });
//     // return new note instance and database note
//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );
//     // cache note in local varaible and add and update stream controller
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   //function that allow user to delete notes
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     // if we cant delete anything or note not exist given id
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       // if we can delete
//       // remove from our local cache varaible update stream controller
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   // function allows us to delete all notes in our app
//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(noteTable);
//     // resetting local  cache and update stream control
//     _notes = [];
//     _notesStreamController.add(_notes);
//     // delete entire row of notes
//     return numberOfDeletions;
//   }

//   // function that allows user to when pick note retrieve data of note based on id of it
//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // query the database
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     // if empty throw exception could not find note
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       // makes sense to update our local cache upoun creating instance database note
//       final note = DatabaseNote.fromRow(notes.first);
//       // remove old note with same id and add new one to stream
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);

//       // return a instance of Database note
//       return note;
//     }
//   }

//   // function that allows us to get all notes
//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // query the database no limit we want the whole list of notes
//     final notes = await db.query(noteTable);
//     // map function like in js return iterables
//     // returns list of notes in our app by user
//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   // function that allows the user to update existing notes
//   // 23:16 bug with updating
//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // make sure note exists
//     await getNote(id: note.id);

//     // update our notes in database
//     // we are not specifying which row we are updating so it is doing all of them need add where arguement
//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//     // calling update note  assume note should have exist in database update count should be other value beside 0
//     if (updatesCount == 0) {
//       // throw could not update note exception
//       throw CouldNotUpdateNote();
//     } else {
//       // return updated database note and also update cache
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   // function allow user be deleted in our database
//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   // function that allows us to create user in our database
//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // check if user given email already exist why we query
//     // avoid getting error for unique email why query
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     // if queried user exists - means user already exists throw error
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//     // if not case then we insert into our db
//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   // function that retrievs user given its email address
//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     // instead of checking if user exist we want to make sure it exist
//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       // first row of user table returns
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   // function check database private function
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   // need async func that opens our database
//   Future<void> open() async {
//     // test if database is opened
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     // get document directory path
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       // get the path of our actual database
//       final dbPath = join(
//         docsPath.path,
//         dbName,
//       );
//       // actually opening our database
//       final db = await openDatabase(dbPath);
//       // assign to our local db instance
//       _db = db;
//       // execute our command creating user table
//       await db.execute(createUserTable);
//       // do the same but for our note table
//       await db.execute(createNoteTable);
//       // cache the notes in our local variable
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectory();
//     }
//   }

//   // function that ensures that db is opening or can be
//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   // function to close our database
//   Future<void> close() async {
//     // check make sure cant close database if database is not open
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       // ask sqflite close db
//       await db.close();
//       // reset local database
//       _db = null;
//     }
//   }
// }

// // Our user
// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//   // every user inside the database user gonna be represented by this object
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//   // need implement to string so if we dont get instance returned for object
//   @override
//   String toString() => 'Person, ID = $id, email = $email';
//   // Also need implement equality behavior for our class to see if two different people are equal or not
//   // covariant change behavior of input param so they dont confirm to super class
//   // override already defined
//   // compare user of same class
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//   // id primary key of class and hash itself
//   @override
//   int get hashCode => id.hashCode;
// }

// // Notes
// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   // implement in future mess with various fields
//   final bool isSyncedWithCloud;
//   // constructor of each in our class
//   DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });
//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         // in database as int here specified as boolean we need write some logic
//         // if equal 1 return true else false which is 0
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';
//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// // param for our data base takes in id and email
// // data base user
// const idColumn = 'id';
// const emailColumn = 'email';
// // Database notes
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// // necessry constants file where db is saved
// const dbName = 'notes.db';
// const noteTable = 'note';
// const userTable = 'user';
// // tables in data base
// // code for our user table in data base
// // ''' allows place anything in string paste any code language there
// // create a table if it does not exist
// const createUserTable = '''
// CREATE TABLE IF NOT EXISTS "user"(
// "id"	INTEGER NOT NULL,
// "email"	TEXT NOT NULL UNIQUE,
// PRIMARY KEY("id")
// );
// ''';
// const createNoteTable = '''
// CREATE TABLE IF NOT EXISTS "note" (
// "id"	INTEGER NOT NULL,
// "user_id"	INTEGER NOT NULL,
// "text"	TEXT,
// "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// FOREIGN KEY("user_id") REFERENCES "user"("id"),
// PRIMARY KEY("id" AUTOINCREMENT)
// );
// ''';
