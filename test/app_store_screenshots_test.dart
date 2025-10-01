import 'dart:async';
import 'dart:math';

import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/themed_app.dart';
import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/fan_state.dart';
import 'package:fan/pages/credits_page.dart';
import 'package:fan/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

void main() {
  group('App store screenshots', () {
    final theme = ThemedApp.getTheme(Accent.values.first.color);

    screenshot(
      name: '1_home',
      runApp: (tester, device) async {
        await tester.pumpWidget(
          ScreenshotApp(device: device, theme: theme, home: const HomePage()),
        );
      },
    );

    screenshot(
      name: '2_settings',
      runApp: (tester, device) async {
        await tester.pumpWidget(
          ScreenshotApp(device: device, theme: theme, home: const HomePage()),
        );
        await tester.tap(find.byKey(const Key('settings_button')));
      },
    );

    screenshot(
      name: '3_credits',
      runApp: (tester, device) async {
        await tester.pumpWidget(
          ScreenshotApp(
            device: device,
            theme: theme,
            home: const CreditsPage(),
          ),
        );
      },
    );
  });
}

void screenshot({
  required String name,
  required FutureOr<void> Function(WidgetTester, ScreenshotDevice) runApp,
}) {
  group(name, () {
    for (final goldenDevice in GoldenScreenshotDevices.values) {
      testGoldens('for ${goldenDevice.name}', (tester) async {
        final device = goldenDevice.device;
        fanState.copyFrom(
          FanState()
            ..isOn = false
            ..oscillate = true
            ..speed = FanSpeed.medium
            ..angle.value = -pi / 8,
        );

        await runApp(tester, device);

        await tester.precacheImagesInWidgetTree();
        await tester.runAsync(AnimatedFan.loadAssets);
        await tester.loadFonts();

        final app = tester.widget(find.byType(ScreenshotApp));
        await tester.pumpFrames(app, const Duration(seconds: 1));

        await tester.expectScreenshot(device, name);
      });
    }
  });
}
