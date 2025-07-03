import 'package:fan/data/fan_noise_player.dart';
import 'package:flutter/material.dart';

class FanState extends ChangeNotifier {
  FanState() {
    addListener(() => fanNoisePlayer.update(evaluate()));
  }

  bool get isOn => _isOn;
  bool _isOn = false;
  set isOn(bool isOn) {
    if (_isOn == isOn) return;
    _isOn = isOn;
    notifyListeners();
  }

  /// The fan's speed when it is on.
  ///
  /// This value does not change when the fan is turned on/off.
  /// If the fan is off, this value is ignored.
  FanStateEnum get speed => _speed;
  FanStateEnum _speed = FanStateEnum.low;
  set speed(FanStateEnum speed) {
    if (_speed == speed) return;
    assert(speed != FanStateEnum.off, 'Cannot set speed to off');
    _speed = speed;
    notifyListeners();
  }

  FanStateEnum evaluate() {
    if (!isOn) return FanStateEnum.off;
    return speed;
  }
}

enum FanStateEnum { off, low, medium, high }
