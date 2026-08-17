import 'package:fan/components/animated_fan.dart';
import 'package:fan/components/fan_app_bar.dart';
import 'package:fan/components/fan_controls.dart';
import 'package:material_ui/material_ui.dart';

class const HomePage({super.key}) extends StatelessWidget {
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
