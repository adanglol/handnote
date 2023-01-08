// this is where our cloud storage exceptions will be
// when working with firestore and storing user data in cloud

// Our super class that will extend functionality with other exception classes
class CloudStorageException implements Exception {
  // creating constant constructor for it make it easier create instances
  const CloudStorageException();
}
// create subclasses for our exceptions

// if note could not be created
// Our C in Crud
class CouldNotCreateNoteException extends CloudStorageException {}

// if we can not get all notes ie internet connection etc
// Our R in Crud
class CouldNotGetAllNotesException extends CloudStorageException {}

// if we can not update our notes
// Our U in Crud
class CouldNotUpdateNoteException extends CloudStorageException {}

// if we can not delete our notes
// Our D in Crud
class CouldNotDeleteNoteException extends CloudStorageException {}
