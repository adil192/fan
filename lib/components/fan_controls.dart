import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FanControls extends StatelessWidget {
  const FanControls({super.key, required this.fanState});

  final FanState fanState;

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 48,
          minimumSize: const Size(0, 48 * 3),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ListenableBuilder(
            listenable: fanState,
            builder: (context, _) {
              return Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.abc),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: fanState.isOn
                        ? IconButton.filled(
                            onPressed: () => fanState.isOn = false,
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            icon: const Icon(Symbols.mode_fan),
                            tooltip: 'Turn off fan',
                          )
                        : IconButton.filledTonal(
                            onPressed: () => fanState.isOn = true,
                            icon: const Icon(Symbols.mode_fan_off),
                            tooltip: 'Turn on fan',
                          ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.abc),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
