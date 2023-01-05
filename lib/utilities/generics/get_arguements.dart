import 'package:flutter/material.dart' show BuildContext, ModalRoute;

// 22:56:05
extension GetArgument on BuildContext {
  T? getArguement<T>() {
    // this refers current build context invoked
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      // if modal route not empty lets extract them
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    // other wise we can not do anything so return null
    return null;
  }
}
