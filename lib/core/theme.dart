import 'package:flutter/material.dart';

final Map<String, dynamic> palette = {
  'primary': Colors.blue,
  'secondary': Colors.green[900],
  'tertiary': Colors.green[800],
  'primary-background': Colors.grey[900],
  'secondary-background': Colors.grey[800],
  'text-dark': Colors.grey[300],
};

AppBarTheme appBarTheme = AppBarTheme(
    titleSpacing: 50,
    iconTheme: const IconThemeData(color: Colors.blue),
    titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
    backgroundColor: Colors.grey[900]);

TabBarTheme tabBarTheme = TabBarTheme(
  dividerColor: Colors.transparent,
  dividerHeight: 0,
  indicator: BoxDecoration(
      color: Colors.green[900],
      borderRadius: const BorderRadius.all(Radius.circular(10))),
  labelPadding: EdgeInsets.zero, // remove default padding in tabs
  labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
  unselectedLabelColor: Colors.white,
  overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.focused)) {
      return Color(Colors.green[800]!.value); // Change background color when focused
    }
    return Colors.transparent;
  }),
);

MenuThemeData menuThemeData = MenuThemeData(
    style: MenuStyle(
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.grey[800])));

DialogTheme dialogTheme = DialogTheme(
    contentTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.grey[800]);

DrawerThemeData drawerThemeData = DrawerThemeData(
    backgroundColor: Colors.grey[800], surfaceTintColor: Colors.transparent);

ThemeData themeData = ThemeData(
  canvasColor: Colors.grey[800],
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
  ),
  appBarTheme: appBarTheme,
  scaffoldBackgroundColor: Colors.grey[900],
  tabBarTheme: tabBarTheme,
  menuTheme: menuThemeData,
  dialogTheme: dialogTheme,
  drawerTheme: drawerThemeData,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);
