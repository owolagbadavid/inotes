import 'package:flutter/material.dart';
import 'package:inotes/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        "We have now sent you a password reset link, Please check your email for more informaion",
    optionsBuilder: () => {'OK': null},
  );
}
