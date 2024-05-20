import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildRemoteController(
    {void Function(bool value)? onFocusChange, required VoidCallback onClick, required Widget child}) {
  return Focus(
    canRequestFocus: false,
    onFocusChange: (value) {
      if (onFocusChange != null) {
        onFocusChange(value);
      }
    },
    onKeyEvent: (node, event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.select ||
            event.logicalKey == LogicalKeyboardKey.enter) {
          onClick();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    },
    child: child,
  );
}
