import 'package:fan/components/fan_app_bar.dart';
import 'package:fan/components/oscillation_period.dart';
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
      // Align dialog to cover the settings button
      insetPadding: const EdgeInsets.all(FanAppBar.buttonMargin * 0.95),
      alignment: Alignment.topRight,
      title: const Text('Settings'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSubtitle('Theme'),
            ThemePicker(),

            _SettingsSubtitle(
              'Oscillation time',
              trailing: OscillationPeriodText(),
            ),
            OscillationPeriodSlider(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/credits'),
          child: const Text('Credits'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _SettingsSubtitle extends StatelessWidget {
  const _SettingsSubtitle(this.text, {this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(text, style: TextTheme.of(context).titleMedium)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
