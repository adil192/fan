import 'dart:math';

import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/fan_state.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows._();

class Stows._() {
  static var volatile = true;
  static void enablePersistence() => volatile = false;

  final accentColor = PlainStow(
    'accent',
    Accent.red.color,
    codec: const ColorCodec(),
    volatile: volatile,
  );

  final lastFanState = PlainStow.json(
    'lastFanState',
    fanState,
    fromJson: (json) => FanState.fromJson(json as Map<String, dynamic>),
    volatile: volatile,
  );

  /// The time taken in seconds to oscillate/rotate
  /// from one side to the other and back again.
  final oscillationPeriod = PlainStow(
    'oscillationPeriod',
    30,
    volatile: volatile,
  );

  /// The maximum angle in radians that the fan can reach when oscillating.
  ///
  /// The fan will oscillate between -angle and +angle.
  ///
  /// This is expected to be between 0 and pi/2 (90 degrees).
  ///
  /// The default is pi/4 (45 degrees).
  final oscillationAngle = PlainStow(
    'oscillationAngle',
    pi / 4,
    volatile: volatile,
  );

  /// The sleep timer duration.
  /// When the timer finishes, the fan will be turned off.
  ///
  /// Set to zero if the user does not want to use the sleep timer feature.
  /// Conversely, if non-zero, the timer should start when turning on the fan.
  final sleepTimerDuration = PlainStow(
    'timerTotal',
    Duration.zero,
    volatile: volatile,
    codec: DelegateCodec<Duration, int>(
      encode: (duration) => duration.inMilliseconds,
      decode: (ms) => Duration(milliseconds: ms),
    ),
  );
}
