import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_2/screens/Authentication_Screens/login.dart';
// import 'package:loginpage/wrapper.dart';
import 'package:get/get.dart';
import 'package:test_2/screens/Authentication_Screens/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signup() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: password.text);
    Get.offAll(Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: TextStyle(fontSize: 23, color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.w700)),
              centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Enter Password'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                signup();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, disabledForegroundColor: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.8).withOpacity(0.38), disabledBackgroundColor: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.8).withOpacity(0.12), // Disabled state color
              ),
            )
          ],
        ),
      ),
    );
  }
}
