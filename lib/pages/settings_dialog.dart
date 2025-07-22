import 'package:fan/components/fan_app_bar.dart';
import 'package:fan/components/theme_picker.dart';
import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/settings'),
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topRight,
      // Slightly less to fully cover the settings button
      insetPadding: const EdgeInsets.all(FanAppBar.buttonMargin * 0.95),
      title: const Text('Settings'),
      content: const ThemePicker(),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
