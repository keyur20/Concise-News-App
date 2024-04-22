import 'dart:async'; // Import async library
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_2/screens/Authentication_Screens/forgot.dart';
import 'package:test_2/screens/Authentication_Screens/login.dart';
import 'package:test_2/screens/Authentication_Screens/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String emailErrorText = '';
  String passwordErrorText = '';

  // Method to clear error messages after a delay
  void clearErrorsAfterDelay() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        emailErrorText = '';
        passwordErrorText = '';
      });
    });
  }

  // Method to validate and process signup
  signup() async {
    setState(() {
      emailErrorText = '';
      passwordErrorText = '';
    });

    // Validate email
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorText = 'Please enter your email';
      });
      clearErrorsAfterDelay();
      return;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorText = 'Please enter your password';
      });
      clearErrorsAfterDelay();
      return;
    }

    try {
      // Attempt signup with Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAll(Wrapper());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          passwordErrorText = 'The password provided is too weak';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailErrorText = 'The email is already in use';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
            SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                errorText: passwordErrorText.isNotEmpty ? passwordErrorText : null,
                border: OutlineInputBorder(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signup,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7864AC), // Change the background color here
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.to(Forgot());
              },
              child: Text("Forgot Password?"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("If not registered, "),
                TextButton(
                  onPressed: () {
                    Get.to(Login());
                  },
                  child: Text("Login now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
