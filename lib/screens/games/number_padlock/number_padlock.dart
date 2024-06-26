import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/screens/games/number_padlock/countdown_timer.dart';

class NumberPadlock extends StatefulWidget {
  const NumberPadlock({super.key});

  @override
  State<NumberPadlock> createState() => _NumberPadlockState();
}

class _NumberPadlockState extends State<NumberPadlock> {
  List<int> list = List.generate(10, (index) => index);
  List<int> locks = List<int>.filled(4, 0);
  final String answer = Random().nextInt(9999).toString().padLeft(4, '0');
  final List<CarouselController> controllers =
      List.generate(4, (index) => CarouselController());
  String input = "????";
  final int totalDuration = 60; // Total countdown duration
  late int timer = totalDuration;
  late CountDown countDown;

  @override
  void initState() {
    super.initState();

    countDown = CountDown(
        duration: timer,
        onTick: (time) => setState(() {
              timer = time;
              if (locks.join() == answer) {
                countDown.cancel();
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Text('You win the game in $timer seconds'),
                    ),
                  ),
                );
                SendData.sendGameResult(
                    gameName: 'Number Padlock',
                    description: 'They win the game in $timer seconds');
              }
            }),
        onFinished: () {
          if (locks.join() != answer) {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: const Text('Game Over'),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Countdown: ${timer.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: LinearProgressIndicator(
                value: timer / totalDuration,
                backgroundColor: Palette.getColor('text-dark'),
                color: Palette.getColor('tertiary'),
                minHeight: 15,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          'Password: $input',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLocks(0),
            const SizedBox(
              width: 10,
            ),
            _buildLocks(1),
            const SizedBox(
              width: 10,
            ),
            _buildLocks(2),
            const SizedBox(
              width: 10,
            ),
            _buildLocks(3),
          ],
        ),
      ],
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (locks[0].toString() == answer[0]) {
      input = replaceCharAtIndex(input, 0, answer[0]);
    } else {
      input = input = replaceCharAtIndex(input, 0, '?');
    }

    if (locks[1].toString() == answer[1]) {
      input = replaceCharAtIndex(input, 1, answer[1]);
    } else {
      input = input = replaceCharAtIndex(input, 1, '?');
    }

    if (locks[2].toString() == answer[2]) {
      input = replaceCharAtIndex(input, 2, answer[2]);
    } else {
      input = input = replaceCharAtIndex(input, 2, '?');
    }

    if (locks[3].toString() == answer[3]) {
      input = replaceCharAtIndex(input, 3, answer[3]);
    } else {
      input = input = replaceCharAtIndex(input, 3, '?');
    }
  }

  String replaceCharAtIndex(String str, int index, String newChar) {
    if (index < 0 || index >= str.length) {
      // Invalid index, return the original string
      return str;
    }

    // Replace the character at the specified index with the new character
    return str.substring(0, index) + newChar + str.substring(index + 1);
  }

  Widget _buildLocks(int index) {
    final CarouselController controller = controllers[index];
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              iconSize: 48,
              color: Colors.white,
              onPressed: controller.nextPage,
              icon: const Icon(Icons.arrow_drop_up)),
          const SizedBox(height: 20),
          CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
              enlargeCenterPage: true,
              viewportFraction: 0.3,
              height: 150,
              scrollDirection: Axis.vertical,
              onPageChanged: (page, reason) {
                setState(() {
                  locks[index] = page;
                });
              },
            ),
            items: list
                .map((item) => Container(
                      color: Palette.getColor('primary'),
                      child: Center(child: Text(item.toString())),
                    ))
                .toList(),
          ),
          IconButton(
              iconSize: 48,
              color: Colors.white,
              onPressed: controller.previousPage,
              icon: const Icon(Icons.arrow_drop_down)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    countDown.cancel();
  }
}
