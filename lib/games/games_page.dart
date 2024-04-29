import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/custom_widgets/pages_viewer.dart';
import 'package:flutter_android_tv_box/games/color_game/color_game_app.dart';
import 'package:flutter_android_tv_box/games/memory_card_game/memory_card_game_app.dart';
import 'package:flutter_android_tv_box/games/number_padlock/number_padlock_app.dart';
import 'package:flutter_android_tv_box/games/shuffle_cups/suffle_cups_app.dart';
import 'package:flutter_android_tv_box/games/slot_machine/slot_machine_app.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
        ),
        body: const PagesViewer(pages: [
          ShuffleCupsApp(),
          MemoryCardGameApp(),
          ColorGameApp(),
          NumberPadlockApp(),
          SlotMachineApp(),
        ]));
  }
}