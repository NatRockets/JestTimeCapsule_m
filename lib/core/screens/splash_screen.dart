import 'package:flutter/material.dart';

import '../app_config.dart';
import '../services/sdk_initializer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await SdkInitializer.initAll(context);
    // await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => const MainScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.width;
    final logoSize = screenHeight * 0.8; // Адаптивный размер логотипа

    return Scaffold(
      body: Container(
        decoration: AppConfig
            .splashDecoration, // const BoxDecoration(gradient: AppConfig.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    AppConfig.logoPath,
                    height: logoSize,
                    width: logoSize,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Color.fromARGB(251, 248, 134, 59),
                      strokeWidth: 5,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'LOADING',
                      style: TextStyle(
                        color: Color.fromARGB(251, 248, 134, 59),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
