import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/EventImage.dart';
import 'package:gdscuemj/widget/tiles.dart';
import 'package:intl/intl.dart';

import '../utils/Utils.dart';

class EventDetailScreen extends StatefulWidget {
  String ID;
  String title;
  String description;
  String imageUrl;
  String date_time;
  String organiser;
  String venue;
  EventDetailScreen(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.ID,
      required this.date_time,
      required this.organiser,
      required this.venue});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> imageURLs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listImages('images/${widget.ID}');
    print("length: " + imageURLs.length.toString());
  }

  Future<void> listImages(String path) async {
    try {
      final result = await storage.ref().child(path).list();
      result.items.forEach((element) async {
        final imageUrl = await element.getDownloadURL();
        setState(() {
          imageURLs.add(imageUrl);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var WIDTH = MediaQuery.of(context).size.width;
    var HEIGHT = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: HEIGHT,
              width: WIDTH,
            ),
            Container(
                height: HEIGHT / 3 - 16,
                width: WIDTH,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                )),
            Positioned(
              top: HEIGHT / 3 - 32,
              child: Container(
                height: HEIGHT - HEIGHT * 0.3,
                width: WIDTH,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 240, 216, 244),
                          Colors.white,
                          Color.fromARGB(146, 232, 195, 234),
                        ]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18))),
                child: Scrollbar(
                  thickness: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 12,
                          ),
                          child: Text(widget.title,
                              style: Utils.style1.copyWith(fontSize: 24)),
                        ),
                        CustomDivider(),
                        //Organizer's details
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Tiles(
                                  icon: Icons.play_arrow_outlined,
                                  text: widget.organiser),
                              Tiles(
                                  icon: Icons.calendar_month,
                                  text: widget.date_time),
                              Tiles(
                                  icon: Icons.location_on, text: widget.venue),
                            ],
                          ),
                        ),

                        CustomDivider(),
                        //Description about the event
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'About The Event',
                            style: TextStyle(
                                color: Color.fromARGB(255, 69, 68, 68),
                                fontSize: HEIGHT * 0.021,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Text(
                            widget.description,
                            textAlign: TextAlign.justify,
                            style: Utils.style1.copyWith(fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 8),
                        CustomDivider(),
                        //Gallery
                        imageURLs.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(15.5),
                                child: Container(
                                  height: 170,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Event Gallery',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 69, 68, 68),
                                              fontSize: HEIGHT * 0.021,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: Scrollbar(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageURLs.length,
                                            itemBuilder: (context, index) {
                                              return EventImage(
                                                  index: index,
                                                  imageURLs: imageURLs);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
