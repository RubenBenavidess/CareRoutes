import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

class ImportServices {
  static Future<void> importFile(XFile xfile) async {
    final fileName = xfile.name.toLowerCase();

    if (fileName.endsWith('.csv')) {
      await _importCsv(xfile);
    } else if (fileName.endsWith('.xlsx') || fileName.endsWith('.xls')) {
      await _importExcel(xfile);
    } else {
      SnackBar(
        content: Text('Formato de archivo no soportado'),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> _importCsv(XFile xfile) async {
    // Lee el archivo CSV
    final content = await xfile.readAsString(); // Lee el contenido del archivo
    final rows = const LineSplitter().convert(
      content,
    ); // Divide el contenido en filas

    final data =
        rows.map((r) => r.split(',')).toList(); // Divide cada fila en columnas

    // mensaje de proceso exitoso
    SnackBar(
      content: Text('Archivo CSV importado con éxito'),
      backgroundColor: Colors.green,
    );
  }

  static Future<void> _importExcel(XFile xfile) async {
    // Lee el archivo Excel
    final bytes = await xfile.readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    //obtiene el nombre de la primerera hoja y la asigna a sheetName
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName]!;

    //obtiene y guarda todas las filas de la hoja
    final data = <List<dynamic>>[];
    for (final row in sheet.rows) {
      data.add(row);
    }
    // mensaje de proceso exitoso
    SnackBar(
      content: Text('Archivo Excel importado con éxito'),
      backgroundColor: Colors.green,
    );
  }
}
