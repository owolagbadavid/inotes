import 'package:flutter/material.dart';
import 'package:inotes/utils/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) async {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
    optionColorBuilder: () => {
      'Log out': Colors.red,
    },
  ).then((value) => value ?? false);
}
