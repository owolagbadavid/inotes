// import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/enums/menu_action.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inotes/services/crud/notes_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inotes/utils/dialogs/error_dialog.dart';
import 'package:inotes/utils/dialogs/logout_dialog.dart';
import 'package:inotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with TickerProviderStateMixin {
  late final NotesService _notesService;
  String get email => AuthService.firebase().currentUser!.email!;
  List<SlidableController> _controllers = [];

  @override
  void initState() {
    _notesService = NotesService();
    // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationFailureState) {
          showErrorDialog(context, state.errorMessage);
        } else if (state is LogoutConfirmationState) {
          final shouldLogOut = await showLogOutDialog(context);

          if (shouldLogOut) {
            if (context.mounted) {
              BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
            }
          }
        } else if (state is AuthenticationSuccessState) {
          if (state.user == null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (_) => false);
          }
        } else if (state is AuthenticationLoadingState && state.isLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Notes"), actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
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
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    ConfirmLogoutRequested(),
                  );
                  return;
              }
            },
          ),
        ]),
        body: FutureBuilder(
            future: _notesService.getOrCreateUser(email: email),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _notesService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final notes = snapshot.data as List<DataBaseNote>;
                              if (_controllers.length != notes.length) {
                                _controllers = List.generate(notes.length,
                                    (_) => SlidableController(this));
                              }
                              return NotesListView(
                                  notes: notes,
                                  onDelete: (note) {
                                    _notesService.deleteNote(
                                      id: note.id,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Note deleted')),
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
                      });
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
