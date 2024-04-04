import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:gdscuemj/model/Speakers.dart';
import 'package:gdscuemj/screen/AddSpeakerForm.dart';
import 'package:gdscuemj/screen/AllEventsScreen.dart';
import 'package:gdscuemj/screen/SocialPagesScreen.dart';
import 'package:gdscuemj/screen/TeamScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/ArrowButton.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/DrawerButton.dart';
import 'package:gdscuemj/widget/EventWidget.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:gdscuemj/widget/SpeakerTileWidget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref('gdscDB');
  final speakerDbRef = FirebaseDatabase.instance.ref('gdscSpeakerDB');
  late String imageUrl1;
  ScrollController _speakerScrollController = ScrollController();
  ScrollController _eventScrollController = ScrollController();

  List<Speakers> speakersList = [];
  Future<List<Speakers>> getSpeakersData() async {
    try {
      DatabaseEvent databaseEvent = await speakerDbRef.once();
      var dataSnapshot = databaseEvent.snapshot;
      Object? dataMap = dataSnapshot.value;
      if (dataMap is Map) {
        int c = 0;
        dataMap.forEach((key, value1) {
          var sp = Speakers.fromSnapshot(dataSnapshot.child(key.toString()));
          speakersList.add(sp);
          setState(() {});
          c++;
        });
        print("count= $c");
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    return speakersList;
  }

  setSpeakerList() async {
    speakersList = await getSpeakersData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSpeakerList();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    final navProvider = Provider.of<NavProvider>(context, listen: false);
    return Scaffold(
      //Drawer
      endDrawer: Container(
        width: 195,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 249, 243, 250),
              Color.fromARGB(255, 211, 177, 215),
            ])),
        child: Column(
          children: [
            SizedBox(height: 35),
            Container(
              width: 100,
              height: 100,
              child: Utils.userImgUrl == null
                  ? Lottie.asset("lib/asset/image/UserAnimation.json")
                  : Container(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(Utils.userImgUrl!),
                      fit: BoxFit.cover),
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(90)),
            ),
            //User Name
            Column(
              children: [
                Text(
                  Utils.firstName!,
                  style: Utils.style2.copyWith(fontSize: 20),
                ),
                Text(
                  Utils.lastName!,
                  style: Utils.style2.copyWith(fontSize: 20),
                ),
              ],
            ),
            CustomDivider(),
            SizedBox(height: 10),
            //Buttons
            InDrawerButton(
              dbRef: dbRef,
              title: "Add Event",
              icon: Icons.add,
            ),
            InDrawerButton(
              dbRef: dbRef,
              title: "Add Speaker",
              icon: Icons.add,
            ),
            InDrawerButton(
              dbRef: dbRef,
              title: "Create",
              icon: Icons.photo_filter,
            ),
            InDrawerButton(
              dbRef: dbRef,
              title: "About",
              icon: Icons.info_outline,
            ),

            InDrawerButton(
              dbRef: dbRef,
              title: "Logout",
              icon: Icons.logout,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Fluttertoast.showToast(
                      backgroundColor: Color.fromARGB(129, 158, 64, 175),
                      msg: "Hi ${Utils.firstName} 👋🏽",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER);
                },
                child:
                    Image.asset('lib/asset/image/GDSC_rmbg.png', height: 33)),
            Text(
              " Welcome " + Utils.firstName!,
              style:
                  Utils.style1.copyWith(color: Color.fromARGB(194, 19, 19, 19)),
            ),
          ],
        ),
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
                    mainAxisAlignment: Width < Utils.maxPhWidth
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.spaceAround,
                    children: [
                      if (Width < Utils.maxPhWidth) SizedBox(width: 8),
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
                "< Flagship Events >",
                style: Utils.style1,
              ),
            ),
            //List of events
            Stack(children: [
              Container(),
              SizedBox(
                width: Width,
                height: Width < Utils.maxPhWidth ? 320 : 350,
                child: Scrollbar(
                  thickness: 2,
                  child: FirebaseAnimatedList(
                    controller: _eventScrollController,
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
                              description: snapshot
                                  .child('description')
                                  .value
                                  .toString(),
                              organizer:
                                  snapshot.child('organizer').value.toString(),
                              imageUrl: imageUrlSnapshot.data!,
                            );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: Width < Utils.maxPhWidth ? 127 : 136,
                child: SizedBox(
                  width: Width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArrowButton(
                        isBackArrow: true,
                        scrollControll: _eventScrollController,
                      ),
                      ArrowButton(
                        isBackArrow: false,
                        scrollControll: _eventScrollController,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            //All Speakers List
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "< Our Speakers >",
                style: Utils.style1,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Stack(children: [
                  Container(),
                  SizedBox(
                    child: Scrollbar(
                      thickness: 2,
                      child: Width < Utils.maxPhWidth
                          ? FirebaseAnimatedList(
                              controller: _speakerScrollController,
                              query: speakerDbRef,
                              scrollDirection: Axis.horizontal,
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                return SpeakerTileWidget(
                                    fname: snapshot
                                        .child("fname")
                                        .value
                                        .toString(),
                                    lname: snapshot
                                        .child("lname")
                                        .value
                                        .toString(),
                                    imgURL: snapshot
                                        .child("imgUrl")
                                        .value
                                        .toString());
                              },
                            )
                          : Scrollbar(
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: speakersList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 227,
                                  mainAxisSpacing: 3,
                                  crossAxisCount: 4,
                                ),
                                itemBuilder: (context, index) {
                                  return SpeakerTileWidget(
                                      imgURL: speakersList[index].imgUrl,
                                      fname:
                                          speakersList[index].fName.toString(),
                                      lname: speakersList[index].lName);
                                },
                              ),
                            ),
                    ),
                  ),
                  Width < Utils.maxPhWidth
                      ? Positioned(
                          top: 100,
                          child: SizedBox(
                            width: Width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ArrowButton(
                                  isBackArrow: true,
                                  scrollControll: _speakerScrollController,
                                ),
                                ArrowButton(
                                  isBackArrow: false,
                                  scrollControll: _speakerScrollController,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ]),
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
