import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv_box/widgets/pages_viewer.dart';
import 'package:flutter_android_tv_box/screens/games/color_game/color_game_app.dart';
import 'package:flutter_android_tv_box/screens/games/memory_card_game/memory_card_game_app.dart';
import 'package:flutter_android_tv_box/screens/games/number_padlock/number_padlock_app.dart';
import 'package:flutter_android_tv_box/screens/games/shuffle_cups/suffle_cups_app.dart';
import 'package:flutter_android_tv_box/screens/games/slot_machine/slot_machine_app.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Games'),
          ),
          body: const PagesViewer(pages: [
            ShuffleCupsApp(),
            MemoryCardGameApp(),
            ColorGameApp(),
            NumberPadlockApp(),
            SlotMachineApp(),
          ])),
    );
  }
}