// ignore: unused_import
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:inotes/utils/show_dialog.dart';
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
      appBar: AppBar(
        title: const Text(
          "Login",
        ),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailureState) {
            showErrorDialog(context, state.errorMessage);
          } else if (state is AuthenticationSuccessState) {
            if (state.user?.isEmailVerified ?? false) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                notesRoute,
                (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                verifyEmailRoute,
                (route) => false,
              );
            }
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
                        .add(LoginUser(email, password));
                  },
                  child: state is AuthenticationLoadingState && state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Login')),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registerRoute, (route) => false),
                },
                child: const Text('Not registered yet? Register Here!'),
              )
            ],
          );
        },
      ),
    );
  }
}
