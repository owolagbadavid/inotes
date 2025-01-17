// import 'package:flutter/foundation.dart';
// import 'package:inotes/extensions/list/filter.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'crud_exceptions.dart';
// import 'dart:async';

// class NotesService {
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DataBaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   Database? _db;

//   DataBaseUser? _user;

//   final List<DataBaseNote> _notes = [];

//   late final StreamController<List<DataBaseNote>> _notesStreamController;

//   Stream<List<DataBaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser == null) {
//           throw UserNotSetException();
//         }
//         return note.userId == currentUser.id;
//       });

//   Future<void> _cacheNotes() async {
//     final notes = await getNotes();
//     _notes.clear();
//     _notes.addAll(notes);
//     _notesStreamController.add(_notes);
//   }

//   Future<void> open() async {
//     if (_db != null) throw DataBaseAlreadyOpenException();

//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       await db.execute(createUsersTable);
//       await db.execute(createNotesTable);

//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsException();
//     }
//   }

//   Future<void> _ensureDBOpen() async {
//     try {
//       await open();
//     } on DataBaseAlreadyOpenException {
//       // ignore
//     }
//   }

//   Future<void> close() async {
//     if (_db == null) throw DataBaseNotOpenException();
//     await _db!.close();
//     _db = null;
//   }

//   Database _getDbOrThrow() {
//     if (_db == null) throw DataBaseNotOpenException();
//     return _db!;
//   }

//   Future<DataBaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on UserNotFoundException {
//       final user = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDBOpen();
//     final db = _getDbOrThrow();
//     final delCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (delCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   Future<DataBaseUser> createUser({required String email}) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final results = await db.query(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }

//     final id = await db.insert(
//       userTable,
//       {'email': email.toLowerCase()},
//     );

//     return DataBaseUser(id: id, email: email.toLowerCase());
//   }

//   Future<DataBaseUser> getUser({required String email}) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     return results.isNotEmpty
//         ? DataBaseUser.fromRow(results.first)
//         : throw UserNotFoundException();
//   }

//   Future<DataBaseNote> createNote({
//     required DataBaseUser owner,
//     String text = '',
//     bool push = true,
//   }) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final dbUser = await getUser(email: owner.email);

//     if (dbUser.id != owner.id) {
//       throw UserNotFoundException();
//     }

//     final id = await db.insert(
//       notesTable,
//       {
//         'user_id': owner.id,
//         'text': text,
//         'is_synced_with_cloud': 0,
//       },
//     );

//     final note =
//         DataBaseNote(id: id, text: text, userId: owner.id, isSynced: false);

//     if (push) {
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//     }

//     return note;
//   }

//   Future<void> deleteNote({
//     required int id,
//   }) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final delCount = await db.delete(
//       notesTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (delCount != 1) {
//       throw CouldNotDeleteNoteException();
//     }

//     _notes.removeWhere((element) => element.id == id);
//     _notesStreamController.add(_notes);
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final noOfDel = await db.delete(
//       notesTable,
//     );

//     _notes.clear();
//     _notesStreamController.add(_notes);

//     return noOfDel;
//   }

//   Future<DataBaseNote> getNote({required int id}) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final notes = await db.query(
//       notesTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notes.isEmpty) {
//       throw NoteNotFoundException();
//     }
//     final note = DataBaseNote.fromRow(notes.first);

//     _notes.removeWhere((element) => element.id == id);
//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   Future<List<DataBaseNote>> getNotes() async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     final notes = await db.query(
//       notesTable,
//     );

//     return notes.map((e) => DataBaseNote.fromRow(e)).toList();
//   }

//   Future<DataBaseNote> updateNote({
//     required DataBaseNote note,
//     required String text,
//   }) async {
//     await _ensureDBOpen();

//     final db = _getDbOrThrow();

//     await getNote(id: note.id);

//     final updateCount = await db.update(
//       notesTable,
//       {
//         'text': text,
//         'is_synced_with_cloud': 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updateCount == 0) {
//       throw CouldNotUpdateNote();
//     }

//     return getNote(id: note.id);
//   }
// }

// @immutable
// class DataBaseUser {
//   final int id;
//   final String email;

//   const DataBaseUser({
//     required this.id,
//     required this.email,
//   });

//   DataBaseUser.fromRow(Map<String, dynamic> row)
//       : id = row['id'] as int,
//         email = row['email'] as String;

//   @override
//   String toString() {
//     return 'User {id: $id, email: $email}';
//   }

//   @override
//   bool operator ==(covariant DataBaseUser other) {
//     return id == other.id && email == other.email;
//   }

//   @override
//   int get hashCode => id.hashCode;
// }

// class DataBaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSynced;

//   const DataBaseNote({
//     required this.id,
//     required this.text,
//     required this.userId,
//     required this.isSynced,
//   });

//   DataBaseNote.fromRow(Map<String, dynamic> row)
//       : id = row['id'] as int,
//         text = row['text'] as String,
//         userId = row['user_id'] as int,
//         isSynced = row['is_synced_with_cloud'] as int == 1 ? true : false;

//   @override
//   String toString() {
//     return 'Notes {id: $id, userId: $userId}';
//   }

//   @override
//   bool operator ==(covariant DataBaseNote other) {
//     return id == other.id;
//   }

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'inotes.db';
// const userTable = 'users';
// const notesTable = 'notes';
// const createUsersTable = '''
//   create table if not exists users 
//   (
//     id integer not null
//       constraint id
//         primary key autoincrement,
//     email TEXT not null
//       constraint email
//         unique
//   );
// ''';

// const createNotesTable = '''
//   create table if not exists notes 
//   (
//     id integer not null
//       constraint notes_pk
//         primary key autoincrement,
//     user_id integer not null
//       constraint notes_users_id_fk
//         references users,
//     text text,
//       is_synced_with_cloud int default 0 not null
//   );
// ''';
