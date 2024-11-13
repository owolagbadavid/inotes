import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder<T> optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final optionValue = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (optionValue != null) {
                Navigator.of(context).pop(optionValue);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              optionTitle,
              style: optionValue == true
                  ? const TextStyle(color: Colors.red)
                  : null,
            ),
          );
        }).toList(),
      );
    },
  );
}
