import 'dart:async';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter/widgets.dart';

final sleepTimer = SleepTimer._();

class SleepTimer._() extends ChangeNotifier {
  /// A periodic timer that calls [_onTick].
  Timer? _timer;
  bool get active => _timer?.isActive ?? false;
  static const _timerInterval = Duration(minutes: 1);

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
    if (stows.sleepTimerDuration.value <= .zero) return;
    if (!fanState.isOn) return;

    _startTime = DateTime.timestamp();
    _remaining = stows.sleepTimerDuration.value;

    _timer?.cancel();
    _timer = Timer.periodic(_timerInterval, (_) => _onTick());

    notifyListeners();
  }

  /// Stops the sleep timer. Does not stop the fan.
  void cancel() {
    _remaining = .zero;
    _timer?.cancel();
    notifyListeners();
  }

  /// Updates [remaining] and stops the fan at the end.
  void _onTick() {
    assert(fanState.isOn);

    final now = DateTime.timestamp();
    final elapsed = now.difference(_startTime);
    assert(elapsed >= .zero);
    final remaining = stows.sleepTimerDuration.value - elapsed;

    if (remaining <= .zero) {
      cancel();
      fanState.isOn = false;
    } else {
      this.remaining = remaining;
    }
  }
}
