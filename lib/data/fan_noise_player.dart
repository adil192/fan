import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:fan/data/fan_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

late final FanAudioHandler fanAudioHandler;

class FanAudioHandler extends BaseAudioHandler {
  bool get isLoaded => _isLoaded;
  bool _isLoaded = false;

  late final player = AudioPlayer(useLazyPreparation: false)
    ..setLoopMode(LoopMode.one)
    ..setVolume(0);
  late final Duration duration;

  static Future<void> init() async {
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

    // Use mediakit on all platforms except android
    JustAudioMediaKit.ensureInitialized(macOS: true, iOS: true);

    fanAudioHandler = await AudioService.init(
      builder: () => FanAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.adilhanney.fan.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
    await fanAudioHandler.load();
  }

  Future<void> load() async {
    const assetPath = 'assets/audio/fan_loop.ogg';
    playbackState.add(
      playbackState.value.copyWith(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.loading,
      ),
    );
    duration = await player.setAsset(assetPath) ?? const Duration(seconds: 17);
    playbackState.add(
      playbackState.value.copyWith(processingState: AudioProcessingState.ready),
    );

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
      play();
    } else {
      pause();
    }
  }

  @override
  Future<void> play() async {
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

    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        controls: [MediaControl.pause],
      ),
    );
    fanState.isOn = true;
  }

  @override
  Future<void> pause() async {
    _fadeToVolume(0);

    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play],
      ),
    );
    fanState.isOn = false;
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
