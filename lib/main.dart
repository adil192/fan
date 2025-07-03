import 'package:fan/components/themed_app.dart';
import 'package:fan/data/fan_noise_player.dart';
import 'package:fan/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await fanNoisePlayer.init();

  _addLicenses();
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemedApp(title: 'Fan', home: HomePage());
  }
}
