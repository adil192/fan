#!/bin/bash

# We remove the mediakit packages (which aren't used on Android) to
# support 16 KB page sizes.
#
# Libraries that do not support 16 KB:
# base/lib/arm64-v8a/libmedia_kit_native_event_loop.so
# base/lib/arm64-v8a/libmediakitandroidhelper.so
# base/lib/arm64-v8a/libmpv.so
# base/lib/x86_64/libmedia_kit_native_event_loop.so
# base/lib/x86_64/libmediakitandroidhelper.so
# base/lib/x86_64/libmpv.so

echo "Removing media_kit and related packages from pubspec.yaml"
sed -i -e "/just_audio_media_kit/d" pubspec.yaml
sed -i -e "/media_kit/d" pubspec.yaml

echo "Removing JustAudioMediaKit usages"
sed -i -e "/package:just_audio_media_kit/d" lib/data/fan_noise_player.dart
sed -i -e "/JustAudioMediaKit.ensureInitialized(/d" lib/data/fan_noise_player.dart
