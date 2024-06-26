import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';

/// Create a container with a border when focused
// ignore: must_be_immutable
class FocusBorder extends StatefulWidget {
  final Widget child;
  bool autofocus;
  bool isContentCentered;

  FocusBorder({super.key, required this.child, this.autofocus = false, this.isContentCentered = true});

  @override
  State<FocusBorder> createState() => _FocusBorderState();
}

class _FocusBorderState extends State<FocusBorder> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Container(
        alignment: widget.isContentCentered ? Alignment.center : null,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasFocus ? Palette.getColor('tertiary') : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}