// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class SquareCardWidget extends StatelessWidget {
  SquareCardWidget({super.key});
  double h = 290;
  double w = 270;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: h + 10,
          width: w + 10,
          child: Stack(children: [
            Container(),
            Positioned(
              top: 25,
              left: 25,
              child: Container(
                height: h - 17,
                width: w - 17,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 234, 176, 61),
                    border: Border.all(
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(17.7),
                        topRight: Radius.circular(17.7),
                        bottomRight: Radius.circular(15))),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                  // ignore: sort_child_properties_last
                  child: Stack(children: [
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        height: 200,
                        width: 220,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("lib/asset/image/images.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
                        top: 220,
                        left: 20,
                        child: SizedBox(
                          width: 208,
                          child: Text(
                            "Event Title Event Title Event Title Event Title ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ))
                  ]),
                  height: h - 20,
                  width: w - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.8,
                      ),
                      color: Color.fromARGB(255, 243, 251, 245),
                      borderRadius: BorderRadius.circular(15))),
            ),
          ]),
        ),
      ),
    );
  }
}
