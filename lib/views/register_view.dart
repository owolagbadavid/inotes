// ignore: unused_import
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:inotes/utils/show_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailureState) {
            showErrorDialog(context, state.errorMessage);
          } else if (state is AuthenticationSuccessState) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(SendEmailVerification());

            Navigator.pushNamedAndRemoveUntil(
              context,
              verifyEmailRoute,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
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
                  onPressed: () {
                    final email = _email.text;
                    final password = _password.text;

                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(SignUpUser(email, password));
                  },
                  child: state is AuthenticationLoadingState && state.isLoading
                      ? const SizedBox(
                          height: 20, // Set the desired height
                          width: 20, // Set the desired width
                          child: CircularProgressIndicator(
                            strokeWidth:
                                2, // Adjust the thickness of the progress indicator
                          ),
                        )
                      : const Text('Register')),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginRoute, (route) => false),
                },
                child: const Text('Already registered? Login Here!'),
              )
            ],
          );
        },
      ),
    );
  }
}
