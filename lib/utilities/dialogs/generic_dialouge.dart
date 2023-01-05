// handle our dialouges in a generic way
// T? = t optional andriod when display dialouge hardware down when responding

import 'package:flutter/material.dart';

// specify list of button with type string and every one of those buttons optionally have value
typedef DialougeOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialouge<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialougeOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(
                onPressed: () {
                  // checking value
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(optionTitle));
          }).toList(),
        );
      });
}
