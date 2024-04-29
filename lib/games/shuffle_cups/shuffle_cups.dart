import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
              visible: doneShuffling && selectedCup >= 0,
              child: Text(
                selectedCup == ballIndex ? 'You Win' : 'Loser',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 50,),
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
          Visibility(
            visible: doneShuffling && selectedCup < 0,
            child: SizedBox(
              width: 450,
              height: 100,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      left: 32,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green,
                          size: 64,
                        ),
                        onPressed: () => _selectCup(0),
                      )),
                  Positioned(
                      left: 182,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green,
                          size: 64,
                        ),
                        onPressed: () => _selectCup(150),
                      )),
                  Positioned(
                      left: 332,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green,
                          size: 64,
                        ),
                        onPressed: () => _selectCup(300),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50,),
          ElevatedButton(
            onPressed: isShuffling ? null : _shuffle,
            child: const Text('SHUFFLE'),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  void _selectCup(double position) {
    setState(() {
      showBall = true;
      selectedCup = positions.indexOf(position);
    });
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
