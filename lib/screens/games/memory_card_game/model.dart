import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

/// Image of the back part of the card
const String defaultCard = 'assets/memory card game - back.png';

/// List of all the images of the front part of cards
const List<String> cards = [
  'assets/memory card - diamond.png',
  'assets/memory card - flower.png',
  'assets/memory card - heart.png',
  'assets/memory card - hourglass.png',
];

/// Duplicate the cards for matching and shuffle it
List<String> multipliedCards() {
  const multi = 3;
  int multiplier = multi  * 2;
  List<String> multiCards = [];
  for (var card in cards) {
    for (var i = 0; i < multiplier; i++) {
      multiCards.add(card);
    }
  }

  return multiCards..shuffle();
}

// ignore: must_be_immutable
class MemoryCard extends StatefulWidget {
  /// Widget for the cards
  MemoryCard({
    super.key,
    required this.content,
  });

  final String content;
  final FlipCardController _controller = FlipCardController();
  bool isFlipped = false;

  @override
  State<MemoryCard> createState() => _MemoryCardState();

  void flip() {
    _controller.toggleCard();
  }

  void reset() {
    if (isFlipped) {
      _controller.toggleCard();
    }
  }
}

class _MemoryCardState extends State<MemoryCard> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      descendantsAreFocusable: false,
      onFocusChange:(value) => setState(() {
        isFocused = value;
      }),
      child: FlipCard(
        controller: widget._controller,
        flipOnTouch: false,
        front: Image.asset(defaultCard, scale: isFocused ? 0.5 : 1,),
        back: Image.asset(widget.content, scale: isFocused ? 0.5 : 1,),
        onFlipDone: (isFront) => widget.isFlipped = isFront,
      ),
    );
  }
}
