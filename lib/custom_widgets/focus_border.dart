import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FocusBorder extends StatefulWidget {
  final Widget child;
  bool autofocus;

  FocusBorder({super.key, required this.child, this.autofocus = false});

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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasFocus ? Color(Colors.green[800]!.value) : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}