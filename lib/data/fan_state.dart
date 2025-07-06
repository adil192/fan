import 'package:fan/data/fan_noise_player.dart';
import 'package:flutter/material.dart';

class FanState extends ChangeNotifier {
  FanState() {
    addListener(() => fanNoisePlayer.update(this));
  }

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
}

enum FanSpeed { low, medium, high }
