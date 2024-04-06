import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/about/about_page.dart';
import 'package:flutter_android_tv_box/custom_widgets/focus_twinkling_border_button.dart';
import 'package:flutter_android_tv_box/games/games_page.dart';
import 'package:flutter_android_tv_box/settings/settings_page.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({super.key});

  @override
  State<MenuButton> createState() => _MenuButton();
}

class _MenuButton extends State<MenuButton> {

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.menu),
            tooltip: 'Show menu',
          );
        },
        menuChildren: [
          FocusTwinklingBorderContainer(
              child: buildMenuItemButton(
                  context: context,
                  text: 'Games',
                  icon: Icons.games,
                  page: const GamesPage())),
          FocusTwinklingBorderContainer(
              child: buildMenuItemButton(
                  context: context,
                  text: 'Settings',
                  icon: Icons.settings,
                  page: const SettingsPage())),
          FocusTwinklingBorderContainer(
              child: buildMenuItemButton(
                  context: context,
                  text: 'About',
                  icon: Icons.info,
                  page: const AboutPage())),
        ]);
  }
}

MenuItemButton buildMenuItemButton(
    {required BuildContext context,
    required String text,
    required IconData icon,
    required Widget page}) {
  return MenuItemButton(
    style: MenuItemButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(15, 25, 50, 25)),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.blue,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
  );
}
