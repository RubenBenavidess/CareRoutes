// presentation/viewmodels/assign_driver_viewmodel.dart
import 'package:flutter/material.dart';
import '../../domain/use_cases/assign_driver_usecase.dart';
import '../../domain/entities/domain_entities.dart';

enum AssignDriverState {
  initial,
  loadingAvailableDrivers,
  loadingAssignedDriver,
  processing,
  availableDriversLoaded,
  assignedDriverLoaded,
  noDriverAssigned,
  operationSuccess,
  error,
}

class AssignDriverViewModel extends ChangeNotifier {
  final AssignDriverUseCase _assignDriverUseCase;

  AssignDriverViewModel({
    required AssignDriverUseCase assignDriverUseCase,
  }) : _assignDriverUseCase = assignDriverUseCase;

  // Estado privado
  AssignDriverState _state = AssignDriverState.initial;
  Vehicle? _currentVehicle;
  Driver? _assignedDriver;
  List<Driver> _availableDrivers = [];
  AssignmentStats? _stats;
  String? _errorMessage;
  String? _successMessage;

  // Getters públicos
  AssignDriverState get state => _state;
  Vehicle? get currentVehicle => _currentVehicle;
  Driver? get assignedDriver => _assignedDriver;
  List<Driver> get availableDrivers => List.unmodifiable(_availableDrivers);
  AssignmentStats? get stats => _stats;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Getters de conveniencia
  bool get isLoading => _state == AssignDriverState.loadingAvailableDrivers ||
                       _state == AssignDriverState.loadingAssignedDriver ||
                       _state == AssignDriverState.processing;
  bool get hasError => _state == AssignDriverState.error;
  bool get hasAvailableDrivers => _availableDrivers.isNotEmpty;
  bool get hasAssignedDriver => _assignedDriver != null;
  bool get canAssignDriver => !hasAssignedDriver && hasAvailableDrivers && !isLoading;
  bool get canUnassignDriver => hasAssignedDriver && !isLoading;
  String get vehicleInfo => _currentVehicle != null 
      ? '${_currentVehicle!.licensePlate} - ${_currentVehicle!.brand} ${_currentVehicle!.model ?? ''}'
      : '';

  /// Inicializa el ViewModel con un vehículo específico
  Future<void> initializeWithVehicle(Vehicle vehicle) async {
    _currentVehicle = vehicle;
    _clearMessages();
    
    // Cargar conductor asignado y conductores disponibles en paralelo
    await Future.wait([
      loadAssignedDriver(),
      loadAvailableDrivers(),
    ]);
    
    // Cargar estadísticas opcionalmente
    loadStats();
  }

  /// Carga el conductor asignado al vehículo actual
Future<void> loadAssignedDriver() async {
    if (_currentVehicle == null) return;

    _setState(AssignDriverState.loadingAssignedDriver);

    try {
      final result = await _assignDriverUseCase.getAssignedDriver(_currentVehicle!);
      
      if (result.isSuccess) {
        _assignedDriver = result.driver;
        if (result.hasDriver) {
          _setState(AssignDriverState.assignedDriverLoaded);
        } else {
          _setState(AssignDriverState.noDriverAssigned);
        }
      } else {
        _setError(result.error ?? 'Error al cargar conductor asignado');
      }
    } catch (e) {
      _setError('Error al cargar conductor asignado: ${e.toString()}');
    }

    notifyListeners();
  }

  Future<void> loadAvailableDrivers() async {
    _setState(AssignDriverState.loadingAvailableDrivers);

    try {
      final result = await _assignDriverUseCase.getAvailableDrivers();
      
      if (result.isSuccess) {
        _availableDrivers = result.drivers;
        _setState(AssignDriverState.availableDriversLoaded);
      } else {
        _setError(result.error ?? 'Error al cargar conductores disponibles');
      }
    } catch (e) {
      _setError('Error al cargar conductores disponibles: ${e.toString()}');
    }

    notifyListeners();
  }

  Future<void> loadStats() async {
    try {
      final result = await _assignDriverUseCase.getAssignmentStats();
      
      if (result.isSuccess && result.stats != null) {
        _stats = result.stats;
        notifyListeners();
      }
    } catch (e) {
      // Silencioso para estadísticas
    }
  }

  /// Asigna un conductor al vehículo actual
  Future<void> assignDriver(Driver driver) async {
    if (_currentVehicle == null) {
      _setError('No hay vehículo seleccionado');
      return;
    }

    _setState(AssignDriverState.processing);
    _clearMessages();

    try {
      final result = await _assignDriverUseCase.assignDriverToVehicle(_currentVehicle!, driver);
      
      if (result.isSuccess && result.updatedVehicle != null) {
        _currentVehicle = result.updatedVehicle;
        _assignedDriver = result.assignedDriver;
        _successMessage = result.message;
        
        // Recargar conductores disponibles para actualizar la lista
        await loadAvailableDrivers();
        
        _setState(AssignDriverState.operationSuccess);
      } else {
        _setError(result.error ?? 'Error al asignar conductor');
      }
    } catch (e) {
      _setError('Error al asignar conductor: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Desasigna el conductor del vehículo actual
  Future<void> unassignDriver() async {
    if (_currentVehicle == null) {
      _setError('No hay vehículo seleccionado');
      return;
    }

    if (_assignedDriver == null) {
      _setError('No hay conductor asignado para desasignar');
      return;
    }

    _setState(AssignDriverState.processing);
    _clearMessages();

    try {
      final result = await _assignDriverUseCase.unassignDriverFromVehicle(_currentVehicle!);
      
      if (result.isSuccess && result.updatedVehicle != null) {
        _currentVehicle = result.updatedVehicle;
        _assignedDriver = null;
        _successMessage = result.message;
        
        // Recargar conductores disponibles para actualizar la lista
        await loadAvailableDrivers();
        
        _setState(AssignDriverState.operationSuccess);
      } else {
        _setError(result.error ?? 'Error al desasignar conductor');
      }
    } catch (e) {
      _setError('Error al desasignar conductor: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Filtra conductores disponibles por nombre
  List<Driver> filterDriversByName(String query) {
    if (query.trim().isEmpty) return _availableDrivers;
    
    final lowerQuery = query.toLowerCase();
    return _availableDrivers.where((driver) =>
      driver.firstName.toLowerCase().contains(lowerQuery) ||
      driver.lastName.toLowerCase().contains(lowerQuery) ||
      '${driver.firstName} ${driver.lastName}'.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  /// Busca un conductor por número de cédula
  Driver? findDriverByIdNumber(String idNumber) {
    try {
      return _availableDrivers.firstWhere(
        (driver) => driver.idNumber == idNumber.trim(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el nombre completo de un conductor
  String getDriverFullName(Driver driver) {
    return '${driver.firstName} ${driver.lastName}'.trim();
  }

  /// Obtiene información completa del conductor para mostrar
  String getDriverInfo(Driver driver) {
    return '${getDriverFullName(driver)}\nCédula: ${driver.idNumber}';
  }

  /// Refresca toda la información
  Future<void> refreshAll() async {
    if (_currentVehicle == null) return;

    _clearMessages();
    await Future.wait([
      loadAssignedDriver(),
      loadAvailableDrivers(),
    ]);
    loadStats();
  }

  /// Limpia solo los mensajes de error/éxito
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  /// Resetea todo el estado
  void reset() {
    _currentVehicle = null;
    _assignedDriver = null;
    _availableDrivers = [];
    _stats = null;
    _errorMessage = null;
    _successMessage = null;
    _state = AssignDriverState.initial;
    notifyListeners();
  }

  /// Confirma una operación exitosa y limpia mensajes
  void confirmSuccess() {
    _clearMessages();
    if (_assignedDriver != null) {
      _setState(AssignDriverState.assignedDriverLoaded);
    } else {
      _setState(AssignDriverState.noDriverAssigned);
    }
    notifyListeners();
  }

  // Métodos privados

  void _setState(AssignDriverState newState) {
    _state = newState;
    _errorMessage = null;
  }

  void _setError(String message) {
    _state = AssignDriverState.error;
    _errorMessage = message;
    _successMessage = null;
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}