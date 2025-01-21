import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier {
  bool _isAppStart = true;

  bool get isAppStart => _isAppStart;

  void setAppStart(bool value) {
    _isAppStart = value;
    notifyListeners();
  }
}