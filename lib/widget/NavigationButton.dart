import 'package:flutter/material.dart';
import 'package:gdscuemj/controller/NavProvider.dart';
import 'package:provider/provider.dart';

class NavigationButton extends StatelessWidget {
  IconData icon;
  // Color color;
  int index;
  NavigationButton({
    super.key,
    required this.icon,
    required this.index,
    //  required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    //color and elevation
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: navProvider.selectedInd == index ? 1.7 : 5.8,
        child: Container(
          width: 64,
          height: 50,
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 96, 95, 95),
          ),
          decoration: BoxDecoration(
            color: navProvider.selectedInd == index
                ? Color.fromARGB(255, 232, 165, 31)
                : Color.fromARGB(255, 242, 181, 60),
            borderRadius: BorderRadius.circular(12.85),
          ),
        ),
      ),
    );
  }
}
