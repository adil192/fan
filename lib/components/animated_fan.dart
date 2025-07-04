import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/tint_matrix.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const _gameSize = Size(1219, 1230);

class AnimatedFan extends StatefulWidget {
  const AnimatedFan({super.key, required this.fanState});

  final FanState fanState;

  @override
  State<AnimatedFan> createState() => _AnimatedFanState();
}

class _AnimatedFanState extends State<AnimatedFan> {
  late final game = _FanGame(widget.fanState);

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
  _FanGame(this.fanState);

  final FanState fanState;

  late final _fan = _FanComponent(fanState);

  Color get fanColor => _fanColor;
  Color _fanColor = Colors.black;
  set fanColor(Color fanColor) {
    if (_fanColor == fanColor) return;
    _fanColor = fanColor;
    _fan.sprite.updateColorFilter(_fanColor);
  }

  @override
  Future<void> onLoad() async {
    add(_fan);
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

class _FanComponent extends PositionComponent {
  _FanComponent(this.fanState)
    : super(
        size: _gameSize.toVector2(),
        anchor: const Anchor(0.5, 0.8),
        position: Vector2(_gameSize.width / 2, _gameSize.height),
      ) {
    add(sprite);
  }

  final FanState fanState;
  late final sprite = _FanSprite(fanState);

  @override
  void update(double dt) {
    elapsed = (elapsed + dt) % period;
    angle = _calculateAngle(elapsed);
    super.update(dt);
  }

  /// The time it takes for the fan to turn left, right, and return to center.
  static const period = 14;
  var elapsed = 0.0;

  double _calculateAngle(double elapsed) {
    const maxAngle = pi / 4;
    final t = sin(elapsed / period * (2 * pi));
    return maxAngle * t;
  }
}

class _FanSprite extends SpriteAnimationGroupComponent<FanStateEnum>
    with HasGameReference<_FanGame> {
  _FanSprite(this.fanState)
    : super(
        current: FanStateEnum.off,
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
      FanStateEnum.off: SpriteAnimation.spriteList(
        fanOffSpriteList,
        stepTime: 1 / 10,
      ),
      FanStateEnum.low: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 5,
      ),
      FanStateEnum.medium: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 10,
      ),
      FanStateEnum.high: SpriteAnimation.spriteList(
        fanOnSpriteList,
        stepTime: 1 / 20,
      ),
    };

    updateColorFilter(game.fanColor);
  }

  @override
  void update(double dt) {
    final newState = fanState.evaluate();
    if (current != newState) current = newState;

    super.update(dt);
  }

  void updateColorFilter(Color fanColor) {
    paint.colorFilter = ColorFilter.matrix(getTintMatrix(fanColor));
  }
}
