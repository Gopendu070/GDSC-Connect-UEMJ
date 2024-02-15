import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdscuemj/controller/FilterProvider.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/screen/SocialPagesScreen.dart';
import 'package:gdscuemj/screen/TeamScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/EventTiles.dart';
import 'package:gdscuemj/widget/EventWidget.dart';
import 'package:gdscuemj/widget/FilterButton.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  int timeDifference(DataSnapshot snapshot) {
    DateFormat dateFormat = DateFormat("h:mm a d MMM, yyyy");
    DateTime eventDateTime =
        dateFormat.parse(snapshot.child('date_time').value.toString());
    Duration timeDiff = eventDateTime.difference(DateTime.now());
    int diffInHrs = timeDiff.inHours;
    print("DIFFERENCE IN HRS => " + diffInHrs.toString());
    return diffInHrs;
  }

  final dbRef = FirebaseDatabase.instance.ref('gdscDB');
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    final navProvider = Provider.of<NavProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Our events",
          style: Utils.style1.copyWith(fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(children: [
          CustomDivider(),
          SizedBox(height: 25),
          Row(
            children: [
              SizedBox(width: 10),
              Consumer<FilterProvider>(
                builder: (context, value, child) => FilterButton(
                  button: "Upcoming Events",
                  buttonIndex: 1,
                ),
              ),
              SizedBox(width: 10),
              Consumer<FilterProvider>(
                builder: (context, value, child) => FilterButton(
                  button: "Previous Events",
                  buttonIndex: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          SizedBox(
            width: Width,
            height: Height * .6,
            child: Consumer<FilterProvider>(
              builder: (context, value, child) => FirebaseAnimatedList(
                scrollDirection: Axis.horizontal,
                query: dbRef,
                itemBuilder: (context, snapshot, animation, index) {
                  return FutureBuilder<String>(
                    future: getFirstImageURL(snapshot),
                    builder: (context, imageUrlSnapshot) {
                      //Filternig the list => upcoming events
                      if (value.isUpcoming && timeDifference(snapshot) >= 0) {
                        return eventSelection(snapshot,
                            imageUrlSnapshot); //returns the filtered event
                      }
                      //Filternig the list => past events
                      else if (!value.isUpcoming &&
                          timeDifference(snapshot) < 0) {
                        return eventSelection(snapshot, imageUrlSnapshot);
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Consumer<FilterProvider>(
            builder:
                (BuildContext context, FilterProvider value, Widget? child) =>
                    Text(
              value.isUpcoming ? "< Upcoming >" : "< Previous >",
              style: Utils.waterMark,
            ),
          )
        ]),
      ),
      bottomNavigationBar: Consumer<NavProvider>(
        builder: (context, value, child) {
          return SizedBox(
            width: Width,
            height: 70,
            child: Stack(children: [
              Container(
                width: Width,
              ),
              Positioned(
                top: 7,
                left: 15,
                child: Container(
                  height: 55,
                  width: Width - 27,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 225, 167, 50),
                      borderRadius: BorderRadius.circular(28)),
                ),
              ),
              Positioned(
                top: 3,
                left: 13,
                child: Container(
                  height: 54,
                  width: Width - 30,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 169, 201, 242),
                      borderRadius: BorderRadius.circular(28)),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          navProvider.selectIndex(0);
                          //  if (navProvider.selectedInd != 0)
                          Timer(Duration(milliseconds: 200), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ));
                          });
                        },
                        child: NavigationButton(
                          icon: Icons.home_outlined,
                          index: navProvider.indexArr.elementAt(0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (navProvider.selectedInd != 1) {
                            navProvider.selectIndex(1);
                            Timer(Duration(milliseconds: 200), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllEventsScreen(),
                                  ));
                            });
                          }
                        },
                        child: NavigationButton(
                          icon: Icons.calendar_month_outlined,
                          index: navProvider.indexArr.elementAt(1),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navProvider.selectIndex(2);
                          Timer(Duration(milliseconds: 200), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamScreen(),
                                ));
                          });
                        },
                        child: NavigationButton(
                          icon: Icons.group_outlined,
                          index: navProvider.indexArr.elementAt(2),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navProvider.selectIndex(3);
                          Timer(Duration(milliseconds: 200), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SocialPagesScreen(),
                                ));
                          });
                        },
                        child: NavigationButton(
                          icon: Icons.star_border_rounded,
                          index: navProvider.indexArr.elementAt(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget eventSelection(
      DataSnapshot snapshot, AsyncSnapshot<String> imageUrlSnapshot) {
    if (imageUrlSnapshot.connectionState == ConnectionState.waiting) {
      // While the URL is being fetched, you can return a loading indicator or placeholder.
      return Center(child: CircularProgressIndicator());
    } else if (imageUrlSnapshot.hasError) {
      // Handle error state, for example, by showing a default image.
      return Image.network('https://gdscutsa.com/assets/images/banner.webp');
    } else {
      return EventTiles(
        dbRef: dbRef,
        ID: snapshot.child('id').value.toString(),
        name: snapshot.child('name').value.toString(),
        dateTime: snapshot.child('date_time').value.toString(),
        venue: snapshot.child('venue').value.toString(),
        description: snapshot.child('description').value.toString(),
        organizer: snapshot.child('organizer').value.toString(),
        imageUrl: imageUrlSnapshot.data!,
      );
    }
  }

  Future<String> getFirstImageURL(DataSnapshot snapshot) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${snapshot.child('id').value.toString()}');
      final ListResult result = await storageRef.list();
      if (result.items.isNotEmpty) {
        final Reference firstImageRef = result.items[0];
        final String imageUrl = await firstImageRef.getDownloadURL();
        return imageUrl;
      } else {
        return 'https://gdscutsa.com/assets/images/banner.webp';
      }
    } catch (error) {
      print('Error: $error');
      return 'https://gdscutsa.com/assets/images/banner.webp';
    }
  }
}