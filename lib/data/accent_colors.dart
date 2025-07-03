import 'package:flutter/material.dart';

enum Accent {
  red(Color(0xFFFF2F00)),
  orange(Color(0xFFff9800)),
  yellow(Color(0xFFffd83b)),
  green(Color(0xFF4caf50)),
  blue(Color(0xFF2196f3)),
  purple(Color(0xFF9c27b0)),
  magenta(Color(0xFFe91e63));

  const Accent(this.color);

  final Color color;
}
