// ignore: unused_import
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:inotes/utils/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      // appBar: AppBar(
      //   title: const Text(
      //     "Login",
      //   ),
      // ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailureState) {
            showErrorDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraints) {
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
                                  .add(LoginUser(email, password));
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
                            child: state is AuthenticationLoadingState &&
                                    state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, registerRoute, (route) => false),
                            },
                            child: const Text(
                                'Not registered yet? Register Here!'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
