import 'dart:async';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter/widgets.dart';

final sleepTimer = SleepTimer._();

class SleepTimer._() extends ChangeNotifier {
  /// A periodic timer that executes every minute.
  Timer? _minuteTimer;

  /// When this timer was [start]ed, in UTC time.
  var _startTime = DateTime(1970);

  /// The time remaining until the sleep timer will stop the fan.
  Duration get remaining => _remaining;
  Duration _remaining = .zero;
  set remaining(Duration remaining) {
    if (remaining == _remaining) return;
    _remaining = remaining;
    notifyListeners();
  }

  /// Starts the sleep timer. Does not start the fan.
  void start() {
    _startTime = DateTime.timestamp();

    _minuteTimer?.cancel();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) => _onTick());
  }

  /// Stops the sleep timer. Does not stop the fan.
  void cancel() {
    remaining = .zero;
    _minuteTimer?.cancel();
  }

  /// Updates [remaining] and stops the fan at the end.
  void _onTick() {
    assert(fanState.isOn);

    final now = DateTime.timestamp();
    final elapsed = now.difference(_startTime);
    final remaining = stows.sleepTimerDuration.value - elapsed;

    if (remaining <= .zero) {
      cancel();
      fanState.isOn = false;
    } else {
      this.remaining = remaining;
    }
  }
}
