import 'package:fan/data/stows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemedApp extends StatefulWidget {
  const ThemedApp({
    super.key,
    required this.title,
    this.initialRoute = '/',
    required this.routes,
  });

  final String title;
  final String initialRoute;
  final Map<String, Widget Function(BuildContext)> routes;

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
          initialRoute: widget.initialRoute,
          routes: {
            for (final entry in widget.routes.entries)
              entry.key: (context) =>
                  Theme(data: theme, child: entry.value(context)),
          },
          debugShowCheckedModeBanner: false,
        );
      default:
        return MaterialApp(
          key: _appKey,
          title: widget.title,
          theme: theme,
          initialRoute: widget.initialRoute,
          routes: widget.routes,
          debugShowCheckedModeBanner: false,
        );
    }
  }
}
