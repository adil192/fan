import 'dart:math';

import 'package:fan/components/themed_app.dart';
import 'package:fan/data/accent_colors.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: min(12, MediaQuery.sizeOf(context).width * 0.01),
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

class ThemePickerButton extends HookWidget {
  const ThemePickerButton({super.key, required this.accent});

  final Accent accent;

  @override
  Widget build(BuildContext context) {
    final theme = useMemoized(() => ThemedApp.getTheme(accent.color), [accent]);

    const height = 48.0;
    final active = stows.accentColor.value == accent.color;

    return Theme(
      data: theme,
      child: Tooltip(
        message: 'Set theme to ${accent.name}',
        child: ElevatedButton(
          onPressed: () => stows.accentColor.value = accent.color,
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
