// presentation/viewmodels/vehicle_location_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/use_cases/vehicle_location_usecase.dart';
import '../../domain/entities/domain_entities.dart';

enum VehicleLocationState {
  initial,
  loading,
  loaded,
  error,
  noGps,
}

class VehicleLocationViewModel extends ChangeNotifier {
  final VehicleLocationUseCase _vehicleLocationUseCase;

  VehicleLocationViewModel({
    required VehicleLocationUseCase vehicleLocationUseCase,
  }) : _vehicleLocationUseCase = vehicleLocationUseCase;

  // Estado privado
  VehicleLocationState _state = VehicleLocationState.initial;
  Vehicle? _currentVehicle;
  CurrentVehicleLocation? _currentLocation;
  GpsStatusResult? _gpsStatus;
  String? _errorMessage;
  StreamSubscription? _locationSubscription;
  bool _isAutoUpdateEnabled = true;

  // Getters públicos
  VehicleLocationState get state => _state;
  Vehicle? get currentVehicle => _currentVehicle;
  CurrentVehicleLocation? get currentLocation => _currentLocation;
  GpsStatusResult? get gpsStatus => _gpsStatus;
  String? get errorMessage => _errorMessage;
  bool get isAutoUpdateEnabled => _isAutoUpdateEnabled;

  // Getters de conveniencia
  bool get isLoading => _state == VehicleLocationState.loading;
  bool get hasLocation => _currentLocation != null;
  bool get hasError => _state == VehicleLocationState.error;
  bool get hasGps => _gpsStatus?.hasGps ?? false;
  bool get isGpsOnline => _gpsStatus?.isOnline ?? false;
  String get vehicleInfo => _currentVehicle != null 
      ? '${_currentVehicle!.licensePlate} - ${_currentVehicle!.brand} ${_currentVehicle!.model ?? ''}'
      : 'Vehículo no seleccionado';

  /// Inicializa la vista con un vehículo específico
  Future<void> initializeWithVehicle(Vehicle vehicle) async {
    _currentVehicle = vehicle;
    _setLoading();

    try {
      // Verificar estado del GPS
      _gpsStatus = await _vehicleLocationUseCase.checkGpsStatus(vehicle);
      
      if (!_gpsStatus!.hasGps) {
        _setState(VehicleLocationState.noGps);
        return;
      }

      // Obtener ubicación inicial
      await _loadCurrentLocation();
      
      // Iniciar actualizaciones automáticas si está habilitado
      if (_isAutoUpdateEnabled && _gpsStatus!.isOnline) {
        _startLocationUpdates();
      }
      
    } catch (e) {
      _setError('Error al inicializar: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Carga la ubicación actual del vehículo
  Future<void> loadCurrentLocation() async {
    if (_currentVehicle == null) return;

    _setLoading();

    try {
      final result = await _vehicleLocationUseCase.getCurrentLocation(_currentVehicle!);
      
      if (result.isSuccess && result.location != null) {
        _currentLocation = result.location;
        _setState(VehicleLocationState.loaded);
      } else {
        _setError(result.error ?? 'Error desconocido');
      }
    } catch (e) {
      _setError('Error al cargar ubicación: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Alterna las actualizaciones automáticas
  void toggleAutoUpdate() {
    _isAutoUpdateEnabled = !_isAutoUpdateEnabled;
    
    if (_isAutoUpdateEnabled && _currentVehicle != null && isGpsOnline) {
      _startLocationUpdates();
    } else {
      _stopLocationUpdates();
    }
    
    notifyListeners();
  }

  /// Refresca tanto el estado del GPS como la ubicación
  Future<void> refreshAll() async {
    if (_currentVehicle == null) return;

    _setLoading();

    try {
      // Actualizar estado del GPS
      _gpsStatus = await _vehicleLocationUseCase.checkGpsStatus(_currentVehicle!);
      
      if (_gpsStatus!.hasGps && _gpsStatus!.isOnline) {
        // Cargar ubicación actual
        await _loadCurrentLocation();
        
        // Reiniciar stream si está habilitado
        if (_isAutoUpdateEnabled) {
          _stopLocationUpdates();
          _startLocationUpdates();
        }
      } else {
        _setState(VehicleLocationState.noGps);
      }
    } catch (e) {
      _setError('Error al refrescar: ${e.toString()}');
    }

    notifyListeners();
  }

  /// Limpia todos los datos y resetea el estado
  void clear() {
    _stopLocationUpdates();
    _currentVehicle = null;
    _currentLocation = null;
    _gpsStatus = null;
    _errorMessage = null;
    _state = VehicleLocationState.initial;
    notifyListeners();
  }

  // Métodos privados

  Future<void> _loadCurrentLocation() async {
    final result = await _vehicleLocationUseCase.getCurrentLocation(_currentVehicle!);
    
    if (result.isSuccess && result.location != null) {
      _currentLocation = result.location;
      _setState(VehicleLocationState.loaded);
    } else {
      _setError(result.error ?? 'Error al obtener ubicación');
    }
  }

  void _startLocationUpdates() {
    _stopLocationUpdates();
    
    if (_currentVehicle == null || !isGpsOnline) return;

    _locationSubscription = _vehicleLocationUseCase
        .watchVehicleLocation(_currentVehicle!)
        .listen(
          (result) {
            if (result.isSuccess && result.location != null) {
              _currentLocation = result.location;
              if (_state != VehicleLocationState.loaded) {
                _setState(VehicleLocationState.loaded);
              }
              notifyListeners();
            }
          },
          onError: (error) {
            _setError('Error en actualizaciones: ${error.toString()}');
            notifyListeners();
          },
        );
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _setLoading() {
    _state = VehicleLocationState.loading;
    _errorMessage = null;
  }

  void _setState(VehicleLocationState newState) {
    _state = newState;
    _errorMessage = null;
  }

  void _setError(String message) {
    _state = VehicleLocationState.error;
    _errorMessage = message;
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }
}