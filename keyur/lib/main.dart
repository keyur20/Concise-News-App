import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_2/screens/splash_screen.dart';
import 'package:test_2/theme_provider.dart';
import 'package:test_2/theme_provider.dart'; // Import your theme controller

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ThemeController
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      title: 'Flutter Demo',
      theme: themeController.isDarkTheme.value ? ThemeData.dark() : ThemeData.light(),
      home: const SplashScreen(),
    ));
  }
}