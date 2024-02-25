import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/screen/LoginScreen.dart';
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
    checkLoginAndNavigate();
    //If logge id previously then directly go to HomePage
  }

  void checkLoginAndNavigate() async {
    //If logged in previously then directly go to HomePage
    if (await checkLogInStatus()) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    }
    //If not logged in previously then  go to Login screen
    else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

  Future<bool> checkLogInStatus() async {
    if (await isLoggedIn()) {
      //If logged in then go to HomePage
      return true;
    } else {
      return false;
    }
  }

  //Is user logged in?
  Future<bool> isLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    //Seting User name

    String? userName = user?.displayName;
    Utils.userImgUrl = user?.photoURL;
    Utils.setUserName(userName);
    return user != null;
  }

  double Height = 50;
  double Width = 70;
  void animate() {
    if (Height == 50 && Width == 70) {
      setState(() {
        Height = 90;
        Width = 130;
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
