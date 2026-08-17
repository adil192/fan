import 'package:fan/data/stows.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const ThemedApp({
  super.key,
  required final String title,
  final String initialRoute = '/',
  required final Map<String, Widget Function(BuildContext)> routes,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(stows.accentColor);
    final appKey = useMemoized(GlobalKey.new);

    final theme = ThemedApp.getTheme(stows.accentColor.value);
    return MaterialApp(
      key: appKey,
      title: title,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      initialRoute: initialRoute,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }

  /// Creates a [ThemeData] from an [accent] color.
  static ThemeData getTheme(Color accent) {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: accent,
      ),
    );
  }
}
