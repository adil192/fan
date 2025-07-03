import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/fan_controls.dart';
import 'package:fan/components/theme_picker.dart';
import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fanState = FanState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ThemePicker(),
          Expanded(child: AnimatedFan(fanState: fanState)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
            child: FanControls(fanState: fanState),
          ),
        ],
      ),
    );
  }
}
