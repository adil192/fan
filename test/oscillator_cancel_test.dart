import 'package:fan/data/oscillator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Oscillator headTowardsCenter', () {
    const period = Oscillator.period;
    for (final t in const [0.0, 0.1, 0.25, 0.35, 0.5, 0.6, 0.75, 0.85, 1.0]) {
      final elapsed = period * t;
      test('elapsed: $elapsed', () {
        Oscillator.elapsed = elapsed;
        Oscillator.headTowardsCenter();
        final newElapsed = Oscillator.elapsed;
        printOnFailure(
          'headTowardsCenter: ${elapsed}s ($t) -> '
          '${newElapsed}s (${newElapsed / period})',
        );

        expect(newElapsed, inInclusiveRange(0.0, period));

        final originalAngle = Oscillator.calculateAngle(elapsed);
        final newAngle = Oscillator.calculateAngle(newElapsed);
        final nextAngle = Oscillator.calculateAngle(newElapsed + 0.1);

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
