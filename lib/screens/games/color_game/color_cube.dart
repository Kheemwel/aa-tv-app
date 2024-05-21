import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/color_game_model.dart';

/// Widget of color cube
// ignore: must_be_immutable
class ColorCube extends StatefulWidget {
  ColorCube({super.key, this.width = 100, this.height = 100, this.onEnd});

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
  late String currentFace = colorCubeFaces[0];

  @override
  void initState() {
    super.initState();
    widget.selectedColor = colorChoices[colorCubeColors[currentFace]!];
    widget.start = () async {
      for (var i = 0; i < random.nextInt(30) + 30; i++) {
        setState(() {
          currentFace = colorCubeFaces[random.nextInt(colorCubeFaces.length)];
        });
        await Future.delayed(Durations.short3);
      }
      setState(() {
        widget.selectedColor = colorChoices[colorCubeColors[currentFace]!];
      });
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      currentFace,
      width: 128,
      height: 128,
    );
  }
}
