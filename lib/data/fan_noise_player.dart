import 'dart:async';

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

    _isLoaded = true;
  }

  void update(FanStateEnum state) {
    if (!isLoaded) return;

    player.setPitch(switch (state) {
      FanStateEnum.off || FanStateEnum.low => 0.8,
      FanStateEnum.medium => 1.0,
      FanStateEnum.high => 1.2,
    });
    player.setSpeed(switch (state) {
      FanStateEnum.off || FanStateEnum.low => 0.8,
      FanStateEnum.medium => 1.0,
      FanStateEnum.high => 1.2,
    });

    if (state == FanStateEnum.off) {
      _pause();
    } else {
      _play();
    }
  }

  void _play() {
    _fadeToVolume(1);
  }

  void _pause() {
    _fadeToVolume(0);
  }

  Timer? _volumeTimer;
  void _fadeToVolume(
    double targetVolume, [
    Duration duration = const Duration(seconds: 1),
    int steps = 120,
  ]) {
    assert(
      targetVolume >= 0.0 && targetVolume <= 1.0,
      'targetVolume must be between 0.0 and 1.0',
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
