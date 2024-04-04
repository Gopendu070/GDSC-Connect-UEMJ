import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FireBaseControlls.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:image_picker/image_picker.dart';

class AddSpeakerForm extends StatefulWidget {
  DatabaseReference speakerDbRef;
  String speakerID;
  AddSpeakerForm({required this.speakerDbRef, required this.speakerID});
  @override
  _AddSpeakerFormState createState() => _AddSpeakerFormState();
}

class _AddSpeakerFormState extends State<AddSpeakerForm> {
  var isUploading = false;
  File? _image;
  final picker = ImagePicker();
  String _imgURL = "";
  XFile? pickedFile;

  final formKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null)
      setState(() {
        _image = File(pickedFile!.path);
        print(pickedFile!.path);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Add Speaker", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  height: 190,
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(),
                  ),
                  child: GestureDetector(
                    onTap: getImageFromGallery,
                    child: _image == null
                        ? Container(
                            height: 190,
                            width: 190,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(100),
                              // border: Border.all(),
                            ),
                            child: Icon(Icons.camera_alt_rounded),
                          )
                        : Stack(children: [
                            Container(
                              height: 190,
                              width: 190,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: FileImage(
                                      _image!,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                                right: 10,
                                bottom: 10,
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 35,
                                  color: Colors.grey[900],
                                ))
                          ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //First Name
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: fnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field Required";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text("First Name"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //Last Name
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: lnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field Required";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text("Last Name"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                SizedBox(height: 20),

                ElevatedButton(
                    onPressed: () async {
                      addSpeaker();
                    },
                    child: isUploading
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Text("Add"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addSpeaker() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      // setState(() {
      //   isUploading = true;
      // });
      try {
        Reference rootReference = FirebaseStorage.instance.ref();
        Reference speakerDirReference = rootReference.child("speaker_images");
        Reference imgReference = speakerDirReference.child(widget.speakerID);
        Fluttertoast.showToast(
            msg: "Uploading, please wait", toastLength: Toast.LENGTH_LONG);
        setState(() {
          isUploading = true;
        });
        await imgReference.putFile(File(pickedFile!.path));
        _imgURL = await imgReference.getDownloadURL();
        print(_imgURL);
      } on FirebaseException catch (err) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(err.message.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }

      FireBaseControlls.uploadSpeakerInfo(
          fname: fnameController.text,
          lname: lnameController.text,
          imgURL: _imgURL,
          speakerID: widget.speakerID,
          speakerDbRef: widget.speakerDbRef);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }
}
