import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:screenshot/screenshot.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool x = true;
  File? _image;
  var ssController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    var Width = 337.0;

    var Height = 800;

    final picker = ImagePicker();
    XFile? pickedFile;
    Future<String> saveImage(Uint8List imageBytes) async {
      await [Permission.storage].request();
      final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.', '-')
          .replaceAll(':', '-');
      final fileName = 'GDSC-UEMJ-${time}';
      final result =
          await ImageGallerySaver.saveImage(imageBytes, name: fileName);

      return result['filePath'];
    }

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
      appBar: AppBar(
        title: Text("Membership Badge"),
        backgroundColor: Color.fromARGB(122, 238, 222, 244),
      ),
      body: Center(
        child: SizedBox(
          width: Width + 20,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Stack(children: [
                    GestureDetector(
                      onTap: getImageFromGallery,
                      child: _image == null
                          ? Stack(children: [
                              Container(
                                height: Height * 0.68 + 20,
                                //
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'lib/asset/image/frameGU.png'),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              Positioned(
                                top: Height * .2262,
                                left: -20,
                                child: Container(
                                  height: Width * 0.42,
                                  width: Width * 0.42,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.white,
                                        Color.fromARGB(130, 221, 221, 221)
                                      ]),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                      child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.grey[700],
                                  )),
                                ),
                              )
                            ])
                          : Screenshot(
                              controller: ssController,
                              child: Stack(children: [
                                Container(
                                  height: Height * 0.68 + 20,
                                  width: Width - 10,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'lib/asset/image/frameGU.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                                Positioned(
                                  top: Height * .2262,
                                  left: -20,
                                  child: Container(
                                    height: Width * 0.42,
                                    width: Width * 0.42,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(_image!),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                ),
                                Positioned(
                                    left: 5,
                                    top: Height * .423,
                                    child: Text(
                                      "GDSC UEMJ MEMBER ✪",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 75, 110, 125)),
                                    ))
                              ]),
                            ),
                    ),
                  ]),
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      final img = await ssController.capture();
                      if (img == null) {
                        Fluttertoast.showToast(
                            msg: "Choose An Image",
                            gravity: ToastGravity.BOTTOM);
                        print("not saved");
                        print("Height = $Height, Width= $Width");
                        return;
                      } else {
                        await saveImage(img);

                        Fluttertoast.showToast(
                            msg: "Saved To Gallery",
                            gravity: ToastGravity.BOTTOM);
                      }
                    },
                    icon: Icon(Icons.download_sharp),
                    label: Text("Download"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
