import 'package:flutter/material.dart';
import 'package:care_routes/screens/home_state.dart';
import 'package:care_routes/themes/main_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareRoutes',
      theme: mainTheme,
      home: const HomeState(),
    );
  }
}
