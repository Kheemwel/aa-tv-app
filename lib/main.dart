import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/shared_preferences.dart';
import 'package:flutter_android_tv_box/screens/home/home_screen.dart';

/// Main entry of the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  SharedPref.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: themeData,
          home: const HomeScreen()),
    );
  }
}
