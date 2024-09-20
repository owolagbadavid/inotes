import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inotes/firebase_options.dart';
import 'package:inotes/views/login_view.dart';
import 'package:inotes/views/register_view.dart';
import 'package:inotes/views/verify_email_view.dart';
import 'dart:developer' as dev show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView()
    },
  ));
}

enum MenuAction { logout }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      }(),
      builder: (context, snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              return const LoginView();
            } else if (user.emailVerified) {
              return const NotesView();
            } else {
              return const VerfyEmailView();
            }

          default:
            return const Center(
              child: Text("Error"),
            );
        }
      },
    );
  }
}

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
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (_) => false);
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
