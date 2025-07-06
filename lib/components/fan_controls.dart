import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FanControls extends StatelessWidget {
  const FanControls({super.key, required this.fanState});

  final FanState fanState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: ListenableBuilder(
          listenable: fanState,
          builder: (context, _) {
            return Row(
              spacing: 12,
              children: [
                Expanded(
                  flex: 2,
                  child: _FanControlsButton(
                    onPressed: () {},
                    active: false,
                    icon: const Icon(Icons.abc),
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
                    icon: Text(switch (fanState.speed) {
                      FanSpeed.low => '1',
                      FanSpeed.medium => '2',
                      FanSpeed.high => '3',
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FanControlsButton extends StatelessWidget {
  const _FanControlsButton({
    required this.onPressed,
    this.active = false,
    this.tooltip,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final bool active;
  final String? tooltip;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 32,
      color: active
          ? ColorScheme.of(context).onPrimary
          : ColorScheme.of(context).onSecondaryContainer,
    );

    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 48,
          minimumSize: const Size(48, 48 * 3),
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
