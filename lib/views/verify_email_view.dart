import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          const Text('Please verify your email'),
          TextButton(
              onPressed: () async => {
                    await FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification()
                  },
              child: const Text('Send verification email'))
        ],
      ),
    );
  }
}
