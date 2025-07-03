import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    const assetsRelPath = 'assets/fan-assets/';
    final assetsSrcUri = input.packageRoot.resolve(assetsRelPath);
    final assetsSrcDir = Directory.fromUri(assetsSrcUri);

    if (!assetsSrcDir.existsSync()) {
      throw PathNotFoundException(
        assetsSrcDir.path,
        OSError('⚠ Fan assets missing, please run `./scripts/get-assets.sh`'),
      );
    }
  });
}
