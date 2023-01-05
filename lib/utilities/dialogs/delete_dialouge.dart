// where we prompt user to delete their notes with some dialouge
import 'package:flutter/material.dart';
import 'package:hand_in_need/utilities/dialogs/generic_dialouge.dart';

Future<bool> showDeleteDialouge(
  BuildContext context,
) {
  return showGenericDialouge(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
