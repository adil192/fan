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
}
