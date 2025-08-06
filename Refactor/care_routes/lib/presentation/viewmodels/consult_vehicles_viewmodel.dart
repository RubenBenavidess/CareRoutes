import 'package:flutter/material.dart';
import '../../domain/use_cases/consult_vehicles_usecase.dart';
import '../../domain/entities/domain_entities.dart';

enum VehicleConsultState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class VehicleConsultViewModel extends ChangeNotifier {
  final ConsultVehiclesUseCase _consultVehiclesUseCase;

  VehicleConsultViewModel({
    required ConsultVehiclesUseCase consultVehiclesUseCase,
  }) : _consultVehiclesUseCase = consultVehiclesUseCase;

  // Estado privado
  VehicleConsultState _state = VehicleConsultState.initial;
  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  String? _errorMessage;
  String? _searchQuery;
  VehicleFilter _currentFilter = const VehicleFilter();
  VehicleStats? _vehicleStats;
  int _totalFound = 0;
  bool _isStreamActive = false;

  // Getters públicos
  VehicleConsultState get state => _state;
  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  Vehicle? get selectedVehicle => _selectedVehicle;
  String? get errorMessage => _errorMessage;
  String? get searchQuery => _searchQuery;
  VehicleFilter get currentFilter => _currentFilter;
  VehicleStats? get vehicleStats => _vehicleStats;
  int get totalFound => _totalFound;
  bool get isStreamActive => _isStreamActive;

  // Getters de conveniencia
  bool get hasVehicles => _vehicles.isNotEmpty;
  bool get isLoading => _state == VehicleConsultState.loading;
  bool get hasError => _state == VehicleConsultState.error;
  bool get isEmpty => _state == VehicleConsultState.empty;
  bool get hasSearchQuery => _searchQuery != null && _searchQuery!.trim().isNotEmpty;
  bool get hasActiveFilters => _hasActiveFilters();
  int get vehicleCount => _vehicles.length;

  /// Carga todos los vehículos activos
  Future<void> loadAllVehicles() async {
    _setLoading();

    try {
      final result = await _consultVehiclesUseCase.getAllActiveVehicles();
      
      if (result.isSuccess) {
        _vehicles = result.vehicles;
        _totalFound = result.totalFound;
        _selectedVehicle = null;
        _searchQuery = null;
        _currentFilter = const VehicleFilter();
        
        if (_vehicles.isEmpty) {
          _setState(VehicleConsultState.empty);
        } else {
          _setState(VehicleConsultState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error desconocido al cargar vehículos');
      }
    } catch (e) {
      _setError('Error al cargar vehículos: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Busca un vehículo por ID
  Future<void> searchVehicleById(int vehicleId) async {
    if (vehicleId <= 0) {
      _setError('ID de vehículo inválido');
      return;
    }

    _setLoading();
    _searchQuery = 'ID: $vehicleId';

    try {
      final result = await _consultVehiclesUseCase.getVehicleById(vehicleId);
      
      if (result.isSuccess) {
        _vehicles = result.vehicles;
        _totalFound = result.totalFound;
        _selectedVehicle = result.vehicles.isNotEmpty ? result.vehicles.first : null;
        
        if (_vehicles.isEmpty) {
          _setState(VehicleConsultState.empty);
        } else {
          _setState(VehicleConsultState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error al buscar vehículo por ID');
      }
    } catch (e) {
      _setError('Error al buscar vehículo: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Busca un vehículo por placa
  Future<void> searchVehicleByPlate(String licensePlate) async {
    if (licensePlate.trim().isEmpty) {
      _setError('La placa no puede estar vacía');
      return;
    }

    _setLoading();
    _searchQuery = 'Placa: ${licensePlate.toUpperCase()}';

    try {
      final result = await _consultVehiclesUseCase.getVehicleByLicensePlate(licensePlate);
      
      if (result.isSuccess) {
        _vehicles = result.vehicles;
        _totalFound = result.totalFound;
        _selectedVehicle = result.vehicles.isNotEmpty ? result.vehicles.first : null;
        
        if (_vehicles.isEmpty) {
          _setState(VehicleConsultState.empty);
        } else {
          _setState(VehicleConsultState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error al buscar vehículo por placa');
      }
    } catch (e) {
      _setError('Error al buscar vehículo: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Aplica filtros a la consulta de vehículos
  Future<void> applyFilters(VehicleFilter filter) async {
    _setLoading();
    _currentFilter = filter;
    _searchQuery = 'Filtros aplicados';

    try {
      final result = await _consultVehiclesUseCase.getVehiclesFiltered(filter);
      
      if (result.isSuccess) {
        _vehicles = result.vehicles;
        _totalFound = result.totalFound;
        _selectedVehicle = null;
        
        if (_vehicles.isEmpty) {
          _setState(VehicleConsultState.empty);
        } else {
          _setState(VehicleConsultState.loaded);
        }
      } else {
        _setError(result.error ?? 'Error al aplicar filtros');
      }
    } catch (e) {
      _setError('Error al filtrar vehículos: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Verifica si existe un vehículo con una placa específica
  Future<bool> checkVehicleExists(String licensePlate) async {
    if (licensePlate.trim().isEmpty) {
      return false;
    }

    try {
      final result = await _consultVehiclesUseCase.checkVehicleExists(licensePlate);
      return result.exists;
    } catch (e) {
      return false;
    }
  }

  /// Carga las estadísticas de vehículos
  Future<void> loadVehicleStats() async {
    try {
      final result = await _consultVehiclesUseCase.getVehicleStats();
      
      if (result.isSuccess && result.stats != null) {
        _vehicleStats = result.stats;
        notifyListeners();
      }
    } catch (e) {
      // Silencioso para estadísticas, no afecta el estado principal
    }
  }

  /// Inicia el stream de vehículos en tiempo real
  void startVehicleStream() {
    if (_isStreamActive) return;

    _isStreamActive = true;
    _consultVehiclesUseCase.watchAllActiveVehicles().listen(
      (vehicles) {
        _vehicles = vehicles;
        _totalFound = vehicles.length;
        
        if (_vehicles.isEmpty) {
          _setState(VehicleConsultState.empty);
        } else {
          _setState(VehicleConsultState.loaded);
        }
        
        notifyListeners();
      },
      onError: (error) {
        _setError('Error en stream de vehículos: ${error.toString()}');
        _isStreamActive = false;
        notifyListeners();
      },
    );
  }

  /// Detiene el stream de vehículos
  void stopVehicleStream() {
    _isStreamActive = false;
  }

  /// Selecciona un vehículo específico
  void selectVehicle(Vehicle? vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  /// Limpia los resultados y resetea a estado inicial
  void clearResults() {
    _vehicles = [];
    _selectedVehicle = null;
    _errorMessage = null;
    _searchQuery = null;
    _currentFilter = const VehicleFilter();
    _vehicleStats = null;
    _totalFound = 0;
    _state = VehicleConsultState.initial;
    stopVehicleStream();
    notifyListeners();
  }

  /// Resetea solo el estado de error manteniendo los datos
  void resetErrorState() {
    if (_state == VehicleConsultState.error) {
      _errorMessage = null;
      if (_vehicles.isNotEmpty) {
        _state = VehicleConsultState.loaded;
      } else {
        _state = VehicleConsultState.initial;
      }
      notifyListeners();
    }
  }

  /// Limpia solo los filtros actuales
  void clearFilters() {
    _currentFilter = const VehicleFilter();
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
        await searchVehicleById(id);
        return;
      }
    }

    if (hasSearchQuery && _searchQuery!.startsWith('Placa:')) {
      final plate = _searchQuery!.replaceFirst('Placa:', '').trim();
      await searchVehicleByPlate(plate);
      return;
    }

    if (hasActiveFilters) {
      await applyFilters(_currentFilter);
      return;
    }

    await loadAllVehicles();
  }

  // Métodos privados

  void _setLoading() {
    _state = VehicleConsultState.loading;
    _errorMessage = null;
  }

  void _setState(VehicleConsultState newState) {
    _state = newState;
    _errorMessage = null;
  }

  void _setError(String message) {
    _state = VehicleConsultState.error;
    _errorMessage = message;
    _vehicles = [];
    _selectedVehicle = null;
    _totalFound = 0;
  }

  bool _hasActiveFilters() {
    return _currentFilter.brand != null ||
           _currentFilter.model != null ||
           _currentFilter.year != null ||
           _currentFilter.status != null ||
           _currentFilter.hasDriver != null ||
           _currentFilter.minMileage != null ||
           _currentFilter.maxMileage != null;
  }

  @override
  void dispose() {
    stopVehicleStream();
    super.dispose();
  }
}