import 'package:care_routes/screens/home_state.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareRoutes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeState(), // This is the main screen of the app
    );
  }
}
