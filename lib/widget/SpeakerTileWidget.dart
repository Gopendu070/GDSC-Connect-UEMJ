import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gdscuemj/utils/Utils.dart';

class SpeakerTileWidget extends StatelessWidget {
  String imgURL;
  String fname;
  String lname;
  SpeakerTileWidget(
      {super.key,
      required this.imgURL,
      required this.fname,
      required this.lname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        surfaceTintColor: Color.fromARGB(82, 242, 171, 242),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 170,
            ),
            Positioned(
              top: 2,
              left: 9,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  height: 140,
                  width: 140,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(110),
                        image: DecorationImage(
                            image: imgURL != ""
                                ? CachedNetworkImageProvider(imgURL,
                                    scale: 0.55)
                                :
                                //Default Image
                                CachedNetworkImageProvider(
                                    Utils.defaultUserLogo,
                                    scale: 0.6),
                            fit: BoxFit.cover)),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(204, 254, 215, 131)),
                ),
              ),
            ),
            Positioned(
              top: 150,
              child: Container(
                width: 166,
                child: Column(
                  children: [
                    //First Name

                    Text(
                      fname,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: Utils.style2,
                    ),

                    //Last Name
                    Text(
                      lname,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: Utils.style2,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
