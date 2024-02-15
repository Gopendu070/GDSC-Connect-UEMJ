import 'package:flutter/material.dart';
import 'package:gdscuemj/controller/FilterProvider.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatefulWidget {
  String button;
  int buttonIndex;
  FilterButton({super.key, required this.button, required this.buttonIndex});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        //set to upcoming
        if (widget.button == "Upcoming Events" &&
            filterProvider.isUpcoming == false) {
          filterProvider.setIsUpcomingTrue();
        }
        //set to past events
        else if (widget.button == "Previous Events" &&
            filterProvider.isUpcoming == true) {
          filterProvider.setIsUpcomingFalse();
        }
      },
      child: Card(
        elevation: filterProvider.selectedButton == widget.buttonIndex ? 2 : 6,
        child: Container(
          child: Center(child: Text(widget.button)),
          height: 35,
          width: 123,
          decoration: BoxDecoration(
              color: filterProvider.selectedButton == widget.buttonIndex
                  ? Color.fromARGB(255, 147, 182, 231)
                  : Color.fromARGB(255, 169, 201, 242),
              borderRadius: BorderRadius.circular(13)),
        ),
      ),
    );
  }
}
