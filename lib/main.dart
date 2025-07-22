import 'dart:async';

import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/themed_app.dart';
import 'package:fan/data/fan_noise_player.dart';
import 'package:fan/data/fan_state.dart';
import 'package:fan/data/oscillator.dart';
import 'package:fan/data/stows.dart';
import 'package:fan/pages/home_page.dart';
import 'package:fan/pages/settings_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  unawaited(AnimatedFan.loadAssets());

  await Future.wait([fanNoisePlayer.init(), _loadFanState()]);

  _addLicenses();

  Oscillator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'Fan',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => const SettingsDialog(),
      },
    );
  }
}

void _addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      '_assets_audio',
    ], await rootBundle.loadString('assets/audio/fan_loop.LICENSE'));
  });
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      '_assets_images',
    ], await rootBundle.loadString('assets/images/fan-assets/LICENSE.md'));
  });
}

Future<void> _loadFanState() async {
  await stows.lastFanState.waitUntilRead().then((_) {
    fanState.copyFrom(stows.lastFanState.value);
  });
  fanState.addListener(() {
    stows.lastFanState
      ..value = fanState
      ..notifyListeners();
  });
}
