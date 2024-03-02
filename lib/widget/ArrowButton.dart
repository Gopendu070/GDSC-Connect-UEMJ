import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  bool isBackArrow;
  ScrollController scrollControll;

  ArrowButton(
      {super.key, required this.isBackArrow, required this.scrollControll});

  @override
  Widget build(BuildContext context) {
    void goToEnd({required ScrollController scrollController}) {
      var end = scrollController.position.maxScrollExtent;
      print(end);
      scrollController.position.animateTo(end,
          duration: Duration(milliseconds: 2700), curve: Curves.easeIn);
    }

    void goToStart({required ScrollController scrollController}) {
      var begin = 0.0;
      scrollController.position.animateTo(begin,
          duration: Duration(milliseconds: 2700), curve: Curves.easeIn);
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          if (isBackArrow) {
            print("start");
            goToStart(scrollController: scrollControll);
          } else {
            print("end");
            goToEnd(scrollController: scrollControll);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(148, 227, 225, 225),
              borderRadius: BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: isBackArrow
                ? Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black54,
                    size: 18,
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                    size: 18,
                  ),
          ),
        ),
      ),
    );
  }
}
