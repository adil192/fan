import 'dart:math';

import 'package:fan/data/stows.dart';
import 'package:material_ui/material_ui.dart';

class const OscillationAngleText({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exclude semantics as the slider itself has the label
    return ExcludeSemantics(
      child: ValueListenableBuilder(
        valueListenable: stows.oscillationAngle,
        builder: (context, radians, _) {
          final degrees = (radians * (180 / pi)).round();
          return Text(
            '±$degrees°',
            style: TextTheme.of(context).bodyMedium?.copyWith(
              color: ColorScheme.of(context).onSurface.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
  }
}

class const OscillationAngleSlider({super.key}) extends StatelessWidget {
  static const oneDegree = pi / 180; // 1° converted to radians
  static const step = 5 * oneDegree;
  static const minAngle = 5 * oneDegree;
  static const maxAngle = 85 * oneDegree;
  static const divisions = (maxAngle - minAngle) ~/ step;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: stows.oscillationAngle,
      builder: (context, _, _) {
        return Slider(
          value: stows.oscillationAngle.value,
          onChanged: (value) => stows.oscillationAngle.value = value,
          semanticFormatterCallback: (value) {
            final degrees = (value * (180 / pi)).round();
            return '$degrees degrees';
          },
          min: minAngle,
          max: maxAngle,
          divisions: divisions,
        );
      },
    );
  }
}
