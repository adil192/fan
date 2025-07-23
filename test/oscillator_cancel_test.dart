import 'package:fan/data/oscillator.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Oscillator headTowardsCenter', () {
    const period = 100;
    stows.oscillationPeriod.value = period;
    assert(Oscillator.period == period);

    for (final originalProgress in const [
      0.0,
      0.1,
      0.25,
      0.35,
      0.5,
      0.6,
      0.75,
      0.85,
      1.0,
    ]) {
      test('progress: $originalProgress', () {
        Oscillator.progress = originalProgress;

        Oscillator.headTowardsCenter();
        final newProgress = Oscillator.progress;
        printOnFailure('headTowardsCenter: $originalProgress -> $newProgress');

        expect(newProgress, inInclusiveRange(0, 1));

        final originalAngle = Oscillator.calculateAngle(originalProgress);
        final newAngle = Oscillator.calculateAngle(newProgress);
        final nextAngle = Oscillator.calculateAngle(newProgress + 0.01);

        expect(
          originalAngle,
          moreOrLessEquals(newAngle),
          reason: 'Angle should remain the same, only direction is reversed',
        );

        if (newAngle.abs() > 0.001) {
          // If not already at center, next angle should be closer to center
          expect(
            nextAngle.abs(),
            lessThanOrEqualTo(newAngle.abs()),
            reason: 'Should be heading towards center',
          );
        }
      });
    }
  });
}
