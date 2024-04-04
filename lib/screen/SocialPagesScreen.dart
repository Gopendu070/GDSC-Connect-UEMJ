import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:gdscuemj/screen/AllEventsScreen.dart';
import 'package:gdscuemj/screen/HomePage.dart';
import 'package:gdscuemj/screen/TeamScreen.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:gdscuemj/widget/NavigationButton.dart';
import 'package:gdscuemj/widget/SocialHandleTile.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

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
            title: Text("Social Handles",
                style: Utils.style1.copyWith(fontSize: 26)),
            centerTitle: true),
        body: Container(
          child: Column(
            children: [
              CustomDivider(),
              SocialHandleTile(
                  title: "Join Our GDSC Community",
                  url_str:
                      "https://gdsc.community.dev/university-of-engineering-management-jaipur/",
                  icon_path: "lib/asset/image/GDSC_rmbg.png",
                  cust_color: const Color.fromARGB(255, 220, 163, 230)),
              SocialHandleTile(
                  title: "Join WhatsApp Group",
                  url_str: "https://chat.whatsapp.com/Dy5z0J19woj3aUYkWrs7wh",
                  icon_path: "lib/asset/image/wp.png",
                  cust_color: Color.fromARGB(190, 95, 217, 93)),
              SocialHandleTile(
                  title: "GDSC UEM JAIPUR",
                  url_str:
                      "https://www.linkedin.com/company/gdsc-uemjaipur/mycompany/",
                  icon_path: "lib/asset/image/in_icon.png",
                  cust_color: Color.fromARGB(189, 97, 157, 221)),
              SocialHandleTile(
                  title: "@uemjaipur_gdsc",
                  url_str:
                      "https://www.instagram.com/uemjaipur_gdsc?igshid=NjIwNzIyMDk2Mg%3D%3D",
                  icon_path: "lib/asset/image/insta.png",
                  cust_color: Color.fromARGB(205, 221, 84, 127)),
              Expanded(
                  child: Lottie.asset(
                'lib/asset/image/SocialAnimation.json',
              )),
            ],
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
                      mainAxisAlignment: Width < Utils.maxPhWidth
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceAround,
                      children: [
                        if (Width < Utils.maxPhWidth) SizedBox(width: 8),
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
