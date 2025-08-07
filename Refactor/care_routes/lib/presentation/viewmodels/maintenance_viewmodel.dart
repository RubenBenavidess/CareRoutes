// lib/presentation/viewmodels/maintenance_viewmodel.dart

import 'package:flutter/material.dart';
import '../../domain/use_cases/maintenance_usecase.dart';
import '../../domain/entities/domain_entities.dart';

enum MaintenanceState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

enum MaintenanceOperationState {
  idle,
  creating,
  updating,
  deleting,
  success,
  error,
}

class MaintenanceViewModel extends ChangeNotifier {
  final MaintenanceUseCase _maintenanceUseCase;

  MaintenanceViewModel({
    required MaintenanceUseCase maintenanceUseCase,
  }) : _maintenanceUseCase = maintenanceUseCase;

  // Estado privado - Lista principal
  MaintenanceState _state = MaintenanceState.initial;
  List<MaintenanceWithVehicle> _maintenances = [];
  MaintenanceWithVehicle? _selectedMaintenance;
  String? _errorMessage;
  String? _searchQuery;
  int _totalFound = 0;
  bool _isStreamActive = false;

  // Estado privado - Operaciones CRUD
  MaintenanceOperationState _operationState = MaintenanceOperationState.idle;
  String? _operationMessage;
  String? _operationError;

  // Estado privado - Detalles de mantenimiento
  List<MaintenanceDetail> _currentMaintenanceDetails = [];
  bool _detailsLoading = false;
  String? _detailsError;

  // Estado privado - Formularios y datos auxiliares
  List<Vehicle> _availableVehicles = [];
  bool _vehiclesLoading = false;
  Maintenance? _editingMaintenance;
  MaintenanceDetail? _editingDetail;

  // Getters públicos - Estado principal
  MaintenanceState get state => _state;
  List<MaintenanceWithVehicle> get maintenances => List.unmodifiable(_maintenances);
  MaintenanceWithVehicle? get selectedMaintenance => _selectedMaintenance;
  String? get errorMessage => _errorMessage;
  String? get searchQuery => _searchQuery;
  int get totalFound => _totalFound;
  bool get isStreamActive => _isStreamActive;

  // Getters públicos - Operaciones
  MaintenanceOperationState get operationState => _operationState;
  String? get operationMessage => _operationMessage;
  String? get operationError => _operationError;

  // Getters públicos - Detalles
  List<MaintenanceDetail> get currentMaintenanceDetails => List.unmodifiable(_currentMaintenanceDetails);
  bool get detailsLoading => _detailsLoading;
  String? get detailsError => _detailsError;

  // Getters públicos - Datos auxiliares
  List<Vehicle> get availableVehicles => List.unmodifiable(_availableVehicles);
  bool get vehiclesLoading => _vehiclesLoading;
  Maintenance? get editingMaintenance => _editingMaintenance;
  MaintenanceDetail? get editingDetail => _editingDetail;

  // Getters de conveniencia
  bool get hasMaintenances => _maintenances.isNotEmpty;
  bool get isLoading => _state == MaintenanceState.loading;
  bool get hasError => _state == MaintenanceState.error;
  bool get isEmpty => _state == MaintenanceState.empty;
  bool get hasSearchQuery => _searchQuery != null && _searchQuery!.trim().isNotEmpty;
  int get maintenanceCount => _maintenances.length;
  bool get isOperating => _operationState == MaintenanceOperationState.creating ||
                         _operationState == MaintenanceOperationState.updating ||
                         _operationState == MaintenanceOperationState.deleting;
  bool get hasMaintenanceDetails => _currentMaintenanceDetails.isNotEmpty;
  bool get isEditing => _editingMaintenance != null;
  bool get isEditingDetail => _editingDetail != null;

  // === MÉTODOS PRINCIPALES ===

  /// Carga todos los mantenimientos activos
  Future<void> loadAllMaintenances() async {
    _setLoading();

    try {
      final result = await _maintenanceUseCase.getAllActiveMaintenances();
      
      if (result.isSuccess) {
        _maintenances = result.maintenances;
        _totalFound = result.totalFound;
        _selectedMaintenance = null;
        _searchQuery = null;
        
        if (_maintenances.isEmpty) {
          _setState(MaintenanceState.empty);
        } else {
          _setState(MaintenanceState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error desconocido al cargar mantenimientos');
      }
    } catch (e) {
      _setError('Error al cargar mantenimientos: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Busca mantenimientos por placa de vehículo
  Future<void> searchMaintenancesByPlate(String licensePlate) async {
    if (licensePlate.trim().isEmpty) {
      _setError('La placa no puede estar vacía');
      return;
    }

    _setLoading();
    _searchQuery = 'Placa: ${licensePlate.toUpperCase()}';

    try {
      final result = await _maintenanceUseCase.getMaintenancesByLicensePlate(licensePlate);
      
      if (result.isSuccess) {
        _maintenances = result.maintenances;
        _totalFound = result.totalFound;
        _selectedMaintenance = null;
        
        if (_maintenances.isEmpty) {
          _setState(MaintenanceState.empty);
        } else {
          _setState(MaintenanceState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error al buscar mantenimientos por placa');
      }
    } catch (e) {
      _setError('Error al buscar mantenimientos: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Busca un mantenimiento específico por ID
  Future<void> searchMaintenanceById(int maintenanceId) async {
    if (maintenanceId <= 0) {
      _setError('ID de mantenimiento inválido');
      return;
    }

    _setLoading();
    _searchQuery = 'ID: $maintenanceId';

    try {
      final result = await _maintenanceUseCase.getMaintenanceById(maintenanceId);
      
      if (result.isSuccess) {
        _maintenances = result.maintenances;
        _totalFound = result.totalFound;
        _selectedMaintenance = result.maintenances.isNotEmpty ? result.maintenances.first : null;
        
        if (_maintenances.isEmpty) {
          _setState(MaintenanceState.empty);
        } else {
          _setState(MaintenanceState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error al buscar mantenimiento por ID');
      }
    } catch (e) {
      _setError('Error al buscar mantenimiento: ${e.toString()}');
    }

    notifyListeners();
  }

  // === OPERACIONES CRUD ===

  /// Crea un nuevo mantenimiento
  Future<bool> createMaintenance(Maintenance maintenance) async {
    _setOperationState(MaintenanceOperationState.creating);
    
    try {
      final result = await _maintenanceUseCase.createMaintenance(maintenance);
      
      if (result.isSuccess) {
        _setOperationSuccess('Mantenimiento creado exitosamente');
        await refresh(); // Recargar la lista
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al crear mantenimiento');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al crear mantenimiento: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza un mantenimiento existente
  Future<bool> updateMaintenance(Maintenance maintenance) async {
    _setOperationState(MaintenanceOperationState.updating);
    
    try {
      final result = await _maintenanceUseCase.updateMaintenance(maintenance);
      
      if (result.isSuccess) {
        _setOperationSuccess('Mantenimiento actualizado exitosamente');
        _editingMaintenance = null;
        await refresh(); // Recargar la lista
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al actualizar mantenimiento');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al actualizar mantenimiento: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Elimina un mantenimiento
  Future<bool> deleteMaintenance(int maintenanceId) async {
    _setOperationState(MaintenanceOperationState.deleting);
    
    try {
      final result = await _maintenanceUseCase.deleteMaintenance(maintenanceId);
      
      if (result.isSuccess) {
        _setOperationSuccess('Mantenimiento eliminado exitosamente');
        if (_selectedMaintenance?.maintenance.id == maintenanceId) {
          _selectedMaintenance = null;
        }
        await refresh(); // Recargar la lista
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al eliminar mantenimiento');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al eliminar mantenimiento: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  // === MANEJO DE DETALLES ===

  /// Carga los detalles de un mantenimiento específico
  Future<void> loadMaintenanceDetails(int maintenanceId) async {
    _detailsLoading = true;
    _detailsError = null;
    notifyListeners();

    try {
      final result = await _maintenanceUseCase.getMaintenanceDetails(maintenanceId);
      
      if (result.isSuccess) {
        _currentMaintenanceDetails = result.details;
        _detailsError = null;
      } else {
        _detailsError = result.error ?? 'Error al cargar detalles';
        _currentMaintenanceDetails = [];
      }
    } catch (e) {
      _detailsError = 'Error al cargar detalles: ${e.toString()}';
      _currentMaintenanceDetails = [];
    } finally {
      _detailsLoading = false;
      notifyListeners();
    }
  }

  /// Crea un nuevo detalle de mantenimiento
  Future<bool> createMaintenanceDetail(MaintenanceDetail detail) async {
    _setOperationState(MaintenanceOperationState.creating);
    
    try {
      final result = await _maintenanceUseCase.createMaintenanceDetail(detail);
      
      if (result.isSuccess) {
        _setOperationSuccess('Detalle agregado exitosamente');
        // Recargar los detalles del mantenimiento actual
        if (_selectedMaintenance != null) {
          await loadMaintenanceDetails(_selectedMaintenance!.maintenance.id);
        }
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al crear detalle');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al crear detalle: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza un detalle de mantenimiento
  Future<bool> updateMaintenanceDetail(MaintenanceDetail detail) async {
    _setOperationState(MaintenanceOperationState.updating);
    
    try {
      final result = await _maintenanceUseCase.updateMaintenanceDetail(detail);
      
      if (result.isSuccess) {
        _setOperationSuccess('Detalle actualizado exitosamente');
        _editingDetail = null;
        // Recargar los detalles del mantenimiento actual
        if (_selectedMaintenance != null) {
          await loadMaintenanceDetails(_selectedMaintenance!.maintenance.id);
        }
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al actualizar detalle');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al actualizar detalle: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Elimina un detalle de mantenimiento
  Future<bool> deleteMaintenanceDetail(int detailId) async {
    _setOperationState(MaintenanceOperationState.deleting);
    
    try {
      final result = await _maintenanceUseCase.deleteMaintenanceDetail(detailId);
      
      if (result.isSuccess) {
        _setOperationSuccess('Detalle eliminado exitosamente');
        // Recargar los detalles del mantenimiento actual
        if (_selectedMaintenance != null) {
          await loadMaintenanceDetails(_selectedMaintenance!.maintenance.id);
        }
        return true;
      } else {
        _setOperationError(result.error ?? 'Error al eliminar detalle');
        return false;
      }
    } catch (e) {
      _setOperationError('Error al eliminar detalle: ${e.toString()}');
      return false;
    } finally {
      notifyListeners();
    }
  }

  // === DATOS AUXILIARES ===

  /// Carga la lista de vehículos disponibles
  Future<void> loadAvailableVehicles() async {
    _vehiclesLoading = true;
    notifyListeners();

    try {
      _availableVehicles = await _maintenanceUseCase.getAllActiveVehicles();
    } catch (e) {
      // Silencioso para no afectar el estado principal
      _availableVehicles = [];
    } finally {
      _vehiclesLoading = false;
      notifyListeners();
    }
  }

  // === STREAM Y TIEMPO REAL ===

  /// Inicia el stream de mantenimientos en tiempo real
  void startMaintenanceStream() {
    if (_isStreamActive) return;

    _isStreamActive = true;
    _maintenanceUseCase.watchAllActiveMaintenances().listen(
      (maintenances) {
        _maintenances = maintenances;
        _totalFound = maintenances.length;
        
        if (_maintenances.isEmpty) {
          _setState(MaintenanceState.empty);
        } else {
          _setState(MaintenanceState.loaded);
        }
        
        notifyListeners();
      },
      onError: (error) {
        _setError('Error en stream de mantenimientos: ${error.toString()}');
        _isStreamActive = false;
        notifyListeners();
      },
    );
  }

  /// Detiene el stream de mantenimientos
  void stopMaintenanceStream() {
    _isStreamActive = false;
  }

  // === SELECCIÓN Y NAVEGACIÓN ===

  /// Selecciona un mantenimiento específico
  void selectMaintenance(MaintenanceWithVehicle? maintenance) {
    _selectedMaintenance = maintenance;
    if (maintenance != null) {
      loadMaintenanceDetails(maintenance.maintenance.id);
    } else {
      _currentMaintenanceDetails = [];
    }
    notifyListeners();
  }

  /// Inicia la edición de un mantenimiento
  void startEditingMaintenance(Maintenance maintenance) {
    _editingMaintenance = maintenance;
    notifyListeners();
  }

  /// Cancela la edición de mantenimiento
  void cancelEditingMaintenance() {
    _editingMaintenance = null;
    notifyListeners();
  }

  /// Inicia la edición de un detalle
  void startEditingDetail(MaintenanceDetail detail) {
    _editingDetail = detail;
    notifyListeners();
  }

  /// Cancela la edición de detalle
  void cancelEditingDetail() {
    _editingDetail = null;
    notifyListeners();
  }

  // === LIMPIEZA Y RESET ===

  /// Limpia los resultados y resetea a estado inicial
  void clearResults() {
    _maintenances = [];
    _selectedMaintenance = null;
    _errorMessage = null;
    _searchQuery = null;
    _totalFound = 0;
    _state = MaintenanceState.initial;
    _currentMaintenanceDetails = [];
    _editingMaintenance = null;
    _editingDetail = null;
    resetOperationState();
    stopMaintenanceStream();
    notifyListeners();
  }

  /// Resetea solo el estado de error manteniendo los datos
  void resetErrorState() {
    if (_state == MaintenanceState.error) {
      _errorMessage = null;
      if (_maintenances.isNotEmpty) {
        _state = MaintenanceState.loaded;
      } else {
        _state = MaintenanceState.initial;
      }
      notifyListeners();
    }
  }

  /// Resetea el estado de operaciones
  void resetOperationState() {
    _operationState = MaintenanceOperationState.idle;
    _operationMessage = null;
    _operationError = null;
    notifyListeners();
  }

  /// Limpia solo la búsqueda actual
  void clearSearch() {
    _searchQuery = null;
    notifyListeners();
  }

  /// Refresca los datos actuales
  Future<void> refresh() async {
    if (hasSearchQuery && _searchQuery!.startsWith('ID:')) {
      final idStr = _searchQuery!.replaceFirst('ID:', '').trim();
      final id = int.tryParse(idStr);
      if (id != null) {
        await searchMaintenanceById(id);
        return;
      }
    }

    if (hasSearchQuery && _searchQuery!.startsWith('Placa:')) {
      final plate = _searchQuery!.replaceFirst('Placa:', '').trim();
      await searchMaintenancesByPlate(plate);
      return;
    }

    await loadAllMaintenances();
  }

  // === MÉTODOS PRIVADOS ===

  void _setLoading() {
    _state = MaintenanceState.loading;
    _errorMessage = null;
  }

  void _setState(MaintenanceState newState) {
    _state = newState;
    _errorMessage = null;
  }

  void _setError(String message) {
    _state = MaintenanceState.error;
    _errorMessage = message;
    _maintenances = [];
    _selectedMaintenance = null;
    _totalFound = 0;
  }

  void _setOperationState(MaintenanceOperationState state) {
    _operationState = state;
    _operationMessage = null;
    _operationError = null;
  }

  void _setOperationSuccess(String message) {
    _operationState = MaintenanceOperationState.success;
    _operationMessage = message;
    _operationError = null;
  }

  void _setOperationError(String error) {
    _operationState = MaintenanceOperationState.error;
    _operationMessage = null;
    _operationError = error;
  }

  @override
  void dispose() {
    stopMaintenanceStream();
    super.dispose();
  }
}