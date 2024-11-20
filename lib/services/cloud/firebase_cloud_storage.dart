import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inotes/services/cloud/cloud_note.dart';
import 'package:inotes/services/cloud/cloud_storage_constants.dart';
import 'package:inotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNote({
    required String ownerId,
  }) async {
    final doc = await notes.add({
      userIdFieldName: ownerId,
      textFieldName: '',
    });

    final note = await doc.get();

    return CloudNote.fromSnapshot(note);
  }

  Stream<Iterable<CloudNote>> allNotes({
    required String ownerId,
  }) {
    return notes
        .where(userIdFieldName, isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CloudNote.fromSnapshot(doc));
    });
  }

  Future<Iterable<CloudNote>> getNotes({
    required String ownerId,
  }) async {
    try {
      return notes
          .where(userIdFieldName, isEqualTo: ownerId)
          .get()
          .then((value) {
        return value.docs.map((doc) => CloudNote.fromSnapshot(doc));
      });
    } catch (e) {
      throw const CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw const CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw const CouldNotDeleteNoteException();
    }
  }
}
