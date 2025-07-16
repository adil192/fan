import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/tint_matrix.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const _gameSize = Size(1219, 1230);

class AnimatedFan extends StatefulWidget {
  const AnimatedFan({super.key});

  @override
  State<AnimatedFan> createState() => _AnimatedFanState();
}

class _AnimatedFanState extends State<AnimatedFan> {
  late final game = _FanGame();

  @override
  Widget build(BuildContext context) {
    game.fanColor = ColorScheme.of(context).primary;
    return IgnorePointer(
      child: FittedBox(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: _gameSize.width,
          height: _gameSize.height,
          child: GameWidget(game: game),
        ),
      ),
    );
  }
}

class _FanGame extends FlameGame {
  Color get fanColor => _fanColor;
  Color _fanColor = Colors.black;
  set fanColor(Color fanColor) {
    if (_fanColor == fanColor) return;
    _fanColor = fanColor;
    _fan.sprite.updateColorFilter(_fanColor);
  }

  late final _fan = FanComponent();

  @override
  Future<void> onLoad() async {
    add(_fan);
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

@visibleForTesting
class FanComponent extends PositionComponent {
  FanComponent()
    : super(
        size: _gameSize.toVector2(),
        anchor: const Anchor(0.5, 0.8),
        position: Vector2(_gameSize.width * 0.5, _gameSize.height * 0.8),
      ) {
    add(sprite);
  }

  late final sprite = _FanSprite(fanState);

  @override
  void update(double dt) {
    if (fanState.oscillate) {
      _oscillate(dt);
    } else {
      _returnToCenter(dt);
    }
    super.update(dt);
  }

  /// The time it takes for the fan to turn left, right, and return to center.
  static const period = 30;
  var elapsed = 0.0;

  void _oscillate(double dt) {
    if (!fanState.isOn) return; // can't move if fan is off

    elapsed = (elapsed + dt) % period;
    angle = _calculateAngle(elapsed);
  }

  double _calculateAngle(double elapsed) {
    final t = FanComponent.curve(elapsed);
    return FanState.maxAngle * t;
  }

  static double curve(double elapsed) {
    final s = sin((elapsed / period) * (2 * pi));
    return s;
  }

  void _returnToCenter(double dt) {
    if (!fanState.isOn) return; // can't move if fan is off

    if (-0.01 < angle && angle < 0.01) {
      angle = 0;
      return;
    } else {
      // oscillate back to center
      final startAngleSign = angle.sign;
      _oscillate(dt);
      if (angle.sign != startAngleSign) {
        // overshot center, so reset angle to 0
        angle = 0;
      }
    }
  }

  @override
  set angle(double angle) {
    fanState.angle.value = angle;
    super.angle = angle;
  }
}

class _FanSprite extends SpriteAnimationGroupComponent<_FanSpriteAnimation>
    with HasGameReference<_FanGame> {
  _FanSprite(this.fanState)
    : super(
        current: _FanSpriteAnimation.off,
        size: Vector2(_gameSize.height, _gameSize.width), // swapped bc rotated
        paint: Paint()..filterQuality = FilterQuality.medium,
        angle: pi / 2, // face up
        anchor: Anchor.center,
        position: Vector2(_gameSize.height / 2, _gameSize.width / 2),
      );

  final FanState fanState;

  @override
  Future<void> onLoad() async {
    final fanOnSpriteList = await Future.wait([
      Sprite.load('fan-assets/fan_head_no_cover_01.png'),
      Sprite.load('fan-assets/fan_head_no_cover_02.png'),
      Sprite.load('fan-assets/fan_head_no_cover_03.png'),
      Sprite.load('fan-assets/fan_head_no_cover_04.png'),
      Sprite.load('fan-assets/fan_head_no_cover_05.png'),
      Sprite.load('fan-assets/fan_head_no_cover_06.png'),
    ]);
    final fanOffSpriteList = await Future.wait([
      Sprite.load('fan-assets/fan_head_no_cover_off.png'),
    ]);

    animations = {
      _FanSpriteAnimation.off: SpriteAnimation.spriteList(
        fanOffSpriteList,
        stepTime: 1 / 10,
      ),
      _FanSpriteAnimation.low: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 5,
      ),
      _FanSpriteAnimation.medium: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 10,
      ),
      _FanSpriteAnimation.high: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 20,
      ),
    };

    updateColorFilter(game.fanColor);
  }

  @override
  void update(double dt) {
    _updateCurrentAnimation();
    super.update(dt);
  }

  void _updateCurrentAnimation() {
    final _FanSpriteAnimation animation;
    if (!fanState.isOn) {
      animation = _FanSpriteAnimation.off;
    } else {
      animation = switch (fanState.speed) {
        FanSpeed.low => _FanSpriteAnimation.low,
        FanSpeed.medium => _FanSpriteAnimation.medium,
        FanSpeed.high => _FanSpriteAnimation.high,
      };
    }

    if (current != animation) {
      current = animation;
    }
  }

  void updateColorFilter(Color fanColor) {
    paint.colorFilter = ColorFilter.matrix(getTintMatrix(fanColor));
  }
}

enum _FanSpriteAnimation { off, low, medium, high }
