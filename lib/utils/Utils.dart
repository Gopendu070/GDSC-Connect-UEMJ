// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils {
  static final double maxPhWidth = 390; //max width of phone
  static final double maxPhHeight = 810; //max height of phone

  static int imgCount = 0;
  static String defaultUserLogo =
      "https://firebasestorage.googleapis.com/v0/b/gdsc-uemj-8efa4.appspot.com/o/userLogo.png?alt=media&token=62a98bc4-092e-44a6-9282-29c371a01a95";
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static late String? userName;
  static late String? firstName;
  static late String? lastName;
  static late String? userImgUrl;

  static void setUserName(String? uName) {
    // Extract the first name from the full display name
    String? fullName = uName;
    userName = fullName;
    List<String> nameParts = fullName?.split(" ") ?? [];
    firstName = nameParts.isNotEmpty ? nameParts[0] : "";
    lastName = nameParts.length > 1 ? nameParts.last : "";
  }

  static var labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Color.fromARGB(189, 42, 26, 53));
  static var waterMark = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w900,
      color: Color.fromARGB(64, 136, 134, 134));

  static var dtStyle = TextStyle(
      fontSize: 13,
      color: Color.fromARGB(236, 39, 110, 168),
      fontWeight: FontWeight.w400);

  static var style1 = TextStyle(
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(204, 69, 68, 68),
      fontSize: 21);
  static var style2 = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey[700]);
  static var style3 = TextStyle(color: Color.fromARGB(255, 67, 47, 243));

  static var style4 = TextStyle(
      color: Color.fromARGB(214, 66, 66, 66),
      fontSize: 16,
      fontWeight: FontWeight.w600);
}
