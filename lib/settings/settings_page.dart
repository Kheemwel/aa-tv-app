import 'package:flutter/material.dart';

const List<String> list = <String>['Low', 'Medium', 'High'];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  static String dropdownValue = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          children: [
            ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.grey,
              textColor: Colors.white,
              title: const Text(
                'Auto Delete Notifications',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'Delete notifications that are older than 30 days',
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
              ),
              trailing: Switch(value: true, onChanged: (bool value) {}),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.transparent,
              textColor: Colors.white,
              title: const Text(
                'Auto Play Videos',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Switch(value: false, onChanged: (bool value) {}),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.transparent,
              textColor: Colors.white,
              title: const Text(
                'Video Resolution',
                style: TextStyle(fontSize: 20),
              ),
              trailing: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
