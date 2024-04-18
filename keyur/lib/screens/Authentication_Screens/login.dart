import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:loginpage/forgot.dart';
// import 'package:loginpage/signup.dart';
import 'package:test_2/screens/Authentication_Screens/forgot.dart';
import 'package:test_2/screens/Authentication_Screens/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isloading = false;

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
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Message", e.code);
    } catch (e) {
      Get.snackbar("Error Message", e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text("Login", style: TextStyle(fontSize: 23, color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.w700)),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TextField(
                    controller: email,
                    decoration: InputDecoration(hintText: 'Enter Email'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(hintText: 'Enter Password'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: signIn,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Login", style: TextStyle(fontSize: 13, color: Colors.white)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor, disabledForegroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.38), disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.12), // Color when button is pressed
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: login,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor, disabledForegroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.38), disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.8).withOpacity(0.12), // Color when button is pressed
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