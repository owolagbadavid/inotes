import 'package:flutter/material.dart';
import 'package:inotes/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage) async {
  await showGenericDialog<void>(
    context: context,
    title: 'Error',
    content: errorMessage,
    optionsBuilder: () => {'OK': null},
  );
}
