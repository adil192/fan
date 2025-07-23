import 'package:fan/components/themed_app.dart';
import 'package:fan/data/accent_colors.dart';
import 'package:fan/main.dart';
import 'package:fan/pages/credits_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

void main() {
  group('CreditsPage', () {
    testGoldens('start', (tester) async {
      final widget = _CreditsApp();
      await tester.pumpWidget(widget);

      await tester.loadFonts();
      await tester.precacheTopbarImages();
      await tester.pumpFrames(widget, const Duration(seconds: 1));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/credits_page.png'),
      );
    });

    testGoldens('licenses', (tester) async {
      addAssetLicenses();
      LicenseRegistry.addLicense(() async* {
        yield const LicenseEntryWithLineBreaks([
          'example_package',
        ], 'This is an example license for testing purposes.');
        yield const LicenseEntryWithLineBreaks([
          'example_package',
        ], 'This is a second license for testing purposes.');
      });

      final widget = _CreditsApp();
      await tester.pumpWidget(widget);

      await tester.tap(find.text('View all licenses'));

      await tester.loadFonts();
      await tester.precacheTopbarImages();
      await tester.pumpFrames(widget, const Duration(seconds: 1));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/licenses_page.png'),
      );
    });
  });
}

class _CreditsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenshotApp(
      device: GoldenScreenshotDevices.android.device,
      theme: ThemedApp.getTheme(Accent.values.first.color),
      child: const CreditsPage(),
    );
  }
}
