import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  var isLoggingIn = false;
  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      //Logging In: show CircularProgressIndicator
      setState(() {
        isLoggingIn = true;
      });
      //Show Toast msg
      Fluttertoast.showToast(
          msg: "Logging in",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
      //
      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCred.user;
      var uName = user?.displayName;
      print("User Name:- ${uName}");
      Utils.setUserName(uName);
      //Getting user profile picture url
      Utils.userImgUrl = user?.photoURL;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print("Could not Login, Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(174, 232, 203, 237),
            Color.fromARGB(87, 235, 217, 233),
            Colors.white38
          ]),
        ),
        child: Stack(children: [
          Positioned(
              left: 10,
              top: 30,
              child: Image.asset(
                'lib/asset/image/GDSC_rmbg.png',
                height: 40,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: InkWell(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(40)),
                      child: !isLoggingIn
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login with Google",
                                  style:
                                      Utils.labelStyle.copyWith(fontSize: 20),
                                ),
                                SizedBox(width: 15),
                                Image.asset(
                                  'lib/asset/image/google.png',
                                  height: 30,
                                )
                              ],
                            )
                          : Center(child: CircularProgressIndicator())),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 15,
              child: LottieBuilder.asset(
                'lib/asset/image/LoginAnimation.json',
                height: 220,
              ))
        ]),
      ),
    );
  }
}
