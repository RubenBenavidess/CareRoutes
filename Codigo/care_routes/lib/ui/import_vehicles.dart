import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../themes/text_style.dart';
import '../../providers/file_upload_provider.dart';
import '../themes/button_style.dart';

final fileUploadProvider = ChangeNotifierProvider<FileUploadModel>(
  (ref) => FileUploadModel(),
);

class DropZoneWidget extends ConsumerStatefulWidget {
  const DropZoneWidget({super.key});
  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends ConsumerState<DropZoneWidget> {
  Color _bg = const Color.fromARGB(255, 203, 255, 177); // normal
  XFile? _droppedFile; // Guardar el archivo arrastrado

  @override
  void initState() {
    super.initState();
    // Asignar la referencia al modelo en initState
    ref.read(fileUploadProvider).setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    // Usa ref directamente
    final model = ref.watch(fileUploadProvider);

    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.45;
    final dropHeight = screenSize.height * 0.45;
    final maxHeight = screenSize.height * 0.30;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
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
            width: maxWidth,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cargue los archivos CSV (Excel)",
                    style: NormalTextStyle.normalText,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: maxHeight,
                    child: DropTarget(
                      onDragEntered:
                          (_) => setState(
                            () =>
                                _bg = const Color.fromARGB(219, 255, 193, 113),
                          ),
                      onDragExited:
                          (_) => setState(() {
                            if (!model.isUpload) {
                              _bg = const Color.fromARGB(255, 203, 255, 177);
                            }
                          }),
                      onDragDone: (details) async {
                        if (details.files.isNotEmpty) {
                          final xfile = details.files.first;

                          if (xfile.name.toLowerCase().endsWith('.csv')) {
                            setState(() {
                              _bg = const Color.fromARGB(192, 65, 169, 255);
                              _droppedFile = xfile; // Guardar el archivo
                              model.updateFile(
                                xfile.name,
                              ); // Actualizar nombre del archivo
                            });
                          } else {
                            setState(
                              () =>
                                  _bg = const Color.fromARGB(
                                    255,
                                    203,
                                    255,
                                    177,
                                  ),
                            );
                            _showErrorNotification(context);
                          }
                        }
                      },
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
                            Icon(
                              Icons.drive_folder_upload,
                              size: _calculateIconSize(screenSize),
                            ),
                            SizedBox(height: 8),
                            Text("Arrastre y suelte el archivo aquí"),
                            SizedBox(height: 4),
                            Text(
                              "Archivo: ${model.fileName ?? 'No seleccionado'}",
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            !model.isUpload
                                ? Text(
                                  "Solo archivos CSV (.csv)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF000000),
                                  ),
                                )
                                : SizedBox(), // Usar SizedBox vacío en lugar de Text vacío
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botones alineados a la derecha
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          style:
                              model.isUpload
                                  ? ConfirmButtonStyle.elevated
                                  : RestButtonStyle.elevated,
                          onPressed:
                              model.isUpload && _droppedFile != null
                                  ? () {
                                    try {
                                      // Usar el archivo guardado
                                      ref
                                          .read(fileUploadProvider)
                                          .importFile(_droppedFile!, context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Archivo importado correctamente',
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al importar: ${e.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                  : null,
                          child: const Text('Cargar'),
                        ),
                        SizedBox(
                          width: 110,
                          child: ElevatedButton(
                            style:
                                model.isUpload
                                    ? CancelButtonStyle.elevated
                                    : RestButtonStyle.elevated,
                            onPressed:
                                model.isUpload
                                    ? () {
                                      // Resetear todo
                                      ref
                                          .read(fileUploadProvider)
                                          .updateFile('');
                                      setState(() {
                                        _bg = const Color.fromARGB(
                                          255,
                                          203,
                                          255,
                                          177,
                                        );
                                        _droppedFile = null;
                                        ref.read(fileUploadProvider).isUpload =
                                            false;
                                      });
                                    }
                                    : null,
                            child: const Text('Cancelar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Construye el widget de notificación
  SnackBar _buildNotification() {
    return const SnackBar(
      content: Text('Por favor, seleccione únicamente archivos .csv'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
  }

  // Método para mostrar la notificación
  void _showErrorNotification(BuildContext context) {
    // Cierra cualquier SnackBar existente
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // Muestra la nueva notificación
    ScaffoldMessenger.of(context).showSnackBar(_buildNotification());
  }

  double _calculateIconSize(Size screenSize) {
    // Detectar si es pantalla pequeña (ancho o alto reducido)
    bool isSmallScreen = screenSize.width < 600 || screenSize.height < 647;
    bool isVerySmallScreen = screenSize.width < 400 || screenSize.height < 493;

    if (isVerySmallScreen) {
      // Para pantallas muy pequeñas
      return (screenSize.width * 0.08).clamp(24.0, 32.0);
    } else if (isSmallScreen) {
      // Para pantallas pequeñas
      return (screenSize.width * 0.10).clamp(32.0, 64.0);
    } else {
      // Para pantallas normales
      return (screenSize.width * 0.10 + screenSize.height * 0.05).clamp(
        48.0,
        128.0,
      );
    }
  }
}
