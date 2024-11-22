// ignore: unused_import
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';

import 'package:inotes/services/auth/auth_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/utils/dialogs/error_dialog.dart';

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          if (state.exception != null) {
            if (state.exception is EmailAlreadyInUseAuthException) {
              showErrorDialog(context, 'Email already in use');
            } else if (state.exception is WeakPasswordAuthException) {
              showErrorDialog(context, 'Password is too weak');
            } else if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(context, 'Invalid Email');
            } else {
              showErrorDialog(context, 'An error occurred');
            }
          }
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     "Register",
        //   ),
        // ),
        body: LayoutBuilder(builder: (context, constraints) {
          double maxWidth = constraints.maxWidth < 600
              ? constraints.maxWidth * 0.9 // For small screens
              : 400; // For larger screens,
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: maxWidth,
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/notes.png', // Path to your logo
                          height: 80, // Adjust the size as needed
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'iNotes',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            final email = _email.text;
                            final password = _password.text;

                            // Trigger login action here, e.g., using Bloc
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(SignUpUser(email, password));
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(SignOut())
                          },
                          child: const Text(
                              'Already have an account? Login Here!'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
