import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdscuemj/controller/Members.dart';
import 'package:gdscuemj/screen/AllEventsScreen.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/screen/SocialPagesScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:provider/provider.dart';

import '../controller/NavProvider.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    final navProvider = Provider.of<NavProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("Our Team", style: Utils.style1.copyWith(fontSize: 26)),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              CustomDivider(),
              Expanded(
                child: ListView.builder(
                  itemCount: Members.members.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(124, 148, 157, 182),
                                  Color.fromARGB(82, 211, 213, 223),
                                  Colors.white38,
                                ])),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration:
                                      BoxDecoration(color: Colors.white54),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 80,
                                left: 75,
                                child: Image.asset(
                                    'lib/asset/image/GDSC_rmbg.png',
                                    height: 40)),
                            Positioned(
                              top: 30,
                              left: 130,
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Members.members[index]["name"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "< " + "Developer" + " >",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Consumer<NavProvider>(
          builder: (context, value, child) {
            return SizedBox(
              width: Width,
              height: 70,
              child: Stack(children: [
                Container(
                  width: Width,
                  color: Colors.transparent,
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
                        NavigationButton(
                          icon: Icons.group_outlined,
                          index: navProvider.indexArr.elementAt(2),
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
        ));
  }
}
