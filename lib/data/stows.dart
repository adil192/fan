import 'dart:math';

import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/fan_state.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows._();

class Stows {
  static bool volatile = true;
  static void enablePersistence() => volatile = false;

  Stows._();

  final accentColor = PlainStow(
    'accent',
    Accent.red.color,
    codec: ColorCodec(),
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
}
