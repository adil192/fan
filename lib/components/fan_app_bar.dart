import 'package:fan/components/battery_optimization_button.dart';
import 'package:fan/pages/settings_dialog.dart';
import 'package:flutter/material.dart';

class FanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FanAppBar({super.key});

  static const buttonWidth = 72.0;
  static const buttonHeight = 56.0;
  static const buttonMargin = 8.0;
  static const appBarHeight = buttonHeight + buttonMargin * 2;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      minimumSize: const Size(buttonWidth, buttonHeight),
      iconSize: buttonHeight / 2,
    );
    return AppBar(
      toolbarHeight: appBarHeight,
      actionsPadding: const EdgeInsets.all(buttonMargin),
      actions: [
        BatteryOptimizationButton(style: buttonStyle),
        const SizedBox(width: buttonMargin),
        IconButton.filled(
          key: const Key('settings_button'),
          style: buttonStyle,
          icon: const Icon(Icons.settings),
          onPressed: () {
            SettingsDialog.show(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
