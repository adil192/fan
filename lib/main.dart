import 'package:fan/components/themed_app.dart';
import 'package:fan/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(title: 'Fan', home: const HomePage());
  }
}
