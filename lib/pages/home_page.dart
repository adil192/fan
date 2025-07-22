import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/fan_app_bar.dart';
import 'package:fan/components/fan_controls.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FanAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
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
