import 'package:flutter/material.dart';

class FanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FanAppBar({super.key});

  static const buttonWidth = 72.0;
  static const buttonHeight = 56.0;
  static const buttonMargin = 8.0;
  static const appBarHeight = buttonHeight + buttonMargin * 2;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: appBarHeight,
      actionsPadding: const EdgeInsets.all(buttonMargin),
      actions: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
            foregroundColor: ColorScheme.of(context).onPrimary,
            minimumSize: const Size(buttonWidth, buttonHeight),
            iconSize: buttonHeight / 2,
          ),
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Go to settings
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
