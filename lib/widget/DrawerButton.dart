import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/Secret.dart';
import 'package:gdscuemj/screen/AddSpeakerForm.dart';
import 'package:gdscuemj/screen/EntryForm.dart';
import 'package:gdscuemj/screen/LoginScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InDrawerButton extends StatelessWidget {
  DatabaseReference dbRef;
  String title;
  IconData icon;
  InDrawerButton(
      {super.key,
      required this.dbRef,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    //log out function
    void logoutFunction() async {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: "Logged out securely",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    void logoutConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 150,
              child: Text(
                "Are you sure you want to Logout?",
                style: Utils.style2
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    logoutFunction();
                  },
                  child: Text("Logout")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        },
      );
    }

    void chooseAction() {
      Secret secret = new Secret();
      switch (title) {
        case "Add Event":
          {
            late String eventID;
            eventID = DateTime.now().microsecondsSinceEpoch.toString();
            print(eventID);

            secret.showPwDialog(context, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EntryForm(
                            dbRef: dbRef,
                            eventID: eventID,
                            imgCount: 0,
                          )));
            });
          }
          break;
        case "Add Speaker":
          {
            final speakerDbRef = FirebaseDatabase.instance.ref('gdscSpeakerDB');
            final String speakerID =
                DateTime.now().millisecondsSinceEpoch.toString();
            secret.showPwDialog(context, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSpeakerForm(
                            speakerID: speakerID,
                            speakerDbRef: speakerDbRef,
                          )));
            });
          }
          break;
        case "Logout":
          {
            print("Logged Out");
            logoutConfirmationDialog(context);
          }
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(children: [
        OutlinedButton(
          onPressed: () {
            chooseAction();
          },
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: title == 'Logout'
                      ? Color.fromARGB(154, 214, 72, 72)
                      : Color.fromARGB(182, 148, 110, 160))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: title == "Logout"
                    ? const Color.fromARGB(255, 223, 61, 61)
                    : null,
              ),
              SizedBox(width: 3),
              Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: title == "Logout"
                        ? Color.fromARGB(255, 223, 61, 61)
                        : null),
              )
            ],
          ),
        ),
        if (title == "Add Event" || title == "Add Speaker")
          Positioned(
              right: 1,
              child: Icon(
                Icons.lock,
                color: Color.fromARGB(213, 77, 44, 83),
              ))
      ]),
    );
  }
}
