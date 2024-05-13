import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/color_cube.dart';

class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
  ];

  int selectedIndex = -1;

  late ColorCube colorCube;

  @override
  void initState() {
    super.initState();
    colorCube = ColorCube(
      colors: colors,
      onEnd: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Text(colors[selectedIndex] == colorCube.selectedColor
                  ? 'You Win'
                  : 'You Lose'),
            ),
          ),
        );

        if (colors[selectedIndex] == colorCube.selectedColor) {
          SendData.sendGameResult(
              gameName: 'Color Game',
              description: 'They win by successfully getting the lucky color');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 25,
        ),
        colorCube,
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: SizedBox(
            height: 340,
            width: 500,
            child: GridView.count(
              padding: const EdgeInsets.all(10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(colors.length,
                  (index) => _colorSelector(colors[index], index)),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Visibility(
            visible: selectedIndex >= 0,
            child: ElevatedButton(
                onPressed: () => colorCube.start(), child: const Text('ROLL'))),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _colorSelector(Color color, int index) {
    return OutlinedButton(
      onPressed: () => setState(() {
        selectedIndex = index;
      }),
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(100, 100),
          backgroundColor: color,
          shape: const BeveledRectangleBorder(),
          side: BorderSide(width: selectedIndex == index ? 3 : 0.1)),
      child: Text(
        selectedIndex == index ? 'SELECTED' : '',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
