import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/screens/games/memory_card_game/model.dart';
import 'package:flutter_android_tv_box/widgets/focusable_elevated_button.dart';
import 'package:flutter_android_tv_box/widgets/remote_controller.dart';

class MemoryCardGame extends StatefulWidget {
  /// Memory card game screen
  const MemoryCardGame({super.key});

  @override
  State<MemoryCardGame> createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  int time = 0;
  late Timer timer;
  List<String> items = multipliedCards();
  List<int> matchCards = [];
  List<int> selectedCards = [];
  late List<MemoryCard> cards = List.generate(
    items.length,
    (index) => MemoryCard(
      content: items[index],
    ),
  );

  @override
  void initState() {
    super.initState();
    timer = loadTimer();
  }

  Timer loadTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        time = timer.tick;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text('Duration:'),
                Text('$time'),
              ],
            ),
            const SizedBox(
              width: 100,
            ),
            Column(
              children: [
                const Text('Items Matched:'),
                Text('${matchCards.length ~/ 2} / ${items.length ~/ 2}'),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: SizedBox(
            height: 400,
            width: 860,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 150,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  maxCrossAxisExtent: 100),
              itemCount: cards.length,
              itemBuilder: (context, index) => buildRemoteController(
                onClick: () {
                  if (selectedCards.length < 2 &&
                      !selectedCards.contains(index) &&
                      !matchCards.contains(index)) {
                    selectCard(index);
                  }
                },
                child: GestureDetector(
                    onTap: () => selectedCards.length == 2 ||
                            selectedCards.contains(index) ||
                            matchCards.contains(index)
                        ? null
                        : selectCard(index),
                    child: cards[index]),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        buildFocusableElevatedButton(
            autofocus: true,
            onPressed: () async {
              timer.cancel();
              time = 0;
              matchCards.clear();
              selectedCards.clear();
              items.shuffle();
              timer = loadTimer();

              await Future.forEach(cards, (card) => card.reset());

              cards = cards = List.generate(
                items.length,
                (index) => MemoryCard(
                  content: items[index],
                ),
              );
            },
            text: 'RESTART'),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void selectCard(int index) async {
    if (selectedCards.length != 2) {
      selectedCards.add(index);
      cards[index].flip();
    }

    if (selectedCards.length == 2) {
      if (items[selectedCards[0]] == items[selectedCards[1]]) {
        matchCards.add(selectedCards[0]);
        matchCards.add(selectedCards[1]);
      } else {
        await Future.delayed(Durations.extralong4);
        cards[selectedCards[0]].flip();
        cards[selectedCards[1]].flip();
      }

      await Future.delayed(Durations.extralong4);
      if (matchCards.length == items.length) {
        timer.cancel();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Text('You win the game in $time seconds'),
            ),
          ),
        );

        SendData.sendGameResult(
            gameName: 'Memory Card Game',
            description: 'They finish the game in $time seconds');
      } else {
        selectedCards.clear();
      }
    }
  }
}
