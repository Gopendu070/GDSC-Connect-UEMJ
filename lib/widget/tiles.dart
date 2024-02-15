import 'package:flutter/material.dart';
import 'package:gdscuemj/utils/Utils.dart';

class Tiles extends StatelessWidget {
  String text;
  IconData icon;
  Tiles({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                size: 28,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color.fromARGB(83, 156, 140, 177),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Utils.labelStyle,
            ),
          ),
        ],
      ),
    );
  }
}
