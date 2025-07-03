import 'package:fan/data/stows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemedApp extends StatefulWidget {
  final String title;
  final Widget home;

  const ThemedApp({super.key, required this.title, required this.home});

  @override
  State<ThemedApp> createState() => _ThemedAppState();

  static ThemeData getTheme(Color accent) {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: accent,
      ),
    );
  }
}

class _ThemedAppState extends State<ThemedApp> {
  final _appKey = GlobalKey();
  final _appChildKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    stows.accentColor.addListener(_setState);
  }

  @override
  void dispose() {
    stows.accentColor.removeListener(_setState);
    super.dispose();
  }

  void _setState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemedApp.getTheme(stows.accentColor.value);

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoApp(
          key: _appKey,
          title: widget.title,
          theme: CupertinoThemeData(
            brightness: theme.brightness,
            primaryColor: theme.colorScheme.primary,
          ),
          localizationsDelegates: [DefaultMaterialLocalizations.delegate],
          home: Theme(
            data: theme,
            child: KeyedSubtree(key: _appChildKey, child: widget.home),
          ),
        );
      default:
        return MaterialApp(
          key: _appKey,
          title: widget.title,
          theme: theme,
          home: KeyedSubtree(key: _appChildKey, child: widget.home),
        );
    }
  }
}
