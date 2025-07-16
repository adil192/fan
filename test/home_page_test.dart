import 'dart:math';

import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/themed_app.dart';
import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/fan_state.dart';
import 'package:fan/data/stows.dart';
import 'package:fan/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomePage', () {
    final targetFanState = FanState()
      ..isOn = false
      ..oscillate = true
      ..speed = FanSpeed.medium
      ..angle.value = -pi / 8;
    SharedPreferences.setMockInitialValues({});

    for (final accent in Accent.values) {
      testGoldens(accent.name, (tester) async {
        fanState.copyFrom(targetFanState);
        stows.accentColor.value = accent.color;

        final widget = _HomeApp();
        await tester.pumpWidget(widget);

        await tester.loadFonts();
        await tester.precacheTopbarImages();
        await tester.runAsync(AnimatedFan.loadAssets);
        await tester.pumpFrames(widget, const Duration(seconds: 1));

        await expectLater(
          find.byType(HomePage),
          matchesGoldenFile(
            'goldens/home_page_${accent.index}_${accent.name}.png',
          ),
        );
      });
    }
  });
}

class _HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenshotApp(
      device: GoldenScreenshotDevices.android.device,
      theme: ThemedApp.getTheme(stows.accentColor.value),
      child: const HomePage(),
    );
  }
}
