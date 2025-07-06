import 'dart:async';
import 'dart:ui';

import 'package:fan/data/fan_state.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

final fanNoisePlayer = FanNoisePlayer();

@visibleForTesting
class FanNoisePlayer {
  late final player = AudioPlayer()
    ..setLoopMode(LoopMode.one)
    ..setVolume(0);
  late final Duration duration;

  bool get isLoaded => _isLoaded;
  bool _isLoaded = false;

  Future<void> init() async {
    JustAudioMediaKit.ensureInitialized();

    duration =
        await player.setAsset('assets/audio/fan_loop.m4a') ??
        const Duration(seconds: 57);

    fanState.addListener(_update);
    fanState.angle.addListener(_update);

    _isLoaded = true;
  }

  void _update() {
    if (!isLoaded) return;

    player.setPitch(switch (fanState) {
      FanState(isOn: false) => 0.8,
      FanState(speed: FanSpeed.low) => 0.8,
      FanState(speed: FanSpeed.medium) => 1.0,
      FanState(speed: FanSpeed.high) => 1.2,
    });
    player.setSpeed(switch (fanState) {
      FanState(isOn: false) => 0.8,
      FanState(speed: FanSpeed.low) => 0.8,
      FanState(speed: FanSpeed.medium) => 1.0,
      FanState(speed: FanSpeed.high) => 1.2,
    });

    if (fanState.isOn) {
      _play();
    } else {
      _pause();
    }
  }

  void _play() {
    final targetVolume = lerpDouble(
      0.4,
      1.0,
      1 - fanState.angle.value.abs() / FanState.maxAngle,
    )!;
    _fadeToVolume(targetVolume);
  }

  void _pause() {
    _fadeToVolume(0);
  }

  Timer? _volumeTimer;
  bool get isFadingVolume => _volumeTimer?.isActive ?? false;
  void _fadeToVolume(
    double targetVolume, [
    Duration duration = const Duration(seconds: 1),
    int steps = 120,
  ]) {
    assert(
      targetVolume >= 0.0 && targetVolume <= 1.0,
      'targetVolume must be between 0.0 and 1.0, got $targetVolume',
    );
    assert(isLoaded, 'Player must be loaded before fading volume');
    if (player.volume == targetVolume) return;

    final increment = (targetVolume - player.volume) / steps;

    _volumeTimer?.cancel();
    _volumeTimer = Timer.periodic(duration ~/ steps, (_) {
      final newVolume = player.volume + increment;
      if ((increment > 0 && newVolume >= targetVolume) ||
          (increment < 0 && newVolume <= targetVolume)) {
        _volumeTimer?.cancel();
        player.setVolume(targetVolume);
        if (targetVolume <= 0) {
          player.pause();
        } else {
          player.play();
        }
      } else {
        player.setVolume(newVolume);
        player.play();
      }
    });

    player.play();
  }
}
