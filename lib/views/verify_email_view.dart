// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/services/auth/auth_service.dart';

class VerfyEmailView extends StatefulWidget {
  const VerfyEmailView({super.key});

  @override
  State<VerfyEmailView> createState() => _VerfyEmailViewState();
}

class _VerfyEmailViewState extends State<VerfyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    await AuthService.firebase().sendEmailVerification(),
                  },
              child: const Text('Send verification email')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              //! async gap
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (_) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
