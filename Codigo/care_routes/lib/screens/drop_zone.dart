// lib/screens/drop_example.dart
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';

class DropExample extends StatefulWidget {
  const DropExample({super.key});
  @override
  State<DropExample> createState() => _DropExampleState();
}

class _DropExampleState extends State<DropExample> {
  Color _bg = Colors.green; // normal
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.45;
    final dropHeight = screenSize.height * 0.45;
    var iconSize = screenSize.width * 0.10;
    if (screenSize.width < 600) {
      iconSize = screenSize.width * 0.15;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90, // Aumenta la altura del AppBar
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Espaciado superior extra
          child: Text(
            "Importar Datos",
            style: TextStyle(
              fontSize: 40,
              color: const Color(0xFF0973ad),
              fontWeight: FontWeight.bold,
              fontFamily: 'Wix Madefor Text',
            ),
          ),
        ),
      ),
      body: Center(
        child: DropTarget(
          onDragEntered:
              (_) => setState(() => _bg = Colors.orangeAccent), // hover
          onDragExited: (_) => setState(() => _bg = Colors.green), // sale
          onDragDone: (_) => setState(() => _bg = Colors.blue), // drop
          child: AnimatedContainer(
            width: double.infinity,
            height: dropHeight,
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: _bg,
              border: Border.all(color: const Color(0xFF000000), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.drive_folder_upload, size: iconSize),
                SizedBox(height: 8),
                Text("Arrastre y suelte el archivo aquí"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
