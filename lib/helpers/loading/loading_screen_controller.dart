// where we will have our loading screen controlling
// two things to consider and need and are
// close loading screen
// update its content

import 'package:flutter/material.dart';

// // bool func whether can be close or not
// typedef CloseLoadingScreen = bool Function();
// // update function for loading screen also bool if we can update
// // also take in param text to update load screen
// typedef UpdateLoadingScreen = bool Function(String text);

// // Our controller class
// @immutable
// class LoadingScreenController {
//   final CloseLoadingScreen close;
//   final UpdateLoadingScreen update;
//   const LoadingScreenController({
//     required this.close,
//     required this.update,
//   });
// }

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
