import 'dart:async';
import 'dart:convert';
import 'package:flutter_android_tv_box/custom_widgets/focus_twinkling_border_button.dart';
import 'package:flutter_android_tv_box/database/sqlite_notifications.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:http/http.dart' as http;

const String TOKEN = 'e94061b3-bc9f-489d-99ce-ef9e8c9058ce';

Future<http.Response> saveGameData(
    String userName, String prize, String dateTime) async {
  final response = await http.post(
      Uri.parse('https://properly-immune-cattle.ngrok-free.app/api/save-data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $TOKEN",
      },
      body: jsonEncode(<String, String>{
        'user_name': userName,
        'prize': prize,
        'date_time': dateTime,
      }));

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  return response;
}

String getCurrentDateTime() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDate;
}

final items = <String>[
  '5MB',
  '10MB',
  '15MB',
  '25MB',
  '30MB',
  '50MB',
  '100MB',
];

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
        ),
        body: const FortuneSpinWheel());
  }
}

class FortuneSpinWheel extends StatefulWidget {
  const FortuneSpinWheel({super.key});

  @override
  State<FortuneSpinWheel> createState() => _FortuneSpinWheelState();
}

class _FortuneSpinWheelState extends State<FortuneSpinWheel> {
  late SQLiteNotifications _sqLiteNotification;
  final StreamController<int> _selected = StreamController<int>();
  int _selectedIndex = 0;
  static String _selectedItem = '';

  @override
  void initState() {
    super.initState();
    _sqLiteNotification = SQLiteNotifications();
  }

  Future<void> _handleSpin() async {
    try {
      setState(() {
        _selectedIndex = Fortune.randomInt(0, items.length);
        _selected.add(_selectedIndex);
      });

      setState(() {
        _selectedItem = items[_selectedIndex];
      });

      String dateTime = getCurrentDateTime();
      var response = await saveGameData('Kim', _selectedItem, dateTime);
      _sqLiteNotification.insertNotification('Congratulations! 🥳',
          'You won $_selectedItem of internet speed.', dateTime);

      print('Game data saved successfully: ${response.body}');
    } catch (error) {
      print('Error saving game data: $error');
      // Handle error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 500,
            child: FortuneWheel(
              animateFirst: false,
              selected: _selected.stream,
              indicators: <FortuneIndicator>[
                FortuneIndicator(
                  alignment: Alignment
                      .topCenter, // <-- changing the position of the indicator
                  child: TriangleIndicator(
                    color: Color(Colors.green[900]!
                        .value), // <-- changing the color of the indicator
                    width: 40, // <-- changing the width of the indicator
                    height: 40, // <-- changing the height of the indicator
                    elevation: 0, // <-- changing the elevation of the indicator
                  ),
                ),
              ],
              items: [
                for (var it in items)
                  FortuneItem(
                      child: Text(
                    it,
                    style: const TextStyle(fontSize: 18),
                  )),
              ],
              onAnimationEnd: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text.rich(TextSpan(
                                  text: 'You win ',
                                  style: const TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: _selectedItem,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: ' of internet speed.',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ])),
                              const SizedBox(height: 15),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )));
                // print(saveGameData('Kim', _selectedItem, getCurrentDateTime()));
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // if (_selectedItem == '')
          if (true)
            FocusTwinklingBorderContainer(
              isContentCentered: false,
                autofocus: true,
                child: TextButton(
                  autofocus: true,
                  style: TextButton.styleFrom(
                      fixedSize: const Size(100, 25),
                      backgroundColor: Colors.blue),
                  onPressed: _handleSpin,
                  child: const Text(
                    'SPIN',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sqLiteNotification.dispose();
    super.dispose();
  }
}
