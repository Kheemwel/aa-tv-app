import 'package:flutter/material.dart';

/// The list of assets of every color cube faces
List<String> colorCubeFaces = [
  'assets/color_cube-1-1.png',
  'assets/color_cube-1-2.png',
  'assets/color_cube-1-3.png',
  'assets/color_cube-1-4.png',
  'assets/color_cube-2-1.png',
  'assets/color_cube-2-2.png',
  'assets/color_cube-2-3.png',
  'assets/color_cube-2-4.png',
  'assets/color_cube-3-1.png',
  'assets/color_cube-3-2.png',
  'assets/color_cube-3-3.png',
  'assets/color_cube-3-4.png',
  'assets/color_cube-4-1.png',
  'assets/color_cube-4-2.png',
  'assets/color_cube-4-3.png',
  'assets/color_cube-4-4.png',
  'assets/color_cube-5-1.png',
  'assets/color_cube-5-2.png',
  'assets/color_cube-5-3.png',
  'assets/color_cube-5-4.png',
  'assets/color_cube-6-1.png',
  'assets/color_cube-6-2.png',
  'assets/color_cube-6-3.png',
  'assets/color_cube-6-4.png',
];

/// The list of color cubes color values
/// The key are the asset file path and the value is the index of the top color of the cube in the [colorChoices]
const Map<String, int> colorCubeColors = {
  'assets/color_cube-1-1.png': 0,
  'assets/color_cube-1-2.png': 0,
  'assets/color_cube-1-3.png': 0,
  'assets/color_cube-1-4.png': 0,
  'assets/color_cube-2-1.png': 3,
  'assets/color_cube-2-2.png': 3,
  'assets/color_cube-2-3.png': 3,
  'assets/color_cube-2-4.png': 3,
  'assets/color_cube-3-1.png': 1,
  'assets/color_cube-3-2.png': 1,
  'assets/color_cube-3-3.png': 1,
  'assets/color_cube-3-4.png': 1,
  'assets/color_cube-4-1.png': 5,
  'assets/color_cube-4-2.png': 5,
  'assets/color_cube-4-3.png': 5,
  'assets/color_cube-4-4.png': 5,
  'assets/color_cube-5-1.png': 2,
  'assets/color_cube-5-2.png': 2,
  'assets/color_cube-5-3.png': 2,
  'assets/color_cube-5-4.png': 2,
  'assets/color_cube-6-1.png': 4,
  'assets/color_cube-6-2.png': 4,
  'assets/color_cube-6-3.png': 4,
  'assets/color_cube-6-4.png': 4,
};

/// List of color choices to be selected
/// All this colors are present in the cube
const List<Color> colorChoices = [
  Color.fromRGBO(54, 197, 244, 1),
  Color.fromRGBO(157, 230, 78, 1),
  Color.fromRGBO(250, 110, 121, 1),
  Color.fromRGBO(154, 77, 118, 1),
  Color.fromRGBO(233, 133, 55, 1),
  Color.fromRGBO(56, 89, 179, 1),
];
