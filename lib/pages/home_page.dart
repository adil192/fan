import 'package:fan/components/animated_fan.dart';
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
      appBar: AppBar(title: const Text('Fan')),
      body: Center(child: AnimatedFan(fanState: fanState)),
    );
  }
}
