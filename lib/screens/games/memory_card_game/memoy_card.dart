import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/screens/games/memory_card_game/memory_card_game_model.dart';

/// Widget for the memory card
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
