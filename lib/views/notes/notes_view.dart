// import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/enums/menu_action.dart';
import 'package:inotes/extensions/buildcontext/loc.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inotes/services/cloud/cloud_note.dart';
import 'package:inotes/services/cloud/firebase_cloud_storage.dart';
// import 'package:inotes/utils/dialogs/error_dialog.dart';
import 'package:inotes/utils/dialogs/logout_dialog.dart';
import 'package:inotes/views/notes/notes_list_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getCount {
    return map((list) => list.length);
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with TickerProviderStateMixin {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  List<SlidableController> _controllers = [];

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        // else if (state is AuthenticationLoadingState && state.isLoading) {
        //   showDialog(
        //     context: context,
        //     builder: (context) => const Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   );
        // }
      },
      child: Scaffold(
        appBar: AppBar(
            title: StreamBuilder<Object>(
                stream: _notesService.allNotes(ownerId: userId).getCount,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final count = snapshot.data as int? ?? 0;
                    final text = context.loc.notes_title(count);
                    return Text(text);
                  } else {
                    return const Text("");
                  }
                }),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                  },
                  icon: const Icon(Icons.add)),
              PopupMenuButton<MenuAction>(
                tooltip: 'Menu',
                itemBuilder: (context) => const <PopupMenuEntry<MenuAction>>[
                  PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                  ),
                ],
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogOut = await showLogOutDialog(context);

                      if (shouldLogOut && context.mounted) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          SignOut(),
                        );
                      }
                  }
                },
              ),
            ]),
        body: StreamBuilder(
            stream: _notesService.allNotes(ownerId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final notes = snapshot.data as Iterable<CloudNote>;
                    if (_controllers.length != notes.length) {
                      _controllers = List.generate(
                          notes.length, (_) => SlidableController(this));
                    }
                    return NotesListView(
                        notes: notes,
                        onDelete: (note) async {
                          await _notesService.deleteNote(
                            documentId: note.documentId,
                          );
                        },
                        onTap: (note) {
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                          );
                        },
                        controllers: _controllers);
                  } else {
                    return const Center(
                      child: Text("No notes"),
                    );
                  }
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            }),
      ),
    );
  }
}
