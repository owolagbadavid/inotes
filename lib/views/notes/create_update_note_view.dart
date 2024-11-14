import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:inotes/services/crud/notes_service.dart';
import 'package:inotes/utils/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DataBaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;
  var _isSaving = false;
  TextEditingValue _previousValue = TextEditingValue.empty;
  late final DataBaseNote? widgetNote;

  Future<DataBaseNote> createOrGetNote(BuildContext context) async {
    widgetNote = context.getArgument<DataBaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = _note!.text;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthService.firebase().currentUser!;
      final email = currentUser.email!;
      final owner = await _notesService.getOrCreateUser(email: email);

      final newNote = await _notesService.createNote(owner: owner, push: false);
      _note = newNote;
      return newNote;
    }
  }

  void _deleteNoteIfEmpty() async {
    final note = _note;
    if (note != null && _textController.text.isEmpty) {
      await _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNote() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty && _isSaving) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNote();
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;

    if (note != null) {
      TextEditingValue currentValue = _textController.value;

      // Detects if text has been added or deleted
      if (currentValue.text.length > _previousValue.text.length ||
          currentValue.text.length < _previousValue.text.length) {
        await _notesService.updateNote(
          note: note,
          text: _textController.text,
        );

        _isSaving = true;
      }

      // Update the previous value
      _previousValue = currentValue;
    }
  }

  void _setupTextController() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _previousValue = _textController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder<DataBaseNote>(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextController();
              _textController.text = _note?.text ?? '';
              return Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  autofocus: widgetNote == null,
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    // hintText: 'Enter your note here',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
