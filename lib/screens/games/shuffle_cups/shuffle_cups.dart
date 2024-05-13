import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/widgets/focusable_elevated_button.dart';
import 'package:flutter_android_tv_box/widgets/focusable_icon_button.dart';

class ShuffleCups extends StatefulWidget {
  const ShuffleCups({super.key});

  @override
  State<ShuffleCups> createState() => _ShuffleCupsState();
}

class _ShuffleCupsState extends State<ShuffleCups> {
  int ballIndex = 1;
  List<double> positions = [0, 150, 300];
  bool showBall = false;
  int selectedCup = -1;
  bool doneShuffling = false;
  bool isShuffling = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 450,
          height: 260,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: List.generate(
                positions.length,
                (index) => _cup(positions[index], showBall,
                    selectedCup == index, index == ballIndex)),
          ),
        ),
        const SizedBox(height: 25),
        Visibility(
          visible: doneShuffling && selectedCup < 0,
          child: SizedBox(
            width: 450,
            height: 64,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                    left: 32,
                    child: buildFocusableIconButton(
                      icon: const Icon(
                        Icons.arrow_circle_up,
                        color: Colors.green,
                        size: 48,
                      ),
                      onPressed: () => _selectCup(0),
                    )),
                Positioned(
                    left: 182,
                    child: buildFocusableIconButton(
                      autofocus: true,
                      icon: const Icon(
                        Icons.arrow_circle_up,
                        color: Colors.green,
                        size: 48,
                      ),
                      onPressed: () => _selectCup(150),
                    )),
                Positioned(
                    left: 332,
                    child: buildFocusableIconButton(
                        onPressed: () => _selectCup(300),
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green,
                          size: 48,
                        )))
              ],
            ),
          ),
        ),
        Visibility(
          visible: !isShuffling && !(doneShuffling && selectedCup < 0),
          child: buildFocusableElevatedButton(
            autofocus: true,
            onPressed: _shuffle,
            text: 'SHUFFLE',
          ),
        ),
      ],
    );
  }

  void _selectCup(double position) {
    setState(() {
      showBall = true;
      selectedCup = positions.indexOf(position);
    });

    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  selectedCup == ballIndex ? 'You Win' : 'You Lose',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ));
            
    if (selectedCup == ballIndex) {
      SendData.sendGameResult(
          gameName: 'ShuffleCups',
          description: "They win by successfully finding the ball");
    }
  }

  void _shuffle() async {
    setState(() {
      doneShuffling = false;
      isShuffling = true;
      selectedCup = -1;
      showBall = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      showBall = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    for (var i = 0; i < 20; i++) {
      setState(() {
        positions = shuffleUnique(positions);
      });
      await Future.delayed(Duration(milliseconds: 500 - (20 * i)));
    }

    setState(() {
      doneShuffling = true;
      isShuffling = false;
    });
  }

  Widget _cup(double position, bool showBall, bool isSelected, bool hasBall) {
    return AnimatedPositioned(
      left: position,
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        width: 128,
        height: 260,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            hasBall ? Image.asset('assets/green_ball.png') : const SizedBox(),
            AnimatedPositioned(
                bottom: (showBall && hasBall) || isSelected ? 100 : 0,
                duration: const Duration(milliseconds: 250),
                child: Image.asset('assets/blue_cup_down.png'))
          ],
        ),
      ),
    );
  }

  List<T> shuffleUnique<T>(List<T> list) {
    // Create a copy to avoid modifying the original list
    final shuffledList = List<T>.from(list);

    shuffledList.shuffle();
    while (listEquals(shuffledList, list)) {
      shuffledList.shuffle();
    }

    return shuffledList;
  }
}
