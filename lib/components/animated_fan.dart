import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

const _gameSize = Size(1219, 1230);

class AnimatedFan extends StatefulWidget {
  const AnimatedFan({super.key});

  @override
  State<AnimatedFan> createState() => _AnimatedFanState();

  static Future<void> loadAssets() async {
    // TODO: Preload 3D model
  }
}

class _AnimatedFanState extends State<AnimatedFan> {
  late final threeJs = three.ThreeJS(
    setup: _setup,
    onSetupComplete: _onSetupComplete,
  );
  _Fan? fan;

  Future<void> _setup() async {
    threeJs.width = _gameSize.width;
    threeJs.height = _gameSize.height;

    threeJs.camera = three.PerspectiveCamera(
      45,
      threeJs.width / threeJs.height,
    );
    threeJs.camera.position.setValues(3, 6, 10);

    threeJs.scene = three.Scene();
    threeJs.scene.add(threeJs.camera);
    threeJs.camera.lookAt(threeJs.scene.position);

    final ambientLight = three.AmbientLight();
    threeJs.scene.add(ambientLight);

    final pointLight = three.PointLight(0xffffff, 0.3);
    pointLight.position.setValues(0, 0, 0);
    threeJs.camera.add(pointLight);

    final loader = three.GLTFLoader();

    final fanGlb = await loader.fromAsset('assets/fan.glb');
    fan = _Fan(fanGlb!.scene, fanGlb.animations!, fanState);
    threeJs.scene.add(fanGlb.scene..scale.setValues(0.3, 0.3, 0.3));

    threeJs.addAnimationEvent((dt) {
      fan?.update(dt);
    });
  }

  void _onSetupComplete() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    threeJs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // game.fanColor = ColorScheme.of(context).primary;
    return IgnorePointer(
      child: FittedBox(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: _gameSize.width,
          height: _gameSize.height,
          child: threeJs.build(),
        ),
      ),
    );
  }
}

class _Fan {
  _Fan(this.object, this.animations, this.fanState) {
    mixer = three.AnimationMixer(object);

    final animation = mixer.clipAction(animations[0])!;
    animation
      ..enabled = true
      ..setEffectiveTimeScale(1)
      ..setEffectiveWeight(1)
      ..play();
  }

  final three.Object3D object;
  final List animations;
  final FanState fanState;
  late final three.AnimationMixer mixer;

  void update(double dt) {
    mixer.update(dt);
  }
}
