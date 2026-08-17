import 'package:fan/data/fan_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class const FanControls({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: const Column(spacing: 16, children: [_TimerBar(), _MainRow()]),
      ),
    );
  }
}

class const _TimerBar() extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Fake data while I build the UI
    final timerTotal = useState(const Duration(hours: 4));
    final timerRemaining = useState(const Duration(hours: 3, minutes: 30));
    final timerActive =
        timerTotal.value > Duration.zero &&
        timerRemaining.value > Duration.zero;

    final expansibleController = useExpansibleController();

    final theme = Theme.of(context);
    const height = 48.0;
    final textStyle = theme.textTheme.bodyLarge!;
    final verticalPadding =
        (height - textStyle.fontSize! * textStyle.height!) / 2;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: const .all(.circular(height / 2)),
      ),
      child: DefaultTextStyle(
        style: textStyle,
        child: InkWell(
          onTap: () => expansibleController.toggle(),
          borderRadius: const .all(.circular(height / 2)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Expansible(
              headerBuilder: (context, animation) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: () {
                    if (timerActive) {
                      return Center(
                        key: const ValueKey('timerRemainingDuration'),
                        child: Text(formatDuration(timerRemaining.value)),
                      );
                    } else if (expansibleController.isExpanded) {
                      return Center(
                        key: const ValueKey('timerTotalDuration'),
                        child: Text(
                          formatDuration(timerTotal.value),
                          style: const TextStyle(fontStyle: .italic),
                        ),
                      );
                    } else {
                      return const Center(
                        key: ValueKey('timerInactive'),
                        child: Text('Timer inactive'),
                      );
                    }
                  }(),
                );
              },
              bodyBuilder: (context, animation) {
                return Row(
                  mainAxisAlignment: .center,
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: Slider(
                        value:
                            timerTotal.value.inMicroseconds /
                            Duration.microsecondsPerHour,
                        min: 1,
                        max: 8,
                        divisions: 7,
                        padding: const .symmetric(vertical: 2),
                        onChanged: timerActive
                            ? null
                            : (value) {
                                timerTotal.value = Duration(
                                  hours: value.round(),
                                );
                              },
                      ),
                    ),
                    const SizedBox(width: 36),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: IconButton(
                        key: ValueKey(timerActive),
                        onPressed: () {
                          if (timerActive) {
                            // Stop timer
                            timerRemaining.value = Duration.zero;
                          } else {
                            // Start timer
                            timerRemaining.value = timerTotal.value * 0.7;
                          }
                        },
                        icon: timerActive
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.play_arrow),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                );
              },
              controller: expansibleController,
            ),
          ),
        ),
      ),
    );
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inMicroseconds ~/ Duration.microsecondsPerHour;
    final minutes =
        (duration.inMicroseconds % Duration.microsecondsPerHour) ~/
        Duration.microsecondsPerMinute;
    return '${hours}h ${minutes}m';
  }
}

class const _MainRow() extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(fanState);
    return Row(
      spacing: 16,
      children: [
        Expanded(
          flex: 2,
          child: _FanControlsButton(
            onPressed: () => fanState.oscillate = !fanState.oscillate,
            active: fanState.oscillate,
            tooltip: 'Oscillate',
            icon: const Icon(Icons.threesixty),
          ),
        ),
        Expanded(
          flex: 3,
          child: _FanControlsButton(
            onPressed: () => fanState.isOn = !fanState.isOn,
            active: fanState.isOn,
            tooltip: fanState.isOn ? 'Turn off fan' : 'Turn on fan',
            icon: fanState.isOn
                ? const Icon(Symbols.mode_fan)
                : const Icon(Symbols.mode_fan_off),
          ),
        ),
        Expanded(
          flex: 2,
          child: _FanControlsButton(
            onPressed: () => fanState.speed = switch (fanState.speed) {
              FanSpeed.low => FanSpeed.medium,
              FanSpeed.medium => FanSpeed.high,
              FanSpeed.high => FanSpeed.low,
            },
            active: fanState.isOn,
            tooltip: 'Fan speed',
            icon: Text(switch (fanState.speed) {
              FanSpeed.low => '1',
              FanSpeed.medium => '2',
              FanSpeed.high => '3',
            }),
          ),
        ),
      ],
    );
  }
}

class const _FanControlsButton({
  required final VoidCallback? onPressed,
  final bool active = false,
  final String? tooltip,
  required final Widget icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      color: active
          ? ColorScheme.of(context).onPrimary
          : ColorScheme.of(context).onSecondaryContainer,
    );

    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 48,
          minimumSize: const Size(48, 48 * 3),
          foregroundColor: textStyle.color,
        ),
      ),
      child: active
          ? IconButton.filled(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              icon: DefaultTextStyle.merge(style: textStyle, child: icon),
              tooltip: tooltip,
            )
          : IconButton.filledTonal(
              onPressed: onPressed,
              icon: DefaultTextStyle.merge(style: textStyle, child: icon),
              tooltip: tooltip,
            ),
    );
  }
}
