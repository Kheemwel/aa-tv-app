import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/color_cube.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/color_game_model.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/fixed_sized_list.dart';
import 'package:flutter_android_tv_box/widgets/focusable_elevated_button.dart';

/// Main screen for color game
class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  late ColorCube colorCube;
  FixedSizeList<int> selectedColorIndexes = FixedSizeList(2);

  bool get isWin {
    return colorChoices[selectedColorIndexes.get(0)] ==
            colorCube.selectedColor ||
        colorChoices[selectedColorIndexes.get(1)] == colorCube.selectedColor;
  }

  @override
  void initState() {
    super.initState();
    colorCube = ColorCube(
      onEnd: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Text(isWin
                  ? 'You Win'
                  : 'You Lose'),
            ),
          ),
        );

        if (isWin) {
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
              children: List.generate(colorChoices.length,
                  (index) => _colorSelector(colorChoices[index], index)),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Visibility(
            visible: selectedColorIndexes.isFull,
            child: buildFocusableElevatedButton(
                onPressed: () => colorCube.start(), text: 'ROLL')),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _colorSelector(Color color, int index) {
    return OutlinedButton(
      onPressed: () => setState(() {
        selectedColorIndexes.add(index);
      }),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(100, 100)),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
        side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
          if (states.contains(MaterialState.focused)) {
            return BorderSide(
              color: Palette.getColor('tertiary'), // Border color when focused
              width: 3.0, // Border width
            );
          }
          return BorderSide(width: selectedColorIndexes.items.contains(index) ? 3 : 0.1);
        }),
      ),
      child: Text(
        selectedColorIndexes.items.contains(index) ? 'SELECTED' : '',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
