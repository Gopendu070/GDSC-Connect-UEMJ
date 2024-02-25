import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FilterProvider.dart';
import 'package:gdscuemj/controller/FireBaseControlls.dart';
import 'package:gdscuemj/screen/PickImage.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EntryForm extends StatefulWidget {
  DatabaseReference dbRef;
  String eventID;
  int imgCount;
  EntryForm(
      {required this.dbRef, required this.eventID, required this.imgCount});

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  var selectedDT = DateTime.now();
  var selectedTime = DateTime.now();
  final formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var orgController = TextEditingController();
  var descriptController = TextEditingController();
  var venueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Enter Event Details'),
      //   // backgroundColor: Color.fromARGB(255, 237, 178, 96),
      // ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(192, 243, 209, 58),
                Color.fromARGB(165, 238, 208, 72),
                // Color.fromARGB(77, 233, 234, 205),
                Colors.white,
                Colors.white
              ])),
        ),
        Container(
          height: Height / 3 - 7,
          width: Width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "lib/asset/image/bulbs.png",
                  ),
                  fit: BoxFit.fill)),
        ),
        Positioned(
            top: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )),
        Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    'lib/asset/image/GDSC_rmbg.png',
                    width: 95,
                    height: 50,
                  ),
                  Form(
                    key: formkey,
                    child: Container(
                      width: Width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //name
                          textField(
                              label: 'Event',
                              hint: 'GDSC MeetUp',
                              conTroll: nameController,
                              lines: 1),
                          //organizer
                          textField(
                              label: 'Organizer',
                              hint: 'GDSC UEMJ',
                              conTroll: orgController,
                              lines: 1),
                          //Description
                          textField(
                              label: 'Description',
                              hint: 'About the event',
                              conTroll: descriptController,
                              lines: 3),
                          //Venue
                          textField(
                              label: 'Venue',
                              hint: 'Jaipur, India',
                              conTroll: venueController,
                              lines: 1),
                        ],
                      ),
                    ),
                  ),
                  //Date & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Timings: ',
                        style: Utils.labelStyle,
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_month),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                      Text(
                        DateFormat('h:mm a').format(selectedTime).toString() +
                            ' ~ ' +
                            DateFormat('d MMM, yyyy')
                                .format(selectedDT)
                                .toString(),
                        style: Utils.dtStyle,
                      )
                    ],
                  ),
                  //Image upload
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Upload Images : ',
                      style: Utils.labelStyle,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PickImage(eventID: widget.eventID);
                            },
                          ));
                        },
                        icon: Icon(Icons.camera_alt_rounded)),
                    Consumer<FilterProvider>(
                      builder: (context, value, child) {
                        return Text(
                          value.imgCount.toString() + " Uploaded",
                          style: Utils.labelStyle.copyWith(fontSize: 13),
                        );
                      },
                    )
                  ]),
                  SizedBox(height: 20),
                  //Submit Button
                  ElevatedButton(
                      onPressed: () {
                        final isValid = formkey.currentState!.validate();
                        if (isValid == true) {
                          //Add to Firebase
                          FireBaseControlls.addEvent(
                                  dbRef: widget.dbRef,
                                  eventID: widget.eventID,
                                  name: nameController.text,
                                  org: orgController.text,
                                  description: descriptController.text,
                                  venue: venueController.text,
                                  selectedTime: selectedTime,
                                  selectedDT: selectedDT)
                              .whenComplete(() {
                            filterProvider.setImgCount(0);
                            Fluttertoast.showToast(
                              msg: "Event Scehduled",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            Timer(Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          });
                        }
                      },
                      child: Text('Schedule Event'))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  //returns a custom widget
  Widget textField(
      {required String label,
      required TextEditingController conTroll,
      required int lines,
      required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 330,
            child: TextFormField(
              controller: conTroll,
              maxLines: lines,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Field Required";
                } else
                  return null;
              },
              decoration: InputDecoration(
                  label: Text(
                    label,
                    style: Utils.labelStyle,
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  //Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2031),
    );
    if (pickedDate != null) {
      print(pickedDate.toString());

      setState(() {
        selectedDT = pickedDate;
      });
      _selectTime(context);
    }
  }

  //Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
      final DateTime pickedTIME =
          DateTime(0, 1, 1, pickedTime.hour, pickedTime.minute);
      // final formattedTime = DateFormat('h:mm a').format(pickedTIME);
      print(pickedTime.toString());
      setState(() {
        selectedTime = pickedTIME;
      });
    }
  }
}
