import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/enums/menu_action.dart';
import 'package:inotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes"), actions: <Widget>[
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

                if (shouldLogOut) {
                  await AuthService.firebase().logout();
                  //!: async gap
                  if (!context.mounted) return;

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
                return;
            }
          },
        )
      ]),
      body: const Text("Hello World"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      }).then(
    (value) => value ?? false,
  );
}
