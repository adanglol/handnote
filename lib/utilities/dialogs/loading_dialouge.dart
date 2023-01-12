// where we will prompt user wait while app is loading and making API calls

// we need caller to display dialouge and dismiss this dialouge as well
// first we need typedef to do so

import 'package:flutter/material.dart';

typedef CloseDialogue = void Function();

// need function displays loading dialouge also returns back function caller can call to dismiss

CloseDialogue showLoadingDialouge({
  required BuildContext context,
  required String text,
}) {
  // first define dialouge how loading dialouge suppose to look like
  final dialog = AlertDialog(
    content: Column(
      // Column grab much space as needs we want take little as needs
      // we use MainAxisSize
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );
  // we want to display that dialouge
  showDialog(
    context: context,
    // barrier dismissal allows say if user taps outside dialouge either allow or not allow
    barrierDismissible: false,
    // adding cancel button in future for dialouge popup good UX
    //---------------
    // builder function
    builder: (context) => dialog,
  );
  // return function from our function
  // make function that can be invoked by others
  // it pops current view of Navigator
  // navigator cant know what it is popping like our loading dialouge
  // messing with the navigation stack  which is not good
  // time move to overlays

  return () => Navigator.of(context).pop();
}
