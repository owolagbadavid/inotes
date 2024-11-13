import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/utils/dialogs/error_dialog.dart';

class VerfyEmailView extends StatefulWidget {
  const VerfyEmailView({super.key});

  @override
  State<VerfyEmailView> createState() => _VerfyEmailViewState();
}

class _VerfyEmailViewState extends State<VerfyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationFailureState) {
          showErrorDialog(context, state.errorMessage);
        } else if (state is AuthenticationSuccessState) {
          if (state.user == null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (_) => false);
          }
        } else if (state is AuthenticationLoadingState && state.isLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
        ),
        body: Column(
          children: [
            const Text("We've already sent you an email verification"),
            const Text(
                'If you have not received the verification email, press the button below'),
            TextButton(
                onPressed: () async => {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(SendEmailVerification())
                    },
                child: const Text('Send verification email')),
            TextButton(
              onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
              },
              child: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
