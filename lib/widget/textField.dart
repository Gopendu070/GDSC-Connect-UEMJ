import 'package:flutter/material.dart';
import 'package:gdscuemj/utils/Utils.dart';

class textField extends StatelessWidget {
  TextEditingController conTroll;
  int lines;
  String label;
  String hint;
  textField({
    required this.conTroll,
    required this.lines,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 318,
            child: TextFormField(
              controller: conTroll,
              maxLines: lines,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Field Required";
                } else
                  return null;
              },
              decoration: InputDecoration(
                  label: Text(
                    label,
                    style: Utils.labelStyle,
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
