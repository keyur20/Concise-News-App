import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:loginpage/homepage.dart';
import 'package:test_2/screens/Authentication_Screens/login.dart';
import 'package:flutter/material.dart';

import 'package:test_2/screens/Authentication_Screens/wrapper.dart';


class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState() {
    sendverifylink();
    super.initState();
  }

  sendverifylink()async{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) => {
      Get.snackbar('Link sent', 'A link has been send to your email', margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM)
    }); 
  }

  reload()async{
    await FirebaseAuth.instance.currentUser!.reload().then((value) => {Get.offAll(Wrapper())});
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: 
            Text('Open your mail and click on the link sent to your email', textAlign: TextAlign.center,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reload,
        child: Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}