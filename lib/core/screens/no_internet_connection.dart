import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../app_config.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  static Future<bool> checkInternetConnection() async {
    try {
      // print('Check internet');
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      //    print('Check internet error false');
      return false;
    }
  }

  static void showIfNoInternet(BuildContext context) async {
    if (kDebugMode) {
      print('ShowIfNoInternet');
    }
    Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(
        builder: (context) => const NoInternetConnectionScreen(),
        fullscreenDialog: true,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: AppConfig.errorScreenDecoration),
          Container(
            decoration: BoxDecoration(
              gradient: AppConfig.pushRequestFadeGradient,
            ),
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(50),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: AppConfig.errorScreenIconColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'PLEASE, CHECK YOUR INTERNET CONNECTION AND RESTART',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.errorScreenTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
