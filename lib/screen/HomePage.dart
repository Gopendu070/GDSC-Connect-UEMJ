import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:gdscuemj/screen/AllEventsScreen.dart';
import 'package:gdscuemj/screen/EntryForm.dart';
import 'package:gdscuemj/screen/SocialPagesScreen.dart';
import 'package:gdscuemj/screen/TeamScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/EventWidget.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref('gdscDB');
  late String imageUrl1;

  late String eventID;
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    final navProvider = Provider.of<NavProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/asset/image/GDSC_rmbg.png', height: 33),
            Text(
              ' GDSC UEMJ',
              style:
                  Utils.style1.copyWith(color: Color.fromARGB(194, 19, 19, 19)),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                eventID = DateTime.now().microsecondsSinceEpoch.toString();
                print(eventID);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EntryForm(dbRef: dbRef, eventID: eventID)));
              },
              icon: Icon(Icons.add))
        ],
      ),

      //Custom bottomNavigationBar
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
                      //Home Button

                      NavigationButton(
                        icon: Icons.home_outlined,
                        index: navProvider.indexArr.elementAt(0),
                      ),

                      //All Event Button
                      InkWell(
                        onTap: () {
                          navProvider.selectIndex(1);
                          Timer(Duration(milliseconds: 200), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllEventsScreen(),
                                ));
                          });
                        },
                        child: NavigationButton(
                          icon: Icons.calendar_month_outlined,
                          index: navProvider.indexArr.elementAt(1),
                        ),
                      ),

                      //Team Button
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

                      //Socials Buuton
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
      body: Container(
        width: Width,
        height: Height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Flagship Events",
                style: Utils.style1,
              ),
            ),
            SizedBox(
              width: Width,
              height: 320,
              child: FirebaseAnimatedList(
                scrollDirection: Axis.horizontal,
                query: dbRef,
                itemBuilder: (context, snapshot, animation, index) {
                  return FutureBuilder<String>(
                    future: getFirstImageURL(snapshot),
                    builder: (context, imageUrlSnapshot) {
                      if (imageUrlSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        // While the URL is being fetched, you can return a loading indicator or placeholder.
                        return Center(child: CircularProgressIndicator());
                      } else if (imageUrlSnapshot.hasError) {
                        // Handle error state, for example, by showing a default image.
                        return Image.network(
                            'https://gdscutsa.com/assets/images/banner.webp');
                      } else
                        return EventWidget(
                          dbRef: dbRef,
                          ID: snapshot.child('id').value.toString(),
                          name: snapshot.child('name').value.toString(),
                          dateTime:
                              snapshot.child('date_time').value.toString(),
                          venue: snapshot.child('venue').value.toString(),
                          description:
                              snapshot.child('description').value.toString(),
                          organizer:
                              snapshot.child('organizer').value.toString(),
                          imageUrl: imageUrlSnapshot.data!,
                        );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Our Speakers",
                style: Utils.style1,
              ),
            ),
          ],
        ),
      ),
    );
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
