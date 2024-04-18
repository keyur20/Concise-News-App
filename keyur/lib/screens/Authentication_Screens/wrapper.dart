
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:loginpage/homepage.dart';
import 'package:test_2/screens/Authentication_Screens/login.dart';
import 'package:test_2/screens/Authentication_Screens/verify.dart';
import 'package:test_2/screens/home_screen.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if(snapshot.data!.emailVerified){
              return HomeScreen();
            }
            else{
              return Verify();
            }
          }
          else{
            return Login();
          }

        }), // StreamBuilder
    ); 
  }
}