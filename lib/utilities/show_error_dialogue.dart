// this is where in our login if something goes wrong we will display an alert to the user when trying to login or signup if an exception has occured

// Create our showdialogoue function for our firebase auth expections and generic
// no expecting to return anything just showing dialogue why void needed
// purpose create dialogue and display it
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      // return alert dialouge which is the widget that is to be returned
      // explicitly going to be used for displaying errors to the users
      return AlertDialog(
        title: const Center(child: Text('An error occured')),
        // Where our text parameeter be passed in the alert message for the contents of it
        content: Text(text),

        actions: [
          TextButton(
            // when press specify popup on what type of error
            onPressed: () {
              // ensures that your dialouge gets dismissed
              // pop has limitations better to use overlays
              // will have to keep note and implement later
              Navigator.of(context).pop();
            },
            child: const Center(child: Text('OK')),
          ),
        ],
      );
    },
  );
}
