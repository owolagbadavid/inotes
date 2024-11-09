import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/enums/menu_action.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/utils/show_dialog.dart';
import 'package:inotes/services/crud/notes_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with TickerProviderStateMixin {
  late final NotesService _notesService;
  String get email => AuthService.firebase().currentUser!.email!;

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
                              final controllers = List.generate(notes.length,
                                  (_) => SlidableController(this));

                              return ListView(children: [
                                Card(
                                  margin: const EdgeInsets.all(
                                      16.0), // Space around the card
                                  color: const Color.fromARGB(255, 195, 193,
                                      193), // Light grey background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded corners
                                  ),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap:
                                        true, // To prevent infinite height error
                                    // physics: const ClampingScrollPhysics(),
                                    itemCount: notes.length,
                                    itemBuilder: (context, index) {
                                      int i;
                                      final note = notes[index];
                                      final controller = controllers[index];
                                      return Slidable(
                                        controller: controller,
                                        key: Key(note.id.toString() +
                                            DateTime.now().toString()),
                                        endActionPane: ActionPane(
                                          // A motion is a widget used to control how the pane animates.
                                          motion: const StretchMotion(),

                                          // A pane can dismiss the Slidable.
                                          dismissible: DismissiblePane(
                                              // closeOnCancel: true,
                                              confirmDismiss: () async {
                                                controller.openTo(-0.5);
                                                return false;
                                              },
                                              onDismissed: () {}),

                                          // All actions are defined in the children parameter.
                                          children: [
                                            // A SlidableAction can have an icon and/or a label.

                                            SlidableAction(
                                              autoClose: false,
                                              onPressed: (_) async {
                                                controller.openTo(-1);

                                                var shouldDelete =
                                                    await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Are you sure you want to delete this note?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                          child: const Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).then((value) =>
                                                        value ?? false);

                                                if (shouldDelete) {
                                                  controller.dismiss(
                                                      ResizeRequest(
                                                          const Duration(
                                                              milliseconds:
                                                                  150), () {
                                                    _notesService.deleteNote(
                                                        id: note.id);

                                                    setState(() {
                                                      notes.removeAt(index);
                                                      controllers
                                                          .removeAt(index);
                                                    });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Note deleted')),
                                                    );
                                                  }));
                                                } else {
                                                  await controller.close();
                                                }
                                              }, // Dismisses the Slidable.

                                              backgroundColor:
                                                  const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10.0,
                                              vertical:
                                                  0), // Adjust these values as needed

                                          title: Text(note.text,
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          subtitle: Text(
                                              (i = note.text.indexOf('\n')) ==
                                                      -1
                                                  ? 'No additional text'
                                                  : note.text.substring(i + 1),
                                              maxLines: 1),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        indent: 15,
                                        height: 1,
                                        color:
                                            Colors.grey, // Customize the color
                                        thickness:
                                            1.0, // Customize the thickness
                                      );
                                    },
                                  ),
                                ),
                              ]);
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
