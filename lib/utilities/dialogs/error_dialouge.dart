// generic way of displaying errors

import 'package:flutter/material.dart';
import 'package:hand_in_need/utilities/dialogs/generic_dialouge.dart';

Future<void> showErrorDialouge(
  BuildContext context,
  String text,
) {
  return showGenericDialouge<void>(
    context: context,
    title: 'An error occured',
    content: text,
    // remember that optionbuilder function returns map(dictionary)
    optionBuilder: () => {
      'OK': null,
    },
  );
}
