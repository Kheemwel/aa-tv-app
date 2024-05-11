import 'dart:async';

import 'package:flutter/material.dart';

class CountDown {
  late Timer timer;
  int duration;
  late int time;
  VoidCallback? onFinished;
  void Function(int time)? onTick;

  CountDown({required this.duration, this.onFinished, this.onTick}) {
    restart();
  }

  void restart() {
    time = duration;
    timer = Timer.periodic(const Duration(seconds: 1), (count) async {
      time--;

      if (onTick != null) {
        onTick!(time);
      }

      if (time == 0) {
        cancel();
        if (onFinished != null) {
          onFinished!();
        }
      }
    });
  }

  void cancel() {
    timer.cancel();
  }
}
