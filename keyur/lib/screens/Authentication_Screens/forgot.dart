import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_2/screens/Authentication_Screens/wrapper.dart';
import 'package:get/get.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  TextEditingController email = TextEditingController();

  reset()async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            ElevatedButton(
  onPressed: reset,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Text("Send link", style: TextStyle(fontSize: 13, color: Colors.white)),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor, disabledForegroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.38), disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.12), // Color when button is pressed
  ),
)
          ],
        ),
      ),
    );
  }
}