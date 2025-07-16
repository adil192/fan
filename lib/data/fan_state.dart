import 'dart:math';

import 'package:flutter/material.dart';

final fanState = FanState._();

class FanState extends ChangeNotifier {
  FanState._();

  bool get isOn => _isOn;
  bool _isOn = false;
  set isOn(bool isOn) {
    if (_isOn == isOn) return;
    _isOn = isOn;
    notifyListeners();
  }

  FanSpeed get speed => _speed;
  FanSpeed _speed = FanSpeed.low;
  set speed(FanSpeed speed) {
    if (_speed == speed) return;
    _speed = speed;
    notifyListeners();
  }

  bool get oscillate => _oscillate;
  bool _oscillate = false;
  set oscillate(bool oscillate) {
    if (_oscillate == oscillate) return;
    _oscillate = oscillate;
    notifyListeners();
  }

  final angle = ValueNotifier(0.0);
  static const maxAngle = pi / 4;

  Map<String, dynamic> toJson() {
    return {'speed': speed.index, 'oscillate': oscillate};
  }

  FanState.fromJson(Map<String, dynamic> json)
    : _speed = FanSpeed.values[json['speed'] ?? 0],
      _oscillate = json['oscillate'] ?? false;

  void copyFrom(FanState other) {
    speed = other.speed;
    oscillate = other.oscillate;
  }
}

enum FanSpeed { low, medium, high }
