import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 3,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(colors: [
              Colors.redAccent,
              Colors.blueAccent,
              Color.fromARGB(182, 249, 235, 108),
              Colors.greenAccent
            ])),
      ),
    );
  }
}
