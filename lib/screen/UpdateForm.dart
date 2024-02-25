import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FireBaseControlls.dart';
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
      appBar: AppBar(title: Text('Update Event')),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
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
                        lines: 3),
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
                            ' ~ ' +
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
                  final isValid = formkey.currentState!.validate();
                  if (isValid == true) {
                    FireBaseControlls.updateEvent(
                        dbRef: widget.dbRef,
                        eventID: widget.eventID,
                        name: nameController.text,
                        description: descriptController.text,
                        org: orgController.text,
                        venue: venueController.text,
                        dateTime: widget.dateTime,
                        selectedDT: selectedDT,
                        selectedTime: selectedTime);
                    Fluttertoast.showToast(
                      msg: "Updated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    Timer(Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Update'))
          ],
        )),
      ),
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
          Text(
            label,
            style: Utils.labelStyle,
          ),
          SizedBox(
            width: 200,
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
      final formattedTime = DateFormat('h:mm a')
          .format(DateTime(0, 1, 1, pickedTime.hour, pickedTime.minute));
      print(pickedTime.toString());
      setState(() {
        selectedTime = formattedTime;
      });
    }
  }
}
