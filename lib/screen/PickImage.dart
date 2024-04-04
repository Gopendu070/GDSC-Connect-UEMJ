import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/FilterProvider.dart';
import 'package:gdscuemj/screen/EntryForm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

class PickImage extends StatefulWidget {
  String eventID;
  PickImage({required this.eventID});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }

  bool isUploading = false;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  List<File> imageList = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (isUploading) {
          Fluttertoast.showToast(
            msg: 'Please wait, uploading in progress...',
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Select Images'),
            actions: [
              TextButton(
                  onPressed: () {
                    if (imageList.isNotEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Uploading, Please wait...',
                          toastLength: Toast.LENGTH_LONG);

                      upload().whenComplete(() {
                        filterProvider.setImgCount(imageList.length);
                        Navigator.pop(context);
                      });
                    } else
                      null;
                  },
                  child: Text(
                    'Upload',
                    style: imageList.isEmpty
                        ? TextStyle(color: Colors.grey)
                        : null,
                  )),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_photo_alternate),
            onPressed: () => isUploading ? null : chooseImage(),
          ),
          body: imageList.length > 0
              ? Stack(children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(imageList[index]),
                                fit: BoxFit.cover)),
                      );
                    },
                  ),
                  Center(
                    child: Visibility(
                      child: CircularProgressIndicator(),
                      visible: isUploading,
                    ),
                  )
                ])
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Select multiple images.'),
                  ],
                ))),
    );
  }

  chooseImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 63);
    setState(() {
      imageList.add(File(pickedFile!.path));
    });
    if (pickedFile == null) retrieveLostData();
    Fluttertoast.showToast(msg: 'Pick again', toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) return;
    if (response.file != null) {
      setState(() {
        imageList.add(File(response.file!.path));
      });
    }
  }

  Future upload() async {
    print('Uploading');

    setState(() {
      isUploading = true;
    });
    int count = 0;
    try {
      for (var img in imageList) {
        ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images/${widget.eventID}/${count}');

        await ref.putFile(img).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            imgRef.add({'url': value});
          });
        });
        count++;
      }
    } on FirebaseException catch (err) {
      print("Error:" + err.message.toString());
      Fluttertoast.showToast(
          msg: "Sorry, Access Denied",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }
}
