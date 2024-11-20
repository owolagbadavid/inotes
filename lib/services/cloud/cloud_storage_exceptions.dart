class CloudStorageExceptions implements Exception {
  final String message;
  const CloudStorageExceptions(this.message);
}

class CouldNotCreateNoteException extends CloudStorageExceptions {
  const CouldNotCreateNoteException()
      : super('Could not create note in cloud storage');
}

class CouldNotGetAllNotesException extends CloudStorageExceptions {
  const CouldNotGetAllNotesException()
      : super('Could not get all notes from cloud storage');
}

class CouldNotUpdateNoteException extends CloudStorageExceptions {
  const CouldNotUpdateNoteException()
      : super('Could not update note in cloud storage');
}

class CouldNotDeleteNoteException extends CloudStorageExceptions {
  const CouldNotDeleteNoteException()
      : super('Could not delete note from cloud storage');
}
