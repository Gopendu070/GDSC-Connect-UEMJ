import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  ///////////////////////////////////
  int _imgCount = 0;
  int get imgCount => _imgCount;
  void setImgCount(int c) {
    _imgCount = c;
    notifyListeners();
  }

  //////////////////////////////////
  bool _isUpcoming = true;
  bool get isUpcoming => _isUpcoming;

  int _selectedButton = 1;
  int get selectedButton => _selectedButton;
  void setIsUpcomingTrue() {
    if (_isUpcoming == false) {
      _isUpcoming = true;
      _selectedButton = 1;
    }
    notifyListeners();
  }

  void setIsUpcomingFalse() {
    if (_isUpcoming == true) {
      _isUpcoming = false;
      _selectedButton = 2;
    }
    notifyListeners();
  }

  double _elevation = 2.0;
  double get elevation => _elevation;
  void buttonPressed(int buttonIndex) {
    print("button ===> " + _selectedButton.toString());
    if (_selectedButton == buttonIndex && _elevation == 2.0)
      _elevation = 7.0;
    else
      _elevation = 2.0;

    notifyListeners();
  }
}
