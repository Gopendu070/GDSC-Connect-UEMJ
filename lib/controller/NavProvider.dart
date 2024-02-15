import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  Color _buttonColor = Color.fromARGB(255, 244, 180, 52);
  Color get buttonColor => _buttonColor;
  List<int> _indexArr = [0, 1, 2, 3];
  List<int> get indexArr => _indexArr;

  int _selectedInd = 0;
  int get selectedInd => _selectedInd;
  void selectIndex(int ind) {
    _selectedInd = ind;
    notifyListeners();
  }

  void selectButton(int i) {
    if (i == indexArr[i]) {
      if (_buttonColor == Color.fromARGB(255, 244, 180, 52))
        _buttonColor = Color.fromARGB(255, 236, 171, 40);
      else
        _buttonColor = Color.fromARGB(255, 244, 180, 52);
      notifyListeners();
    }
  }
}
