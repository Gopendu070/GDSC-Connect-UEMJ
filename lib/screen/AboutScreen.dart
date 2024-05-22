import 'package:flutter/material.dart';
import 'package:gdscuemj/utils/Utils.dart';
import 'package:gdscuemj/widget/CustomDivider.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    final aboutText =
        "GDSC UEM Jaipur is a non-profit developer powered by Google Developers to learn , share, connect and develop skills. Our moto is to  \"Connect, Learn & Grow.\"\n\nGdsc provides need-based, skill integrated, cost effective, quality, and holistic education, transforming the students into globally competitive, employable and responsible citizens and to be recognized as a center of excellence.";
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              // Image.asset('lib/asset/image/GDSC_rmbg.png', height: 33),
              Text(
                "About GDSC UEMJ",
                style: Utils.style1,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomDivider(),
                SizedBox(height: 10),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      aboutText,
                      textAlign: TextAlign.justify,
                      style: Utils.style2,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          final url =
                              "https://gdsc.community.dev/university-of-engineering-management-jaipur/";
                          final uri = Uri.parse(url);

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        child: Text("No more about us ->")),
                  ],
                ),
                SizedBox(height: Height * 0.1),
                LottieBuilder.asset(
                  'lib/asset/image/LoginAnimation.json',
                  height: Height * 0.272,
                  width: Width,
                ),
              ],
            ),
          ),
        ));
  }
}
