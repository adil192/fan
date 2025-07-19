import 'dart:async';
import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';

abstract class Oscillator {
  static Timer? _timer;

  static void init() {
    const duration = Duration(
      microseconds: Duration.microsecondsPerSecond ~/ 20, // 20 fps
    );
    final dt = duration.inMicroseconds / Duration.microsecondsPerSecond;

    _timer?.cancel();
    _timer = Timer.periodic(duration, (_) => _onTick(dt));
  }

  /// The time it takes for the fan to turn left, right, and return to center.
  static const period = 30;

  /// The time since the current period began.
  static var elapsed = 0.0;

  static void _onTick(double dt) {
    if (!fanState.isOn) return;

    if (fanState.oscillate) {
      _oscillate(dt);
    } else {
      _returnToCenter(dt);
    }
  }

  static void _oscillate(double dt) {
    elapsed = (elapsed + dt) % period;
    fanState.angle.value = _calculateAngle(elapsed);
  }

  static double _calculateAngle(double elapsed) {
    final t = curve(elapsed);
    return FanState.maxAngle * t;
  }

  @visibleForTesting
  static double curve(double elapsed) {
    final s = sin((elapsed / period) * (2 * pi));
    return s;
  }

  static void _returnToCenter(double dt) {
    if (-0.01 < fanState.angle.value && fanState.angle.value < 0.01) {
      // Round to zero
      fanState.angle.value = 0;
      return;
    }

    // If heading away from center, reverse direction
    if (elapsed < period / 4) {
      elapsed = period / 2 - elapsed;
    } else if (period / 2 < elapsed && elapsed < period * 3 / 4) {
      elapsed = period - elapsed;
    } else {
      // Otherwise, continue oscillating towards center
      elapsed = (elapsed + dt) % period;
    }

    fanState.angle.value = _calculateAngle(elapsed);
  }
}
