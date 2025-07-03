import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Tints the fan with the given color.
/// Internally, the fan is greyscaled and then tinted with the color
/// (using a precomputed matrix multiplication).
List<double> getTintMatrix(Color tint) {
  var r = tint.r, g = tint.g, b = tint.b;

  /// Brightens the image by mixing in some of the other channels.
  /// This preserves blacks since the other channels would be 0.
  final brightenFactor = (1 - (r + g + b) / 3) * 0.3;
  r += brightenFactor;
  g += brightenFactor;
  b += brightenFactor;

  final greyscale = Vector3(0.2126, 0.7152, 0.0722);
  const bias = 255 * 0.2;
  return _concatenate([
    [greyscale.r * r, greyscale.g * r, greyscale.b * r, 0, tint.r * bias],
    [greyscale.r * g, greyscale.g * g, greyscale.b * g, 0, tint.g * bias],
    [greyscale.r * b, greyscale.g * b, greyscale.b * b, 0, tint.b * bias],
    [0, 0, 0, 1, 0],
  ]);
}

List<T> _concatenate<T>(List<List<T>> lists) {
  return lists.expand((list) => list).toList();
}
