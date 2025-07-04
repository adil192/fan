import 'dart:math';

import 'package:fan/components/themed_app.dart';
import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter/material.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: min(12, MediaQuery.widthOf(context) * 0.01),
        children: [
          for (final accent in Accent.values)
            ListenableBuilder(
              listenable: stows.accentColor,
              builder: (context, _) {
                return Expanded(child: ThemePickerButton(accent: accent));
              },
            ),
        ],
      ),
    );
  }
}

class ThemePickerButton extends StatefulWidget {
  const ThemePickerButton({super.key, required this.accent});

  final Accent accent;

  @override
  State<ThemePickerButton> createState() => _ThemePickerButtonState();
}

class _ThemePickerButtonState extends State<ThemePickerButton> {
  static const height = 48.0;
  late final theme = ThemedApp.getTheme(widget.accent.color);

  @override
  Widget build(BuildContext context) {
    final active = stows.accentColor.value == widget.accent.color;

    return Theme(
      data: theme,
      child: Tooltip(
        message: 'Set theme to ${widget.accent.name}',
        child: ElevatedButton(
          onPressed: () => stows.accentColor.value = widget.accent.color,
          style: ElevatedButton.styleFrom(
            backgroundColor: active
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(
              borderRadius: active
                  ? BorderRadius.circular(height / 8)
                  : BorderRadius.circular(height / 2),
            ),
          ),
          child: const SizedBox(width: double.infinity, height: height),
        ),
      ),
    );
  }
}
