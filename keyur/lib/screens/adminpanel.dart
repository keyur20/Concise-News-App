import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_2/theme_provider.dart';
import 'package:test_2/theme_provider.dart'; // Import your theme controller

class AdminPanel extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  signout()async{
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
  

  @override
  Widget build(BuildContext context) {
    // Retrieve the theme controller using Get.find
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              'Current theme: ${themeController.isDarkTheme.value ? 'Dark' : 'Light'}',
              style: TextStyle(fontSize: 24),
            )),
            SizedBox(height: 16),
            Obx(() => Switch(
              value: themeController.isDarkTheme.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: signout,
          child: Icon(Icons.login_rounded),
        ),
    );
  }
}