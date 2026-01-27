import 'package:flutter/cupertino.dart';
import '../screens/pack_screen.dart';
import '../screens/unpack_screen.dart';
import '../screens/advice_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/visual_effects_config.dart';

class MessageApp extends StatelessWidget {
  const MessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: VisualEffectsConfig.primaryGradientStart,
        brightness: Brightness.dark,
        barBackgroundColor: Color(0xFF1F2937),
      ),
      home: MainTabBar(),
    );
  }
}

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: const Color(0xFF1F2937),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            activeIcon: Icon(CupertinoIcons.cube_box_fill),
            label: 'Pack',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gift),
            activeIcon: Icon(CupertinoIcons.gift_fill),
            label: 'Unpack',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lightbulb),
            activeIcon: Icon(CupertinoIcons.lightbulb_fill),
            label: 'Wisdom',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            activeIcon: Icon(CupertinoIcons.settings_solid),
            label: 'Settings',
          ),
        ],
        activeColor: VisualEffectsConfig.primaryGradientEnd,
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return const PackScreen();
          case 1:
            return const UnpackScreen();
          case 2:
            return const AdviceScreen();
          case 3:
            return const SettingsScreen();
          default:
            return const PackScreen();
        }
      },
    );
  }
}
