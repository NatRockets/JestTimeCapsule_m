import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppConfig {
  //========================= App Serrings =========================//

  static const String appsFlyerDevKey = 'S6umKKJvEb5Rqs4nWYevUi';
  static const String appsFlyerAppId = '6758330387'; // Для iOS'
  static const String bundleId = 'com.forsi.gmar'; // Для iOS'
  static const String locale = 'en'; // Для iOS'
  static const String os = 'iOS'; // Для iOS'
  static const String endpoint = 'https://jesttime-capsule.com'; // Для iOS'

  static const String logoPath = 'assets/images/Image.webp';
  static const String pushRequestLogoPath = 'assets/images/Image.webp';

  static const String pushRequestBackgroundPath =
      'assets/images/Background.webp';
  static const String splashBackgroundPath = 'assets/images/Background.webp';
  static const String errorBackgroundPath = 'assets/images/Background.webp';

  //========================= UI Settings =========================//

  //========================= Splash Screen ====================//
  static const Decoration splashDecoration = const BoxDecoration(
    //закоментировать если не нужен фон из изображения
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(255, 202, 95, 60), Color(0xFF23003C)],
    ),
  );

  static const Color loadingTextColor = Color(0xFFFFFFFF);
  static const Color spinerColor = Color(0xFCFFFFFF);

  //========================= Push Request Screen ====================//

  static const Decoration pushRequestDecoration = const BoxDecoration(
    //закоментировать если не нужен градиент
    image: DecorationImage(
      image: AssetImage(AppConfig.pushRequestBackgroundPath),
      fit: BoxFit.cover,
    ),

    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
    ),
  );

  static const Gradient pushRequestFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(0, 4, 2, 14),
      //Color.fromARGB(200, 0, 0, 0),
      Color.fromARGB(255, 4, 2, 14),
    ],
  );
  static const Color titleTextColor = Color(0xFFFFFFFF);
  static const Color subtitleTextColor = Color(0x80FDFDFD);

  static const Color yesButtonColor = Color.fromARGB(255, 216, 80, 22);
  static const Color yesButtonShadowColor = Color(0xFF8B3619);
  static const Color yesButtonTextColor = Color(0xFFFFFFFF);
  static const Color skipTextColor = Color(0x7DF9F9F9);

  //========================= Error Screen ====================//
  static const Decoration errorScreenDecoration = const BoxDecoration(
    //закоментировать если не нужен фон из изображения
    image: DecorationImage(
      image: AssetImage(AppConfig.errorBackgroundPath),
      fit: BoxFit.cover,
    ),
  );

  static const Color errorScreenTextColor = Color(0xFFFFFFFF);
  static const Color errorScreenIconColor = Color(0xFCFFFFFF);
}
