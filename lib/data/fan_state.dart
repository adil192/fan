import 'package:flutter/material.dart';

class FanState extends ChangeNotifier {
  bool get isOn => _isOn;
  bool _isOn = false;
  set isOn(bool isOn) {
    if (_isOn == isOn) return;
    _isOn = isOn;
    notifyListeners();
  }

  double get speed => _speed;
  double _speed = 0.0;
  set speed(double speed) {
    if (_speed == speed) return;
    _speed = speed;
    notifyListeners();
  }
}
