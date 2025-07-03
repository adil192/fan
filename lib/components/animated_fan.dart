import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/tint_matrix.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const _gameSize = Size(1230, 1219);

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
    return FittedBox(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: _gameSize.width,
        height: _gameSize.height,
        child: GameWidget(game: game),
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
    _fan.updateColorFilter(_fanColor);
  }

  @override
  Future<void> onLoad() async {
    add(_fan);
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

class _FanComponent extends SpriteAnimationComponent
    with HasGameReference<_FanGame> {
  _FanComponent(this.fanState)
    : super(
        size: _gameSize.toVector2(),
        paint: Paint()..filterQuality = FilterQuality.medium,
        anchor: Anchor.center,
        position: _gameSize.toVector2() / 2,
        angle: pi / 2, // face up
      );

  final FanState fanState;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.spriteList(
      await Future.wait([
        Sprite.load('fan-assets/fan_head_no_cover_01.png'),
        Sprite.load('fan-assets/fan_head_no_cover_02.png'),
        Sprite.load('fan-assets/fan_head_no_cover_03.png'),
        Sprite.load('fan-assets/fan_head_no_cover_04.png'),
        Sprite.load('fan-assets/fan_head_no_cover_05.png'),
        Sprite.load('fan-assets/fan_head_no_cover_06.png'),
        // Sprite.load('fan-assets/fan_head_no_cover_off.png'),
      ]),
      stepTime: 1 / 10,
    );
    updateColorFilter(game.fanColor);
  }

  void updateColorFilter(Color fanColor) {
    paint.colorFilter = ColorFilter.matrix(getTintMatrix(fanColor));
  }
}
