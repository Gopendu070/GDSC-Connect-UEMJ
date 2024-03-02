import 'package:flutter/material.dart';

class PassProvider with ChangeNotifier {
  bool _obscurePW = true;
  bool get obscurePW => _obscurePW;
  void setObscurePW(bool newVal) {
    _obscurePW = newVal;
    notifyListeners();
  }
}
