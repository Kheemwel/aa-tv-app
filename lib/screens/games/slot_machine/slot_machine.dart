import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/network/send_data.dart';
import 'package:flutter_android_tv_box/widgets/focusable_elevated_button.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  List<String> items = ['I', 'M', 'U', 'S'];
  List<String> slots = List<String>.filled(4, '');
  List<bool> states = List<bool>.filled(4, false);
  final String answer = "IMUS";
  final List<CarouselController> controllers =
      List.generate(4, (index) => CarouselController());
  late List<List<String>> slotItems = [
    ['I', 'M', 'U', 'S'],
    ['M', 'U', 'S', 'I'],
    ['U', 'S', 'I', 'M'],
    ['S', 'I', 'M', 'U'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSlot(0),
            const SizedBox(
              width: 5,
            ),
            _buildSlot(1),
            const SizedBox(
              width: 5,
            ),
            _buildSlot(2),
            const SizedBox(
              width: 5,
            ),
            _buildSlot(3),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        buildFocusableElevatedButton(
            autofocus: true,
            onPressed: () async {
              rollSlot(10, 0);
              rollSlot(20, 1);
              rollSlot(30, 2);
              rollSlot(40, 3);
            },
            text: 'ROLL')
      ],
    );
  }

  void rollSlot(int duration, int index) async {
    for (var i = 0; i < duration; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      controllers[index]
          .previousPage(duration: const Duration(milliseconds: 100));
    }
    setState(() {
      states[index] = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (allTrue(states)) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text(slots.join() == answer ? 'You Win' : 'You Lose'),
          ),
        ),
      );

      setState(() {
        states = List.filled(4, false);
      });

      if (slots.join() == answer) {
        SendData.sendGameResult(
            gameName: 'Slot Machine',
            description: "They win by successfully getting 'IMUS' combination");
      }
    }
  }

  bool allTrue(List<bool> bools) {
    // Check if every element is true
    return bools.every((element) => element == true);
  }

  Widget _buildSlot(int index) {
    final CarouselController controller = controllers[index];
    final itemList = slotItems[index];
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
              scrollPhysics: const NeverScrollableScrollPhysics(),
              viewportFraction: 0.4,
              height: 200,
              scrollDirection: Axis.vertical,
              onPageChanged: (page, reason) {
                setState(() {
                  slots[index] = itemList[page];
                });
              },
            ),
            items: itemList
                .map((item) => Container(
                      color: Palette.getColor('primary'),
                      child: Center(child: Text(item)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
