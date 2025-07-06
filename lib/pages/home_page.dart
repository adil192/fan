import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/fan_controls.dart';
import 'package:fan/components/theme_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemePicker(),
            Expanded(child: AnimatedFan()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
              child: FanControls(),
            ),
          ],
        ),
      ),
    );
  }
}
