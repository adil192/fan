import 'dart:async';
import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/stows.dart';
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

  /// The time taken in seconds to oscillate/rotate
  /// from one side to the other and back again.
  static int get period => stows.oscillationPeriod.value;

  /// The progress through the current oscillation period, between 0 and 1.
  /// After [period] seconds, it will reset to 0.
  @visibleForTesting
  static var progress = 0.0;

  static void _onTick(double dt) {
    if (!fanState.isOn) return;

    if (fanState.oscillate) {
      _oscillate(dt);
    } else {
      returnToCenter(dt);
    }
  }

  static void _oscillate(double dt) {
    progress = (progress + dt / period) % 1;
    fanState.angle.value = calculateAngle(progress);
  }

  @visibleForTesting
  static double calculateAngle(double progress) {
    final t = curve(progress);
    return FanState.maxAngle * t;
  }

  @visibleForTesting
  static double curve(double progress) {
    final s = sin(progress * (2 * pi));
    return s;
  }

  @visibleForTesting
  static void returnToCenter(double dt) {
    if (-0.01 < fanState.angle.value && fanState.angle.value < 0.01) {
      // Round to zero
      progress = 0;
      fanState.angle.value = 0;
      return;
    }

    // If heading away from center, reverse direction
    headTowardsCenter();

    // Continue oscillating towards center (faster than normal oscillation)
    progress = (progress + 4 * dt / period) % 1;
    final previousAngleSign = fanState.angle.value.sign;
    fanState.angle.value = calculateAngle(progress);
    final newAngleSign = fanState.angle.value.sign;
    if (previousAngleSign != newAngleSign) {
      // If we crossed zero, round to zero to prevent overshoot
      progress = 0;
      fanState.angle.value = 0;
    }
  }

  @visibleForTesting
  static void headTowardsCenter() {
    if (progress < 0.25) {
      progress = 0.5 - progress;
    } else if (0.5 < progress && progress < 0.75) {
      progress = 1.5 - progress;
    }
  }
}
