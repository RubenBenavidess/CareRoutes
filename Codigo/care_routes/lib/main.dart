import 'package:care_routes/ui/home_state.dart';
import 'package:flutter/material.dart';
import 'package:care_routes/themes/main_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {

  runApp(const ProviderScope(
      child: CareRoutesApp(),
    )
  );
}

class CareRoutesApp extends StatelessWidget {
  const CareRoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareRoutes',
      theme: mainTheme,
      home: const HomeState(),
    );
  }
}
