// where we will have our dialouge displayed to the user that password reset has been sent to their email

import 'package:flutter/material.dart';
import 'package:hand_in_need/utilities/dialogs/generic_dialouge.dart';

Future<void> showPasswordResetSendDialouge(BuildContext context) {
  return showGenericDialouge(
    context: context,
    title: 'Password Reset',
    content:
        'An email has been sent to reset your password. Please check your email for more information',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
