// faciliate actions in main UI of our app
// 18:19:39 left off here
import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hand_in_need/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class NotesService {
  Database? _db;
  // function allows us create notes in application return note takes in user as param
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    // make sure owner exists in the database with correct ID
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    // creating our note within our app
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    // return new note instance and database note
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    return note;
  }

  //function that allow user to delete notes
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    // if we cant delete anything or note not exist given id
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  // function allows us to delete all notes in our app
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    // delete entire row of notes
    return await db.delete(noteTable);
  }

  // function that allows user to when pick note retrieve data of note based on id of it
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    // query the database
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    // if empty throw exception could not find note
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      // return a instance of Database note
      return DatabaseNote.fromRow(notes.first);
    }
  }

  // function that allows us to get all notes
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    // query the database no limit we want the whole list of notes
    final notes = await db.query(noteTable);
    // map function like in js return iterables
    // returns list of notes in our app by user
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  // function that allows the user to update existing notes
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    // check if store in database before storing
    await getNote(id: note.id);
    // update our notes in database
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    // calling update note  assume note should have exist in database update count should be other value beside 0
    if (updatesCount == 0) {
      // throw could not update note exception
      throw CouldNotUpdateNote();
    } else {
      // return updated database note
      return await getNote(id: note.id);
    }
  }

  // function allow user be deleted in our database
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  // function that allows us to create user in our database
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    // check if user given email already exist why we query
    // avoid getting error for unique email why query
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    // if queried user exists - means user already exists throw error
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    // if not case then we insert into our db
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  // function that retrievs user given its email address
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    // instead of checking if user exist we want to make sure it exist
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      // first row of user table returns
      return DatabaseUser.fromRow(results.first);
    }
  }

  // function check database private function
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // need async func that opens our database
  Future<void> open() async {
    // test if database is opened
    if (_db != null) {
      throw DatabaseAlreadyOpenExceptionn();
    }
    // get document directory path
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      // get the path of our actual database
      final dbPath = join(
        docsPath.path,
        dbName,
      );
      // actually opening our database
      final db = await openDatabase(dbPath);
      // assign to our local db instance
      _db = db;
      // execute our command creating user table
      await db.execute(createUserTable);
      // do the same but for our note table
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }

  // function to close our database
  Future<void> close() async {
    // check make sure cant close database if database is not open
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      // ask sqflite close db
      await db.close();
      // reset local database
      _db = null;
    }
  }
}

// Our user
@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });
  // every user inside the database user gonna be represented by this object
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  // need implement to string so if we dont get instance returned for object
  @override
  String toString() => 'Person, ID = $id, email = $email';
  // Also need implement equality behavior for our class to see if two different people are equal or not
  // covariant change behavior of input param so they dont confirm to super class
  // override already defined
  // compare user of same class
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;
  // id primary key of class and hash itself
  @override
  int get hashCode => id.hashCode;
}

// Notes
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  // implement in future mess with various fields
  final bool isSyncedWithCloud;
  // constructor of each in our class
  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        // in database as int here specified as boolean we need write some logic
        // if equal 1 return true else false which is 0
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// param for our data base takes in id and email
// data base user
const idColumn = 'id';
const emailColumn = 'email';
// Database notes
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// necessry constants file where db is saved
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
// tables in data base
// code for our user table in data base
// ''' allows place anything in string paste any code language there
// create a table if it does not exist
const createUserTable = '''
CREATE TABLE IF NOT EXISTS "user"(
"id"	INTEGER NOT NULL,
"email"	TEXT NOT NULL UNIQUE,
PRIMARY KEY("id")
);
''';
const createNoteTable = '''
CREATE TABLE IF NOT EXISTS "note" (
"id"	INTEGER NOT NULL,
"user_id"	INTEGER NOT NULL,
"text"	TEXT,
"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
FOREIGN KEY("user_id") REFERENCES "user"("id"),
PRIMARY KEY("id" AUTOINCREMENT)
);
''';
