/// Anything related to themes defined here
library;

import 'package:flutter/material.dart';

/// Utility class for the app palette
class Palette {
  /// Selected colors for the app
  static final Map<String, Color?> _palette = {
    'primary': Colors.blue,
    'secondary': Colors.green[900],
    'tertiary': Colors.green[800],
    'primary-background': Colors.grey[900],
    'secondary-background': Colors.grey[800],
    'text-dark': Colors.grey[300],
  };

  /// Convert Color? to Color
  static Color _toColor(Color? color) {
    return Color(color!.value);
  }

  /// Get the color from palette
  static Color getColor(String name) {
    return _toColor(_palette[name]);
  }
}

final AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    titleSpacing: 50,
    iconTheme: IconThemeData(color: Palette.getColor('primary')),
    titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
    backgroundColor: Palette.getColor('primary-background'));

final TabBarTheme tabBarTheme = TabBarTheme(
  dividerColor: Colors.transparent,
  dividerHeight: 0,
  indicator: BoxDecoration(
      color: Palette.getColor('secondary'),
      borderRadius: const BorderRadius.all(Radius.circular(10))),
  labelPadding: EdgeInsets.zero, // remove default padding in tabs
  labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
  unselectedLabelColor: Colors.white,
  overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.focused)) {
      return Palette.getColor(
          'tertiary'); // Change background color when focused
    }
    return Colors.transparent;
  }),
);

final MenuThemeData menuThemeData = MenuThemeData(
    style: MenuStyle(
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(
            Palette.getColor('secondary-background'))));

final DialogTheme dialogTheme = DialogTheme(
    contentTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
    surfaceTintColor: Colors.transparent,
    backgroundColor: Palette.getColor('secondary-background'));

final DrawerThemeData drawerThemeData = DrawerThemeData(
    backgroundColor: Palette.getColor('secondary-background'),
    surfaceTintColor: Colors.transparent);

final ThemeData themeData = ThemeData(
  canvasColor: Palette.getColor('secondary-background'),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
  ),
  appBarTheme: appBarTheme,
  scaffoldBackgroundColor: Palette.getColor('primary-background'),
  tabBarTheme: tabBarTheme,
  menuTheme: menuThemeData,
  dialogTheme: dialogTheme,
  drawerTheme: drawerThemeData,
  colorScheme: ColorScheme.fromSeed(seedColor: Palette.getColor('primary')),
  useMaterial3: true,
);
