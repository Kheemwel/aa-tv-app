import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          canvasColor: Colors.grey[800],
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
              titleSpacing: 50,
              iconTheme: const IconThemeData(color: Colors.blue),
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 26),
              backgroundColor: Colors.grey[900]),
          scaffoldBackgroundColor: Colors.grey[900],
          tabBarTheme: TabBarTheme(
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicator: BoxDecoration(color: Colors.green[900], borderRadius: const BorderRadius.all(Radius.circular(10))),
            labelPadding: EdgeInsets.zero, // remove default padding in tabs
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            unselectedLabelColor: Colors.white,
          ),
          menuTheme: MenuThemeData(
              style: MenuStyle(
                  surfaceTintColor:
                      MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey[800]))),
          dialogTheme: DialogTheme(
              contentTextStyle:
                  const TextStyle(fontSize: 18, color: Colors.white),
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.grey[800]),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen());
  }
}
