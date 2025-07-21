import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/screens/opening.dart'; // update to correct import

void main() {
  runApp(MyApp());
}

// Wrap everything in MaterialApp here
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Construction',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // show splash screen first
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => opening()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('/Users/jawadulhassan/Downloads/images-4.png')),
          ],
        )
      ),
    );
  }
}
