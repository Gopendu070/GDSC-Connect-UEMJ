import 'package:flutter/material.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialHandleTile extends StatelessWidget {
  Color cust_color;
  String title;
  String icon_path;
  String url_str;
  SocialHandleTile(
      {super.key,
      required this.title,
      required this.url_str,
      required this.icon_path,
      required this.cust_color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          var url = Uri.parse(url_str);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 20),
              Text(
                title,
                style: Utils.style4,
              ),
              SizedBox(width: 10),
              Image.asset(
                icon_path,
                height: 30,
              )
            ],
          ),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(),
              gradient: LinearGradient(colors: [
                cust_color,
                Color.fromARGB(122, 217, 212, 212),
                Color.fromARGB(92, 239, 236, 236)
              ])),
        ),
      ),
    );
  }
}
