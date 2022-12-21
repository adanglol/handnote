// this is where all of our database exceptions or crud exceptins will be

// make an exception if our database already opened
class DatabaseAlreadyOpenExceptionn implements Exception {}

// unable to get doc directory exception
class UnableToGetDocumentDirectory implements Exception {}

// Exception if try close db when has not been open
class DatabaseIsNotOpen implements Exception {}

// Could not delete user in our database
class CouldNotDeleteUser implements Exception {}

// another exception when query data for our user if they already exist
class UserAlreadyExists implements Exception {}

// Error for get user if do not exist
class CouldNotFindUser implements Exception {}

// if we can not delete note in our app
class CouldNotDeleteNote implements Exception {}

// if we can not find note in app
class CouldNotFindNote implements Exception {}

//if we cannot update our note in app
class CouldNotUpdateNote implements Exception {}
