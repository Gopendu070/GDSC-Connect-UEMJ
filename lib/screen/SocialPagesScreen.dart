import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:gdscuemj/screen/AllEventsScreen.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/screen/TeamScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:provider/provider.dart';

class SocialPagesScreen extends StatefulWidget {
  const SocialPagesScreen({super.key});

  @override
  State<SocialPagesScreen> createState() => _SocialPagesScreenState();
}

class _SocialPagesScreenState extends State<SocialPagesScreen> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    final navProvider = Provider.of<NavProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            title: Text("Media Handles",
                style: Utils.style1.copyWith(fontSize: 26)),
            centerTitle: true),
        body: Container(
          child: Column(
            children: [CustomDivider()],
          ),
        ),
        bottomNavigationBar: Consumer(
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
                        NavigationButton(
                          icon: Icons.star_border_rounded,
                          index: navProvider.indexArr.elementAt(3),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        ));
  }
}
