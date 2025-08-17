import 'dart:async';

import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

class BatteryOptimizationButton extends StatefulWidget {
  const BatteryOptimizationButton({super.key, required this.style});

  final ButtonStyle style;

  @override
  State<BatteryOptimizationButton> createState() =>
      _BatteryOptimizationButtonState();
}

class _BatteryOptimizationButtonState extends State<BatteryOptimizationButton> {
  bool? _isBatteryOptimizationDisabled;
  Timer? _reloadTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    _isBatteryOptimizationDisabled =
        await DisableBatteryOptimizationLatest.isBatteryOptimizationDisabled;
    if (mounted) setState(() {});
  }

  Future<void> _request() async {
    if (_isBatteryOptimizationDisabled != false) return;
    await DisableBatteryOptimizationLatest.showDisableBatteryOptimizationSettings();
    if (mounted) setState(() {});

    var secondsPassed = 0;
    _reloadTimer?.cancel();
    _reloadTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      ++secondsPassed;
      await _load();
      if (secondsPassed >= 20 || _isBatteryOptimizationDisabled == true) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isBatteryOptimizationDisabled != false) {
      return const SizedBox();
    }

    final colorScheme = ColorScheme.of(context);
    return IconButton(
      key: const Key('battery_optimization_button'),
      style: widget.style.copyWith(
        backgroundColor: WidgetStatePropertyAll(colorScheme.error),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onError),
        shape: WidgetStatePropertyAll(
          PolygonBorder(polygon: MaterialShapes.verySunny),
        ),
      ),
      icon: const Icon(Icons.battery_saver),
      onPressed: _request,
    );
  }
}

class PolygonBorder extends OutlinedBorder {
  final RoundedPolygon polygon;

  const PolygonBorder({required this.polygon, super.side});

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return polygon.toPath().transform(
      Matrix4.diagonal3Values(rect.width, rect.height, 0).storage,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return polygon.toPath().transform(
      Matrix4.diagonal3Values(
        rect.width - side.width * 2,
        rect.height - side.width * 2,
        0,
      ).storage,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side == BorderSide.none) return;
    final Paint paint = side.toPaint();
    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  PolygonBorder scale(double t) =>
      PolygonBorder(polygon: polygon, side: side.scale(t));

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  PolygonBorder copyWith({RoundedPolygon? polygon, BorderSide? side}) {
    return PolygonBorder(
      polygon: polygon ?? this.polygon,
      side: side ?? this.side,
    );
  }
}
