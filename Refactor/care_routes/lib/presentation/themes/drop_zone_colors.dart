import 'package:flutter/material.dart';

class DropZoneColors {
  // Estados del drop zone
  static const Color normal = Color.fromARGB(255, 203, 255, 177); // Verde claro
  static const Color dragEntered = Color.fromARGB(219, 255, 193, 113); // Naranja
  static const Color fileSelected = Color.fromARGB(192, 65, 169, 255); // Azul
  static const Color error = Color.fromARGB(255, 255, 182, 193); // Rosa claro
  static const Color uploading = Color.fromARGB(200, 158, 158, 158); // Gris

  // Bordes
  static const Color border = Color(0xFF000000);
  static const Color borderSuccess = Color(0xFF4CAF50);
  static const Color borderError = Color(0xFFE53E3E);
  static const Color borderWarning = Color(0xFFFF9800);

  // Método para obtener color basado en estado
  static Color getColorForState({
    required bool isDragEntered,
    required bool hasFileSelected,
    required bool isUploading,
    required bool hasError,
  }) {
    if (hasError) return error;
    if (isUploading) return uploading;
    if (isDragEntered) return dragEntered;
    if (hasFileSelected) return fileSelected;
    return normal;
  }

  // Método para obtener color de borde
  static Color getBorderColorForState({
    required bool hasFileSelected,
    required bool isUploading,
    required bool hasError,
    bool isSuccess = false,
  }) {
    if (hasError) return borderError;
    if (isSuccess) return borderSuccess;
    if (isUploading) return borderWarning;
    return border;
  }
}