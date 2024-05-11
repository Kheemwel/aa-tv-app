import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ElevatedButton buildFocusableElevatedButton({
    required VoidCallback onPressed,
    required String text,
    bool autofocus = false,
  }) {
    return ElevatedButton(
      autofocus: autofocus,
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
          if (states.contains(MaterialState.focused)) {
            return BorderSide(
              color:
                  Color(Colors.green[800]!.value), // Border color when focused
              width: 3.0, // Border width
            );
          }
          return BorderSide.none; // No border when not focused
        }),
      ),
      child: Text(text),
    );
  }