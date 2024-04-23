import 'dart:async'; // Import async library
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_2/screens/Authentication_Screens/forgot.dart';
import 'package:test_2/screens/Authentication_Screens/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  login() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signIn() async {
    setState(() {
      isLoading = true;
    });
    emailErrorText = '';
    passwordErrorText = '';

    if (emailController.text.isEmpty) {
      emailErrorText = 'Please enter email';
    }
    if (passwordController.text.isEmpty) {
      passwordErrorText = 'Please enter password';
    }

    if (emailErrorText.isEmpty && passwordErrorText.isEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error Message", e.code);
      } catch (e) {
        Get.snackbar("Error Message", e.toString());
      }
    }

    setState(() {
      isLoading = false;
    });

    // Clear errors after a delay
    clearErrorsAfterDelay();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Login",
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
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7864AC), // Change the background color here
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7864AC), // Change the background color here
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 246, 246, 246)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          Get.to(Signup());
                        },
                        child: Text("Register now"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
