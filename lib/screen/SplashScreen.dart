import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/utils/Utils.dart';

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
    Timer(Duration(seconds: 1), () {
      animate();
    });
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  double Height = 50;
  double Width = 70;
  void animate() {
    if (Height == 50 && Width == 70) {
      setState(() {
        Height = 100;
        Width = 140;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                duration: Duration(seconds: 2),
                height: Height,
                width: Width,
                child: Image.asset(
                  'lib/asset/image/GDSC_rmbg.png',
                  fit: BoxFit.fitWidth,
                )),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
