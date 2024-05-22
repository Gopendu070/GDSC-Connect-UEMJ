import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FireBaseControlls.dart';
import 'package:gdscuemj/widget/textField.dart';
import 'package:intl/intl.dart';

import '../utils/Utils.dart';

class UpdateForm extends StatefulWidget {
  DatabaseReference dbRef;
  String eventID;
  String name;
  String orgName;
  String description;
  String dateTime;
  String venue;
  UpdateForm(
      {required this.dbRef,
      required this.eventID,
      required this.description,
      required this.name,
      required this.orgName,
      required this.dateTime,
      required this.venue});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: widget.name);
    orgController = TextEditingController(text: widget.orgName);
    venueController = TextEditingController(text: widget.venue);
    descriptController = TextEditingController(text: widget.description);
  }

  final dbRef = FirebaseDatabase.instance.ref('gdscDB');

  var selectedDT = DateTime.now();
  var selectedTime = "";
  final formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var orgController = TextEditingController();
  var descriptController = TextEditingController();
  var venueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var Width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'),
        backgroundColor: Color.fromARGB(204, 243, 209, 58),
      ),
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formkey,
                child: Container(
                  width: Width - 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //name
                      textField(
                          label: 'Event  :    ',
                          hint: 'GDSC MeetUp',
                          conTroll: nameController,
                          lines: 1),
                      //organizer
                      textField(
                          label: 'Organizer  : ',
                          hint: 'GDSC UEMJ',
                          conTroll: orgController,
                          lines: 1),
                      //Description
                      textField(
                          label: 'Description :',
                          hint: 'About the event',
                          conTroll: descriptController,
                          lines: 6),
                      //Venue
                      textField(
                          label: 'Venue  :    ',
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
                    'Event Timings: ',
                    style: Utils.labelStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                  selectedTime == ""
                      ? Text(
                          widget.dateTime,
                          style: Utils.dtStyle,
                        )
                      : Text(
                          selectedTime +
                              " " +
                              DateFormat('d MMM, yyyy')
                                  .format(selectedDT)
                                  .toString(),
                          style: Utils.dtStyle,
                        )
                ],
              ),
              SizedBox(height: 20),
              //Update Button
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            width: 150,
                            child: Text(
                              "Update this event?",
                              style: Utils.style2.copyWith(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  final isValid =
                                      formkey.currentState!.validate();
                                  if (isValid == true) {
                                    FireBaseControlls.updateEvent(
                                        context: context,
                                        dbRef: widget.dbRef,
                                        eventID: widget.eventID,
                                        name: nameController.text,
                                        description: descriptController.text,
                                        org: orgController.text,
                                        venue: venueController.text,
                                        dateTime: widget.dateTime,
                                        selectedDT: selectedDT,
                                        selectedTime: selectedTime);
                                  }
                                },
                                child: Text("Update")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Update'))
            ],
          )),
        ),
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
      final formattedTime = DateFormat('h:mm a')
          .format(DateTime(0, 1, 1, pickedTime.hour, pickedTime.minute));
      print(pickedTime.toString());
      setState(() {
        selectedTime = formattedTime;
      });
    }
  }
}
