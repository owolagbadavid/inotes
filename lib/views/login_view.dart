// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
        ),
      ),
      body: FutureBuilder(
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
              break;
            default:
              return const Center(
                child: Text("Error"),
              );
          }

          return Column(
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter Email'),
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);

                      print(userCredential);
                    } on FirebaseAuthException catch (e) {
                      print(e.runtimeType);
                      print(e.code);
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: const Text("Login")),
            ],
          );
        },
      ),
    );
  }
}