// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:fan/data/oscillator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

void main() {
  group('Curve', () {
    test('At 0 time', () {
      expect(Oscillator.curve(Oscillator.period / 4 * 0), moreOrLessEquals(0));
    });
    test('At quarter time', () {
      expect(Oscillator.curve(Oscillator.period / 4 * 1), moreOrLessEquals(1));
    });
    test('At half time', () {
      expect(Oscillator.curve(Oscillator.period / 4 * 2), moreOrLessEquals(0));
    });
    test('At three quarters time', () {
      expect(Oscillator.curve(Oscillator.period / 4 * 3), moreOrLessEquals(-1));
    });
    test('At full time', () {
      expect(Oscillator.curve(Oscillator.period / 4 * 4), moreOrLessEquals(0));
    });

    testGoldens('Chart', (tester) async {
      const device = ScreenshotDevice(
        platform: TargetPlatform.android,
        resolution: Size(628, 300),
        pixelRatio: 1,
        goldenSubFolder: 'curve',
        frameBuilder: ScreenshotFrame.noFrame,
      );
      await tester.pumpWidget(
        ScreenshotApp(
          device: device,
          child: CustomPaint(
            painter: _ChartPainter(),
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/curve.png'),
      );
    });
  });
}

class _ChartPainter extends CustomPainter {
  double f(double t) {
    return Oscillator.curve(t * Oscillator.period);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const samples = 100;
    final path_f = Path()..moveTo(0, 0.5 * size.height);
    final path_sin = Path()..moveTo(0, 0.5 * size.height);
    for (var i = 0; i <= samples; i++) {
      final t = i / samples;
      final x = t * size.width;
      final y_f = size.height * (0.5 + f(t) / 2);
      final y_sin = size.height * (0.5 + sin(t * 2 * pi) / 2);
      path_f.lineTo(x, y_f);
      path_sin.lineTo(x, y_sin);
    }
    canvas.drawPath(
      path_sin,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path_f,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
