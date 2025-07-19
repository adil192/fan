import 'dart:math';

import 'package:fan/data/fan_state.dart';
import 'package:fan/data/tint_matrix.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const _gameSize = Size(1219, 1230);

class AnimatedFan extends StatefulWidget {
  const AnimatedFan({super.key});

  @override
  State<AnimatedFan> createState() => _AnimatedFanState();

  static Future<void> loadAssets() async {
    await Flame.images.loadAll([
      for (final frame in _FanSpriteFrame.values) frame.path,
    ]);
  }
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
    angle = fanState.angle.value;
    super.update(dt);
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
      Sprite.load(_FanSpriteFrame.fanOn1.path),
      Sprite.load(_FanSpriteFrame.fanOn2.path),
      Sprite.load(_FanSpriteFrame.fanOn3.path),
      Sprite.load(_FanSpriteFrame.fanOn4.path),
      Sprite.load(_FanSpriteFrame.fanOn5.path),
      Sprite.load(_FanSpriteFrame.fanOn6.path),
    ]);
    final fanOffSpriteList = await Future.wait([
      Sprite.load(_FanSpriteFrame.fanOff.path),
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

enum _FanSpriteFrame {
  fanOn1('fan-assets/fan_head_no_cover_01.png'),
  fanOn2('fan-assets/fan_head_no_cover_02.png'),
  fanOn3('fan-assets/fan_head_no_cover_03.png'),
  fanOn4('fan-assets/fan_head_no_cover_04.png'),
  fanOn5('fan-assets/fan_head_no_cover_05.png'),
  fanOn6('fan-assets/fan_head_no_cover_06.png'),
  fanOff('fan-assets/fan_head_no_cover_off.png');

  const _FanSpriteFrame(this.path);
  final String path;
}
