import 'package:fan/data/stows.dart';
import 'package:material_ui/material_ui.dart';

class const OscillationPeriodText({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exclude semantics as the slider itself has the label
    return ExcludeSemantics(
      child: ValueListenableBuilder(
        valueListenable: stows.oscillationPeriod,
        builder: (context, period, _) {
          return Text(
            '${period}s',
            style: TextTheme.of(context).bodyMedium?.copyWith(
              color: ColorScheme.of(context).onSurface.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
  }
}

class const OscillationPeriodSlider({super.key}) extends StatelessWidget {
  static const minPeriod = 5.0;
  static const maxPeriod = 55.0;
  static const step = 5.0;
  static const divisions = (maxPeriod - minPeriod) ~/ step;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: stows.oscillationPeriod,
      builder: (context, _, _) {
        return Slider(
          value: stows.oscillationPeriod.value.toDouble(),
          onChanged: (value) => stows.oscillationPeriod.value = value.toInt(),
          semanticFormatterCallback: (value) => '${value.toInt()} seconds',
          min: minPeriod,
          max: maxPeriod,
          divisions: divisions,
        );
      },
    );
  }
}
