import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FireBaseControlls {
//////////////////////////////////////////////////////// ADD /////////////////////////////////////////////////////////////////////////
  static Future<void> addEvent(
      {required DatabaseReference dbRef,
      required String eventID,
      required String name,
      required String org,
      required String description,
      required String venue,
      required DateTime selectedTime,
      required DateTime selectedDT}) async {
    try {
      await dbRef.child(eventID.toString()).set({
        "id": eventID,
        "name": name.toString(),
        "organizer": org.toString(),
        "description": description.toString(),
        "venue": venue.toString(),
        "date_time": DateFormat('h:mm a').format(selectedTime).toString() +
            ' ' +
            DateFormat('d MMM, yyyy').format(selectedDT).toString(),
      });
      Fluttertoast.showToast(
        msg: "Event Scehduled",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } on FirebaseException catch (err) {
      print("Error:" + err.message.toString());
      Fluttertoast.showToast(
          msg: "Sorry, Access Denied",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
      // Navigator.pop(context);
    }
  }

  //////////////////////////////////////////////////////// UPDATE /////////////////////////////////////////////////////////////////////
  static Future<void> updateEvent(
      {required BuildContext context,
      required DatabaseReference dbRef,
      required String eventID,
      required String name,
      required String org,
      required String description,
      required String venue,
      required String dateTime,
      required String selectedTime,
      required DateTime selectedDT}) async {
    String dateTimeNew;
    if (selectedTime == "") {
      dateTimeNew = dateTime;
    } else {
      dateTimeNew = selectedTime +
          " " +
          DateFormat('d MMM, yyyy').format(selectedDT).toString();
    }

    try {
      await dbRef.child(eventID.toString()).update({
        "name": name,
        "organizer": org,
        "description": description,
        "venue": venue,
        "date_time": dateTimeNew,
      });
      Fluttertoast.showToast(
        msg: "Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } on FirebaseException catch (err) {
      print("Error:" + err.message.toString());
      Fluttertoast.showToast(
          msg: "Sorry, Access Denied",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
    } finally {
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

//////////////////////////////////////////////////////////// DELETE ///////////////////////////////////////////////////////////////////////
  static deleteEvent({
    required BuildContext context,
    required DatabaseReference dbRef,
    required String ID,
  }) async {
    try {
      await dbRef.child(ID).remove();
      Fluttertoast.showToast(
          msg: 'Deleted',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } on FirebaseException catch (err) {
      print("Error:" + err.message.toString());
      Fluttertoast.showToast(
          msg: "Sorry, Access Denied",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }

    Navigator.pop(context);
  }

  ////////////////////////////////////////////////////// Upload speaker info to the firebase DB ///////////////////////////////////////////////
  static uploadSpeakerInfo(
      {required DatabaseReference speakerDbRef,
      required String speakerID,
      required String fname,
      required String lname,
      required String imgURL}) async {
    try {
      await speakerDbRef.child(speakerID).set({
        "id": speakerID,
        "fname": fname,
        "lname": lname,
        "imgUrl": imgURL,
      });
    } catch (err) {
      print("Error:" + err.toString());
      Fluttertoast.showToast(
          msg: "Sorry, Access Denied",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }
}
