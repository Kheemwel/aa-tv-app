import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/games/memory_card_game/model.dart';

class MemoryCardGame extends StatefulWidget {
  /// Memory card game screen
  const MemoryCardGame({super.key});

  @override
  State<MemoryCardGame> createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  int time = 0;
  late Timer timer;
  List<String> items = multipliedCards(multiplier: 1);
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('Duration:'),
                Text('$time'),
              ],
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
          height: 50,
        ),
        SizedBox(
          height: 350,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: List.generate(
              cards.length,
              (index) => GestureDetector(
                onTap: () => selectedCards.length == 2 ||
                        selectedCards.contains(index) ||
                        matchCards.contains(index)
                    ? null
                    : selectCard(index),
                child: cards[index],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        ElevatedButton(
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
            child: const Text('RESTART'))
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
      } else {
        selectedCards.clear();
      }
    }
  }
}
