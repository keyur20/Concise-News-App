import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_2/theme_provider.dart';

class AdminPanel extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  void shareApp() {
    const String appLink = 'https://example.com/myapp';
    Share.share('Check out this cool app: $appLink');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareApp,
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(), // Line above
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Theme', style: TextStyle(fontSize: 16)),
                Obx(() => Switch(
                      value: themeController.isDarkTheme.value,
                      onChanged: (value) {
                        themeController.toggleTheme();
                      },
                    )),
              ],
            ),
          ),
          Divider(), // Line below
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        child: Icon(Icons.logout),
      ),
    );
  }
}