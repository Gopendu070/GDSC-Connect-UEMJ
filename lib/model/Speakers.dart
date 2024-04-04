import 'package:firebase_database/firebase_database.dart';

class Speakers {
  String fName;
  String lName;
  String imgUrl;
  Speakers({required this.fName, required this.lName, required this.imgUrl});

  factory Speakers.fromJson(Map<String, dynamic> json) {
    return Speakers(
      fName: json['fName'] ?? 'x',
      lName: json['lName'] ?? 'xx',
      imgUrl: json['imgUrl'] ?? 'xxx',
    );
  }
  factory Speakers.fromSnapshot(DataSnapshot snapshot) {
    // Map<dynamic, dynamic>? json = snapshot.value as Map<dynamic, dynamic>?;

    return Speakers(
      fName: snapshot.child('fname').value.toString() ?? '',
      lName: snapshot.child('lname').value.toString() ?? '',
      imgUrl: snapshot.child('imgUrl').value.toString() ?? '',
    );
  }
}
