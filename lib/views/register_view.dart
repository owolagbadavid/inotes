// ignore: unused_import
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inotes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          "Register",
        ),
      ),
      body: Column(
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
                try {
                  final email = _email.text;
                  final password = _password.text;

                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  dev.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    dev.log('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    dev.log('The account already exists for that email.');
                  } else if (e.code == 'invalid-email') {
                    dev.log('The email address is not valid.');
                  }
                }
              },
              child: const Text("Register")),
          TextButton(
            onPressed: () => {
              Navigator.pushNamedAndRemoveUntil(
                  context, loginRoute, (route) => false),
            },
            child: const Text('Already registered? Login Here!'),
          )
        ],
      ),
    );
  }
}
