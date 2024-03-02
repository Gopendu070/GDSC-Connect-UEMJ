import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FireBaseControlls.dart';
import 'package:gdscuemj/controller/Secret.dart';
import 'package:gdscuemj/screen/EventDetails.dart';
import 'package:gdscuemj/screen/UpdateForm.dart';
import 'package:intl/intl.dart';

import '../utils/Utils.dart';

class EventTiles extends StatelessWidget {
  String name;
  String ID;
  String venue;
  String description;
  String organizer;
  String dateTime;
  String imageUrl;
  DatabaseReference dbRef;
  EventTiles(
      {required this.name,
      required this.dbRef,
      required this.ID,
      required this.dateTime,
      required this.venue,
      required this.description,
      required this.organizer,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    BuildContext currentContext = context;
    var HEIGHT = MediaQuery.of(context).size.height;
    var WIDTH = MediaQuery.of(context).size.width;
    double h = 400;
    double w = WIDTH * 0.86;
    Secret secret = new Secret();
    return InkWell(
      onLongPress: () {
        Fluttertoast.showToast(
            msg: "Only Admins Can Edit",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
        showMyDialog(context);
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                  ID: ID,
                  title: name,
                  description: description,
                  imageUrl: imageUrl,
                  date_time: dateTime,
                  organiser: organizer,
                  venue: venue),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SizedBox(
          height: h,
          width: w + 10,
          child: Stack(children: [
            //Base Container of stack
            Container(),
            Positioned(
              top: 25,
              left: 26,
              child: Container(
                height: h - 10,
                width: w - 18,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 178, 60),
                    border: Border.all(
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(29)),
              ),
            ),
            Positioned(
              top: 20,
              left: 25,
              child: Container(
                height: h - 20,
                width: w - 17,
                // ignore: sort_child_properties_last
                child: Stack(children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    //image
                    child: Container(
                      height: 270,
                      width: 275,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: imageUrl != 'null'
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  imageUrl,
                                  scale: 0.3,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null, //A default image can be shown here
                      ),
                    ),
                  ),
                  Positioned(
                      top: 293,
                      left: 25,
                      child: SizedBox(
                        width: 218,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_month_outlined),
                                SizedBox(width: 7),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Text(
                                      dateTime,
                                      style: Utils.dtStyle,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1.5, color: Colors.grey)),
                                ),
                                SizedBox(width: 8)
                              ],
                            )
                          ],
                        ),
                      ))
                ]),

                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.8,
                    ),
                    color: Color.fromARGB(255, 243, 251, 245),
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    Secret secret = new Secret();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 160,
            width: 60,
            child: Column(children: [
              //To view
              OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return EventDetailScreen(
                            title: name,
                            ID: ID,
                            description: description,
                            imageUrl: imageUrl,
                            date_time: dateTime,
                            organiser: organizer,
                            venue: venue);
                      },
                    ));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.remove_red_eye), Text('View')])),
              //To Update
              OutlinedButton(
                  onPressed: () {
                    secret.showPwDialog(context, () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return UpdateForm(
                              dbRef: dbRef,
                              eventID: ID,
                              description: description,
                              name: name,
                              orgName: organizer,
                              dateTime: dateTime,
                              venue: venue);
                        },
                      ));
                    });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.edit), Text('Edit')])),
              //To delete
              OutlinedButton(
                  onPressed: () async {
                    secret.showPwDialog(context, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Container(
                            child: Text(
                              "Delete this event?",
                              style: Utils.style2,
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  FireBaseControlls.deleteEvent(
                                      context: context, dbRef: dbRef, ID: ID);
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                          ],
                        ),
                      ).then((_) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.delete_rounded), Text('Delete')])),
            ]),
          ),
        );
      },
    );
  }
}
