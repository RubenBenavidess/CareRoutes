import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/import_services.dart';
import '../providers/database_providers.dart';

class FileUploadModel with ChangeNotifier {
  String? fileName;
  bool isUpload = false;
  String? contenido;
  WidgetRef? _ref; // Guarda una referencia a WidgetRef

  // Método para establecer la referencia
  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void updateFile(String name) {
    fileName = name;
    isUpload = true;
    notifyListeners();
  }

  void importFile(XFile xfile, BuildContext context) async {
    if (_ref == null) {
      throw Exception('WidgetRef no establecido en FileUploadModel');
    }

    updateFile(xfile.name);
    final fileName = xfile.name.toLowerCase();

    if (fileName.endsWith('.csv')) {
      // Accede a la instancia real de la base de datos
      final db = _ref!.read(dbProvider);
      await ImportServices.importCsv(xfile, db);
    }
  }
}
