import 'package:flutter/material.dart';
import 'package:hand_in_need/utilities/dialogs/generic_dialouge.dart';

Future<bool> logoutDialouge(
  BuildContext context,
) {
  return showGenericDialouge<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      'Log out': true,
      'Cancel': false,
    },
    // some platforms dismiss dilougue withoug responding need guard and return default value
  ).then((value) => value ?? false);
}
