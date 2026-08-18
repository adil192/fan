import 'package:fan/data/fan_state.dart';
import 'package:fan/data/sleep_timer.dart';
import 'package:fan/data/stows.dart';
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
    final timerTotal = useListenable(stows.sleepTimerDuration);
    useListenable(sleepTimer);
    useListenableSelector(fanState, () => fanState.isOn);

    final expansibleController = useExpansibleController();
    useListenableSelector(
      expansibleController,
      () => expansibleController.isExpanded,
    );

    // Use normal bg when expanded to help with contrast.
    final boldColors = sleepTimer.active && !expansibleController.isExpanded;

    final theme = Theme.of(context);
    const height = 48.0;
    final textStyle = theme.textTheme.bodyLarge!.copyWith(
      color: boldColors
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSecondaryContainer,
    );
    final verticalPadding =
        (height - textStyle.fontSize! * textStyle.height!) / 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 480,
      decoration: BoxDecoration(
        color: boldColors
            ? theme.colorScheme.primary
            : theme.colorScheme.secondaryContainer,
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
                    if (sleepTimer.active) {
                      return Center(
                        key: const ValueKey('timerRemainingDuration'),
                        child: Text(formatDuration(sleepTimer.remaining)),
                      );
                    } else if (timerTotal.value <= .zero) {
                      return const Center(
                        key: ValueKey('timerDisabled'),
                        child: Text('Timer disabled'),
                      );
                    } else {
                      return Center(
                        key: const ValueKey('timerTotalDuration'),
                        child: Text(
                          formatDuration(timerTotal.value),
                          style: const TextStyle(fontStyle: .italic),
                        ),
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
                        min: 0,
                        max: 8,
                        divisions: 8,
                        padding: const .symmetric(vertical: 2),
                        onChanged: sleepTimer.active
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
                        key: ValueKey(sleepTimer.active),
                        onPressed: () {
                          if (sleepTimer.active) {
                            sleepTimer.cancel();
                          } else if (!fanState.isOn) {
                            fanState.isOn = true;
                            expansibleController.collapse();
                          } else {
                            sleepTimer.start();
                            expansibleController.collapse();
                          }
                        },
                        tooltip: sleepTimer.active
                            ? 'Cancel timer'
                            : 'Start timer',
                        icon: sleepTimer.active
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
