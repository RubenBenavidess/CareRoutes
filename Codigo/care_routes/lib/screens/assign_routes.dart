import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class AssignRoutes extends StatelessWidget {
  const AssignRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Importar Datos",
          style: TextStyle(
            fontSize: 40,
            color: const Color(0x000973ad),
            fontWeight: FontWeight.bold,
            fontFamily: 'Wix Madefor Text',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: FileDropZone()),
        ],
      )
    );
  }
}

class FileDropZone extends StatefulWidget {
  const FileDropZone({Key? key}) : super(key: key);

  @override
  _FileDropZoneState createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  late DropzoneViewController _controller;
  final List<DropzoneFileInterface> _droppedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // 1) La zona de drop
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                // Asignamos el controlador
                onCreated: (ctrl) => _controller = ctrl,
                onLoaded: () => print('Zona cargada'),
                onError: (ev) => print('Error: $ev'),
                onHover: () => print('Hovered'),
                onLeave: () => print('Salió'),
                // Para múltiples archivos
                onDropFiles: (files) async {
                  for (var file in files!) {
                    final name = file.name;
                    final bytes = await _controller.getFileData(file);
                    setState(() {
                      _droppedFiles.add(file);
                    });
                    print('Múltiple: $name, ${bytes.length} bytes');
                  }
                },
              ),
              // 2) Mensaje superpuesto
              Center(child: Text('Suelta archivos aquí')),
            ],
          ),
        ),
        // 3) Lista de nombres (opcional)
        Expanded(
          child: ListView(
            children:
                _droppedFiles
                    .map((f) => ListTile(title: Text(f.name)))
                    .toList(),
          ),
        ),
      ],
    );
  }
}
