import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemedApp extends StatelessWidget {
  final String title;
  final Widget home;

  const ThemedApp({super.key, required this.title, required this.home});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF2F00);

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoApp(
          title: title,
          theme: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: primaryColor,
          ),
          localizationsDelegates: [DefaultMaterialLocalizations.delegate],
          home: home,
        );
      default:
        return MaterialApp(
          title: title,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: primaryColor,
            ),
          ),
          home: home,
        );
    }
  }
}
