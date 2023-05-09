class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {
  /* C in CRUD */
}

class CouldNotGetAllNotesException extends CloudStorageException {
  /* R in CRUD */
}

class CouldNotUpdateNoteException extends CloudStorageException {
  /* U in CRUD */
}

class CouldNotDeleteNoteException {
  /* D in CRUD */
}
