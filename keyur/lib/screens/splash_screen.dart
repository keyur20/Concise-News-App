import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_2/screens/Authentication_Screens/wrapper.dart';
import 'package:test_2/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3),() {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); // navigating to new screen of our application
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper())); // navigating to new screen of our application
     });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset('images/splash_pic.jpg',
            fit: BoxFit.cover,
             height: height * .35,
             
            ),
            SizedBox(height: height * 0.08,),
            Text('DailyInsight' , style: GoogleFonts.anton(fontSize: 18,letterSpacing: .8 , color: const Color.fromARGB(255, 0, 0, 0)),),
            SizedBox(height: height * 0.08,),
            SpinKitChasingDots(
              color: const Color.fromARGB(255, 0, 0, 0),
                size: 40,
            )

          ],
        ),
      ),
      
    );
  }
}