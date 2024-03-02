import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  }

  //////////////////////////////////////////////////////// UPDATE /////////////////////////////////////////////////////////////////////
  static Future<void> updateEvent(
      {required DatabaseReference dbRef,
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

    await dbRef.child(eventID.toString()).update({
      "name": name,
      "organizer": org,
      "description": description,
      "venue": venue,
      "date_time": dateTimeNew,
    });
  }

//////////////////////////////////////////////////////////// DELETE ///////////////////////////////////////////////////////////////////////
  static deleteEvent({
    required BuildContext context,
    required DatabaseReference dbRef,
    required String ID,
  }) async {
    await dbRef.child(ID).remove();
    Fluttertoast.showToast(
        msg: 'Deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    Navigator.pop(context);
  }

  ////////////////////////////////////////////////////// Upload speaker info to the firebase DB ///////////////////////////////////////////////
  static uploadSpeakerInfo(
      {required DatabaseReference speakerDbRef,
      required String speakerID,
      required String fname,
      required String lname,
      required String imgURL}) async {
    await speakerDbRef.child(speakerID).set({
      "id": speakerID,
      "fname": fname,
      "lname": lname,
      "imgUrl": imgURL,
    });
  }
}
