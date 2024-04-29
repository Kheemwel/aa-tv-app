import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  List<String> items = ['I', 'M', 'U', 'S'];
  List<String> slots = List<String>.filled(4, '');
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
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
        ElevatedButton(
            onPressed: () async {
              rollSlot(10, 0);
              rollSlot(20, 1);
              rollSlot(30, 2);
              rollSlot(40, 3);
            },
            child: const Text('ROLL'))
      ],
    );
  }

  void rollSlot(int duration, int index) async {
    for (var i = 0; i < duration; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      controllers[index].previousPage(duration: const Duration(milliseconds: 100));
    }
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
                      color: Colors.blue,
                      child: Center(child: Text(item)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
