import 'dart:convert';

import 'package:flutter/services.dart';

class Members {
  static List members = [];
  Future<void> readMembersData() async {
    String response =
        await rootBundle.loadString('lib/asset/team_members/members.json');
    final data = await json.decode(response);

    members = data["members"];

    print("No of members=> " + members.length.toString());
  }
}
