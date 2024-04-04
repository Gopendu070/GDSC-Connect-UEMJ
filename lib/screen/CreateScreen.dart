import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool x = true;
  File? _image;
  @override
  Widget build(BuildContext context) {
    var Width = MediaQuery.of(context).size.width;

    var Height = MediaQuery.of(context).size.height;

    final picker = ImagePicker();
    XFile? pickedFile;

    Future getImageFromGallery() async {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          x = !x;
          print(x);
          _image = File(pickedFile!.path);
          print(pickedFile!.path);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Create")),
      body: Column(
        children: [
          CustomDivider(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Stack(children: [
              GestureDetector(
                onTap: getImageFromGallery,
                child: _image == null
                    ? Container(
                        height: Height * 0.5,
                        width: Width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/asset/image/frame.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(13)),
                        child: Center(
                            child: Container(
                          height: Height * 0.21,
                          width: Width * 0.34,
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.grey[700],
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(214, 250, 246, 246),
                              borderRadius: BorderRadius.circular(13)),
                        )),
                      )
                    : Container(
                        height: Height * 0.5,
                        width: Width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/asset/image/frame.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(13)),
                        child: Center(
                            child: Container(
                          height: Height * 0.21,
                          width: Width * 0.34,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image!), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(13)),
                        )),
                      ),
              ),
            ]),
          ),
          ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.download_sharp),
              label: Text("Download"))
        ],
      ),
    );
  }
}
