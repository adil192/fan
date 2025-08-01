import 'dart:math';

import 'package:fan/data/oscillator.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Oscillator range', () {
    for (final maxDegrees in const [5, 45, 85]) {
      group('between ±$maxDegrees°', () {
        final maxRadians = maxDegrees * pi / 180;
        setUp(() {
          stows.oscillationAngle.value = maxRadians;
        });

        test('at 0 time', () {
          expect(Oscillator.calculateAngle(0 / 4), moreOrLessEquals(0));
        });
        test('at quarter time', () {
          expect(
            Oscillator.calculateAngle(1 / 4),
            moreOrLessEquals(maxRadians),
          );
        });
        test('at half time', () {
          expect(Oscillator.calculateAngle(2 / 4), moreOrLessEquals(0));
        });
        test('at three quarters time', () {
          expect(
            Oscillator.calculateAngle(3 / 4),
            moreOrLessEquals(-maxRadians),
          );
        });
        test('at full time', () {
          expect(Oscillator.calculateAngle(4 / 4), moreOrLessEquals(0));
        });
      });
    }
  });
}
