import 'package:flutter/material.dart';
// import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/utils/dialogs/error_dialog.dart';

class VerfyEmailView extends StatefulWidget {
  const VerfyEmailView({super.key});

  @override
  State<VerfyEmailView> createState() => _VerfyEmailViewState();
}

class _VerfyEmailViewState extends State<VerfyEmailView> {
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationFailureState) {
          if (_isDialogOpen) {
            Navigator.of(context).pop(); // Close any open dialog first
            _isDialogOpen = false;
          }
          showErrorDialog(context, state.errorMessage);
        } else if (state is AuthenticationSuccessState) {
          if (_isDialogOpen) {
            Navigator.of(context).pop(); // Close the loading dialog
            _isDialogOpen = false;
          }
        } else if (state is AuthenticationLoadingState) {
          if (state.isLoading && !_isDialogOpen) {
            // Show loading dialog if not already open

            _isDialogOpen = true;
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              barrierDismissible: false, // Prevent dismissal by tapping outside
            );
          } else if (!state.isLoading && _isDialogOpen) {
            // Dismiss the loading dialog

            Navigator.of(context).pop();
            _isDialogOpen = false;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
          actions: [
            IconButton(
              onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Container(
          color: theme.cardColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "We've sent you a verification email.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(SendEmailVerification());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Resend Verification Email'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
