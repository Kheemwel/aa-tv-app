import 'dart:math';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ColorCube extends StatefulWidget {
  ColorCube(
      {super.key,
      required this.colors,
      this.width = 100,
      this.height = 100,
      this.onEnd});

  final List<Color> colors;
  final double width;
  final double height;
  late Color selectedColor;
  late Function() start;
  final Function()? onEnd;

  @override
  State<ColorCube> createState() => _ColorCubeState();
}

class _ColorCubeState extends State<ColorCube>
    with SingleTickerProviderStateMixin {
  Random random = Random();
  late Color currentColor;
  static const Duration _duration = Duration(seconds: 5);
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    widget.selectedColor = widget.colors[0];
    currentColor = widget.colors[0];
    controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    controller.addListener(() {
      setState(() {
        startColorChanging();
      });
    });

    widget.start = () {
      controller.reset();
      controller.forward();
    };
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void startColorChanging() {
    currentColor = widget.colors[random.nextInt(widget.colors.length)];
    if (controller.status == AnimationStatus.completed) {
      widget.selectedColor = currentColor;
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        color: currentColor,
      ),
    );
  }
}
