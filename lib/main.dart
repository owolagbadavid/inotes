// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inotes/firebase_options.dart';
import 'package:inotes/views/login_view.dart';
import 'package:inotes/views/register_view.dart';

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

            // if (user == null) {
            //   return const LoginView();
            // } else if (user.emailVerified) {
            //   return const Text("Logged In");
            // } else {
            //   return const VerfyEmailView();
            // }

            return const LoginView();

          default:
            return const Center(
              child: Text("Error"),
            );
        }
      },
    );
  }
}
