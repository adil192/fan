import 'package:fan/data/accent_colors.dart';
import 'package:flutter/material.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

@visibleForTesting
class Stows {
  final accentColor = PlainStow(
    'accent',
    Accent.red.color,
    codec: ColorCodec(),
  );
}
