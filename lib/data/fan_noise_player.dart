import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:fan/data/fan_state.dart';
import 'package:fan/data/stows.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

final fanNoisePlayer = FanNoisePlayer();

@visibleForTesting
class FanNoisePlayer {
  late final player = AudioPlayer(useLazyPreparation: false)
    ..setLoopMode(LoopMode.one)
    ..setVolume(0);
  late final Duration duration;

  bool get isLoaded => _isLoaded;
  bool _isLoaded = false;

  Future<void> init() async {
    final audioSession = await AudioSession.instance;
    await audioSession.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
      ),
    );

    JustAudioMediaKit.ensureInitialized();

    duration =
        await player.setAsset('assets/audio/fan_loop.ogg') ??
        const Duration(seconds: 17);

    fanState.addListener(_update);
    fanState.angle.addListener(_update);

    _isLoaded = true;
  }

  void _update() {
    if (!isLoaded) return;

    player.setPitch(switch (fanState) {
      FanState(isOn: false) => 0.8,
      FanState(speed: FanSpeed.low) => 0.9,
      FanState(speed: FanSpeed.medium) => 1.0,
      FanState(speed: FanSpeed.high) => 1.1,
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
    const minVolume = 0.2;
    const maxVolume = 1.0;
    const mostQuietAngle = 0.4 * pi; // ~72°
    var targetVolume = lerpDouble(
      minVolume,
      maxVolume,
      1 - fanState.angle.value.abs() / mostQuietAngle,
    )!;
    targetVolume = targetVolume.clamp(minVolume, maxVolume);
    targetVolume = sqrt(targetVolume);
    targetVolume = targetVolume.clamp(minVolume, maxVolume);
    _fadeToVolume(targetVolume);
  }

  void _pause() {
    _fadeToVolume(0);
  }

  Timer? _volumeTimer;
  bool get isFadingVolume => _volumeTimer?.isActive ?? false;
  void _fadeToVolume(
    double targetVolume, [
    // The time it takes to fade from 0 to 1.
    Duration maxTime = const Duration(seconds: 1),
    // The number of steps taken to fade from 0 to 1.
    int maxSteps = 60,
  ]) {
    assert(
      targetVolume >= 0.0 && targetVolume <= 1.0,
      'targetVolume must be between 0.0 and 1.0, got $targetVolume',
    );
    assert(isLoaded, 'Player must be loaded before fading volume');
    if (player.volume == targetVolume) return;

    void finalize() {
      _volumeTimer?.cancel();
      player.setVolume(targetVolume);
      if (targetVolume <= 0) {
        player.pause();
      } else {
        player.play();
      }
    }

    final diffVolumeAbs = (targetVolume - player.volume).abs();
    final steps = (diffVolumeAbs * maxSteps).floor();
    if (steps < 2) {
      // If the difference is small enough, just set the volume directly.
      finalize();
      return;
    }
    final duration = maxTime * diffVolumeAbs;
    final increment = (targetVolume - player.volume) / steps;

    _volumeTimer?.cancel();
    _volumeTimer = Timer.periodic(duration ~/ steps, (_) {
      final newVolume = player.volume + increment;
      if ((increment > 0 && newVolume >= targetVolume) ||
          (increment < 0 && newVolume <= targetVolume)) {
        finalize();
      } else {
        player.setVolume(newVolume);
        player.play();
      }
    });

    player.play();
  }
}
