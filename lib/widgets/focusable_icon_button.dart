import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';

// ignore: non_constant_identifier_names
/// Create icon button with a border when focused
IconButton buildFocusableIconButton({
    required VoidCallback onPressed,
    required Icon icon,
    bool autofocus = false,
  }) {
    return IconButton(
      autofocus: autofocus,
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
          if (states.contains(MaterialState.focused)) {
            return BorderSide(
              color:
                  Palette.getColor('tertiary'), // Border color when focused
              width: 3.0, // Border width
            );
          }
          return BorderSide.none; // No border when not focused
        }),
      ),
      icon: icon,
    );
  }