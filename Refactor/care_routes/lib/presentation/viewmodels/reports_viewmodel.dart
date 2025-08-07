// lib/presentation/viewmodels/reports_viewmodel.dart

import 'package:flutter/material.dart';
import '../../domain/use_cases/reports_usecase.dart';
import '../../domain/entities/domain_entities.dart';
import 'dart:io';

enum ReportsState {
  initial,
  loadingData,
  dataLoaded,
  generatingReport,
  reportGenerated,
  showingPreview,
  error,
}

class ReportsViewModel extends ChangeNotifier {
  final ReportsUseCase _reportsUseCase;

  ReportsViewModel({
    required ReportsUseCase reportsUseCase,
  }) : _reportsUseCase = reportsUseCase;

  // Estado privado
  ReportsState _state = ReportsState.initial;
  List<VehicleReportData> _reportData = [];
  List<Vehicle> _availableVehicles = [];
  String? _errorMessage;
  String? _successMessage;
  
  // Filtros
  DateTime? _startDate;
  DateTime? _endDate;
  List<Vehicle> _selectedVehicles = [];
  
  // Reporte generado
  String? _lastGeneratedFilePath;
  String? _lastGeneratedFileName;
  bool _vehiclesLoading = false;

  // Getters públicos
  ReportsState get state => _state;
  List<VehicleReportData> get reportData => List.unmodifiable(_reportData);
  List<Vehicle> get availableVehicles => List.unmodifiable(_availableVehicles);
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<Vehicle> get selectedVehicles => List.unmodifiable(_selectedVehicles);
  String? get lastGeneratedFilePath => _lastGeneratedFilePath;
  String? get lastGeneratedFileName => _lastGeneratedFileName;
  bool get vehiclesLoading => _vehiclesLoading;

  // Getters de conveniencia
  bool get hasReportData => _reportData.isNotEmpty;
  bool get hasError => _state == ReportsState.error;
  bool get isLoadingData => _state == ReportsState.loadingData;
  bool get isGeneratingReport => _state == ReportsState.generatingReport;
  bool get isReportGenerated => _state == ReportsState.reportGenerated;
  bool get isShowingPreview => _state == ReportsState.showingPreview;
  bool get hasFilters => _startDate != null || _endDate != null || _selectedVehicles.isNotEmpty;
  bool get canGenerateReport => hasReportData && !isGeneratingReport;
  int get totalVehiclesInReport => _reportData.length;
  double get totalCostInReport => _reportData.fold(0.0, (sum, vehicle) => sum + vehicle.totalCost);
  int get totalMaintenancesInReport => _reportData.fold(0, (sum, vehicle) => sum + vehicle.maintenances.length);
  bool get hasAvailableVehicles => _availableVehicles.isNotEmpty;
  bool get hasSelectedVehicles => _selectedVehicles.isNotEmpty;

  /// Carga los vehículos disponibles para filtros
  Future<void> loadAvailableVehicles() async {
    _vehiclesLoading = true;
    notifyListeners();

    try {
      _availableVehicles = await _reportsUseCase.getAllActiveVehicles();
    } catch (e) {
      _availableVehicles = [];
    } finally {
      _vehiclesLoading = false;
      notifyListeners();
    }
  }

  /// Establece el filtro de fecha de inicio
  void setStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  /// Establece el filtro de fecha de fin
  void setEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  /// Establece los vehículos seleccionados para el filtro
  void setSelectedVehicles(List<Vehicle> vehicles) {
    _selectedVehicles = vehicles;
    notifyListeners();
  }

  /// Agrega un vehículo a la selección
  void addVehicleToSelection(Vehicle vehicle) {
    if (!_selectedVehicles.contains(vehicle)) {
      _selectedVehicles = [..._selectedVehicles, vehicle];
      notifyListeners();
    }
  }

  /// Remueve un vehículo de la selección
  void removeVehicleFromSelection(Vehicle vehicle) {
    _selectedVehicles = _selectedVehicles.where((v) => v.id != vehicle.id).toList();
    notifyListeners();
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _startDate = null;
    _endDate = null;
    _selectedVehicles = [];
    notifyListeners();
  }

  /// Carga los datos del reporte con los filtros aplicados
  Future<void> loadReportData() async {
    _setState(ReportsState.loadingData);
    
    try {
      final vehicleIds = _selectedVehicles.isNotEmpty 
          ? _selectedVehicles.map((v) => v.id).toList()
          : null;

      final result = await _reportsUseCase.getReportData(
        vehicleIds: vehicleIds,
        startDate: _startDate,
        endDate: _endDate,
      );
      
      if (result.isSuccess) {
        _reportData = result.vehicleReports;
        _successMessage = result.message;
        
        if (_reportData.isEmpty) {
          _errorMessage = 'No se encontraron datos con los filtros aplicados';
          _setState(ReportsState.error);
        } else {
          _setState(ReportsState.dataLoaded);
        }
      } else {
        _setError(result.error ?? 'Error desconocido al cargar datos');
      }
    } catch (e) {
      _setError('Error al cargar los datos del reporte: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Genera un reporte en PDF
  Future<void> generatePdfReport() async {
    if (!canGenerateReport) return;
    
    _setState(ReportsState.generatingReport);
    _successMessage = 'Generando reporte PDF...';
    notifyListeners();
    
    try {
      final result = await _reportsUseCase.generatePdfReport(_reportData);
      
      if (result.isSuccess) {
        _lastGeneratedFilePath = result.filePath;
        _lastGeneratedFileName = result.fileName;
        _successMessage = result.message;
        _setState(ReportsState.reportGenerated);
      } else {
        _setError(result.error ?? 'Error al generar el reporte PDF');
      }
    } catch (e) {
      _setError('Error al generar el reporte PDF: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Genera un reporte en Excel
  Future<void> generateExcelReport() async {
    if (!canGenerateReport) return;
    
    _setState(ReportsState.generatingReport);
    _successMessage = 'Generando reporte Excel...';
    notifyListeners();
    
    try {
      final result = await _reportsUseCase.generateExcelReport(_reportData);
      
      if (result.isSuccess) {
        _lastGeneratedFilePath = result.filePath;
        _lastGeneratedFileName = result.fileName;
        _successMessage = result.message;
        _setState(ReportsState.reportGenerated);
      } else {
        _setError(result.error ?? 'Error al generar el reporte Excel');
      }
    } catch (e) {
      _setError('Error al generar el reporte Excel: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Muestra la vista previa del reporte
  void showReportPreview() {
    _setState(ReportsState.showingPreview);
    notifyListeners();
  }

  /// Cierra la vista previa del reporte
  void closeReportPreview() {
    if (hasReportData) {
      _setState(ReportsState.dataLoaded);
    } else {
      _setState(ReportsState.initial);
    }
    notifyListeners();
  }

  /// Verifica si el archivo generado existe
  Future<bool> doesGeneratedFileExist() async {
    if (_lastGeneratedFilePath == null) return false;
    
    try {
      final file = File(_lastGeneratedFilePath!);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Resetea el estado a inicial
  void resetToInitial() {
    _setState(ReportsState.initial);
    _reportData = [];
    _lastGeneratedFilePath = null;
    _lastGeneratedFileName = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Resetea solo el estado de error
  void resetError() {
    if (_state == ReportsState.error) {
      if (hasReportData) {
        _setState(ReportsState.dataLoaded);
      } else {
        _setState(ReportsState.initial);
      }
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Limpia el mensaje de éxito
  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  // Métodos privados

  void _setState(ReportsState newState) {
    _state = newState;
    _errorMessage = null;
  }

  void _setError(String message) {
    _state = ReportsState.error;
    _errorMessage = message;
    _successMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}