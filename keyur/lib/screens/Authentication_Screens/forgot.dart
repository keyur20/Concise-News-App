import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_2/screens/Authentication_Screens/login.dart';
import 'package:test_2/screens/Authentication_Screens/wrapper.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailController = TextEditingController();
  String emailErrorText = '';

  // Method to clear error message after a delay
  void clearErrorAfterDelay() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        emailErrorText = '';
      });
    });
  }

  reset() async {
    setState(() {
      emailErrorText = '';
    });

    // Validate email
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorText = 'Please enter your email';
      });
      clearErrorAfterDelay();
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      // Show success message
      Get.snackbar("Success", "Password reset email sent successfully");
    } catch (e) {
      print(e);
      // Show error message
      Get.snackbar("Error", "Failed to send password reset email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter Email',
                errorText: emailErrorText.isNotEmpty ? emailErrorText : null,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: reset,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Send Link", style: TextStyle(fontSize: 13, color: Colors.white)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
