import 'dart:io'; // Import for platform checks
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef OptionColorBuilder = Map<String, Color> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder<T> optionsBuilder,
  OptionColorBuilder? optionColorBuilder,
}) {
  final options = optionsBuilder();
  final optionColors = optionColorBuilder?.call() ?? {};

  if (Platform.isIOS) {
    // Separate the 'cancel' or 'no' option for the cancel button
    String? cancelOptionKey;
    T? cancelOptionValue;

    options.forEach((key, value) {
      if (key.toLowerCase() == 'cancel' || key.toLowerCase() == 'no') {
        cancelOptionKey = key;
        cancelOptionValue = value;
      }
    });

    // Remove the cancel option from the main options list if found
    if (cancelOptionKey != null) {
      options.remove(cancelOptionKey);
    }

    return showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text(title),
          message: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          actions: options.keys.map((optionTitle) {
            final optionValue = options[optionTitle];
            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(optionValue);
              },
              child: Text(
                optionTitle,
                style: TextStyle(
                  color:
                      optionColors[optionTitle] ?? CupertinoColors.activeBlue,
                ),
              ),
            );
          }).toList(),
          cancelButton: cancelOptionKey != null
              ? CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop(cancelOptionValue);
                  },
                  isDefaultAction: true,
                  child: Text(
                    cancelOptionKey!,
                  ),
                )
              : null, // No cancel button if not specified
        );
      },
    );
  } else {
    // Use Material AlertDialog for other platforms
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final optionValue = options[optionTitle];
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop(optionValue);
              },
              child: Text(
                optionTitle,
                style: TextStyle(
                  color: optionColors[optionTitle] ?? Colors.black,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
