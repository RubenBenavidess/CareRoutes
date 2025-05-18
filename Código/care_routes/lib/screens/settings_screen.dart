import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuración",
          style: TextStyle(
            fontSize: 40,
            color: const Color(0x000973ad),
            fontWeight: FontWeight.bold,
            fontFamily: 'Wix Madefor Text',
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Configuración de la aplicación",
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w600,
            fontFamily: 'Wix Madefor Text',
          ),
        ),
      ),
    );
  }
}