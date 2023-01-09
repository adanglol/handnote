// where the user can not share an empty note to someone else we have to handle this exception with dialouge

import 'package:flutter/material.dart';
import 'package:hand_in_need/utilities/dialogs/generic_dialouge.dart';

Future<void> showCannotShareEmptyNoteDialouge(
  BuildContext context,
) {
  return showGenericDialouge(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
