import 'package:flutter/material.dart';

class FocusTwinklingBorderContainer extends StatefulWidget {
  const FocusTwinklingBorderContainer(
      {super.key, this.autofocus = false, this.isContentCentered = true, required this.child});

  final Widget child;
  final bool autofocus;
  final bool isContentCentered;

  @override
  State<FocusTwinklingBorderContainer> createState() =>
      _FocusTwinklingBorderContainerState();
}

class _FocusTwinklingBorderContainerState
    extends State<FocusTwinklingBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    if (hasFocus) {
      _controller.repeat(reverse: true);
    } else {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: _handleFocusChange,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            alignment: widget.isContentCentered ? Alignment.center : null,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green.withOpacity(_animation.value),
                width: 3.0,
              ),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
