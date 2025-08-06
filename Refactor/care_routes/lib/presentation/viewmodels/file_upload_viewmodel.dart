import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../../domain/use_cases/import_csv_usecase.dart';
import '../../domain/entities/import_result.dart';

enum FileUploadState {
  initial,
  fileSelected,
  uploading,
  success,
  error,
}

class FileUploadViewModel extends ChangeNotifier {
  final ImportCsvUseCase _importCsvUseCase;

  FileUploadViewModel({
    required ImportCsvUseCase importCsvUseCase,
  }) : _importCsvUseCase = importCsvUseCase;

  // Estado privado
  FileUploadState _state = FileUploadState.initial;
  String? _fileName;
  XFile? _selectedFile;
  String? _errorMessage;
  ImportResult? _lastImportResult;

  // Getters públicos
  FileUploadState get state => _state;
  String? get fileName => _fileName;
  XFile? get selectedFile => _selectedFile;
  String? get errorMessage => _errorMessage;
  ImportResult? get lastImportResult => _lastImportResult;

  // Getters de conveniencia
  bool get hasFileSelected => _selectedFile != null && _fileName != null;
  bool get isUploading => _state == FileUploadState.uploading;
  bool get canUpload => hasFileSelected && !isUploading;
  bool get canCancel => hasFileSelected && !isUploading;

  /// Actualiza el archivo seleccionado
  void updateFile(XFile? file) {
    _selectedFile = file;
    _fileName = file?.name;
    _errorMessage = null;
    
    if (file != null) {
      _state = FileUploadState.fileSelected;
    } else {
      _state = FileUploadState.initial;
    }
    
    notifyListeners();
  }

  /// Valida si el archivo es un CSV válido
  bool validateFile(XFile file) {
    final fileName = file.name.toLowerCase();
    return fileName.endsWith('.csv');
  }

  /// Importa el archivo CSV
  Future<void> importFile() async {
    if (_selectedFile == null) {
      _setError('No hay archivo seleccionado');
      return;
    }

    if (!validateFile(_selectedFile!)) {
      _setError('Solo se permiten archivos CSV (.csv)');
      return;
    }

    _state = FileUploadState.uploading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _importCsvUseCase.execute(_selectedFile!);
      _lastImportResult = result;

      if (result.isSuccessful) {
        _state = FileUploadState.success;
        // Opcional: limpiar el archivo después del éxito
        // clearFile();
      } else {
        _setError(_buildErrorMessage(result));
      }
    } catch (e) {
      _setError('Error al importar archivo: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Limpia el archivo seleccionado y resetea el estado
  void clearFile() {
    _selectedFile = null;
    _fileName = null;
    _errorMessage = null;
    _lastImportResult = null;
    _state = FileUploadState.initial;
    notifyListeners();
  }

  /// Resetea solo el estado de error/éxito manteniendo el archivo
  void resetState() {
    _errorMessage = null;
    _lastImportResult = null;
    if (hasFileSelected) {
      _state = FileUploadState.fileSelected;
    } else {
      _state = FileUploadState.initial;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = FileUploadState.error;
    _errorMessage = message;
  }

  String _buildErrorMessage(ImportResult result) {
    final buffer = StringBuffer();
    buffer.write('Error en la importación de ${result.fileType}. ');
    
    if (result.failed > 0) {
      buffer.write('${result.failed} registros fallaron. ');
    }
    
    if (result.duplicatesSkipped > 0) {
      buffer.write('${result.duplicatesSkipped} duplicados omitidos. ');
    }
    
    if (result.errors.isNotEmpty) {
      buffer.write('Errores: ${result.errors.take(3).join(', ')}');
      if (result.errors.length > 3) {
        buffer.write('... y ${result.errors.length - 3} más.');
      }
    }
    
    return buffer.toString();
  }

}