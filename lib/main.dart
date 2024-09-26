import 'package:flutter/material.dart';
import 'package:inotes/views/login_view.dart';
import 'package:inotes/views/register_view.dart';
import 'package:inotes/views/verify_email_view.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/views/notes_view.dart';
import 'package:inotes/services/auth/auth_service.dart';
// import 'dart:developer' as dev show log;

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
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerfyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        await AuthService.firebase().init();

        // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      }(),
      builder: (context, snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user == null) {
              return const LoginView();
            } else if (user.isEmailVerified) {
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
