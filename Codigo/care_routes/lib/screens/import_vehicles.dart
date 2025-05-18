import '../themes/button_style.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropZoneWidget extends StatefulWidget {
  const DropZoneWidget({super.key});
  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
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
      body: Container(
        color: const Color(0xFFF2F2F2),
        child: Center(
          child: Container(
            // ★ Este Container “envolvente” limita todo
            width: maxWidth,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Cargue los archivos CSV (Excel)",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Wix Madefor Text',
                  ),
                ),
                const SizedBox(height: 20),

                DropTarget(
                  onDragEntered:
                      (_) => setState(() => _bg = Colors.orangeAccent), // hover
                  onDragExited:
                      (_) => setState(() => _bg = Colors.green), // sale
                  onDragDone: (_) => setState(() => _bg = Colors.blue),
                  child: AnimatedContainer(
                    width: double.infinity,
                    height: dropHeight,
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: _bg,
                      border: Border.all(
                        color: const Color(0xFF000000),
                        width: 2,
                      ),
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
                const SizedBox(height: 20),

                // ★ Botones alineados a la derecha, pero **dentro** del ancho maxWidth
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 8, // Espacio entre los botones
                    runSpacing: 8, // Espacio entre los botones en cada fila
                    children: [
                      ElevatedButton(
                        style: ConfirmButtonStyle.elevated,
                        onPressed: () {},
                        child: const Text('Cargar'),
                      ),
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          style: CancelButtonStyle.elevated,
                          onPressed: () {},
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
