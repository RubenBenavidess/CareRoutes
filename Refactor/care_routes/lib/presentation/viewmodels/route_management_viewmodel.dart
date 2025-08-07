import 'package:flutter/material.dart';
import '../../../domain/use_cases/create_route_usecase.dart';
import '../../../domain/use_cases/assign_route_usecase.dart';
import '../../../domain/use_cases/search_route_usecase.dart';
import '../../../domain/use_cases/manage_route_assginments_usecase.dart';
import '../../../domain/entities/domain_entities.dart';

enum RouteManagementState {
  initial,
  creatingRoute,
  assigningVehicle,
  searching,
  loading,
  success,
  error,
}

class RouteManagementViewModel extends ChangeNotifier {
  final CreateRouteUseCase _createRouteUseCase;
  final AssignRouteUseCase _assignRouteUseCase;
  final SearchRoutesUseCase _searchRoutesUseCase;
  final ManageRouteAssignmentsUseCase _manageAssignmentsUseCase;

  RouteManagementViewModel({
    required CreateRouteUseCase createRouteUseCase,
    required AssignRouteUseCase assignRouteUseCase,
    required SearchRoutesUseCase searchRoutesUseCase,
    required ManageRouteAssignmentsUseCase manageAssignmentsUseCase,
  }) : _createRouteUseCase = createRouteUseCase,
        _assignRouteUseCase = assignRouteUseCase,
        _searchRoutesUseCase = searchRoutesUseCase,
        _manageAssignmentsUseCase = manageAssignmentsUseCase;

  // Estado del ViewModel
  RouteManagementState _state = RouteManagementState.initial;
  String? _errorMessage;
  
  // Datos de la ruta actual
  String _routeName = '';
  String _routeDescription = '';
  final List<Stop> _stops = [];
  int? _currentRouteId;
  RouteWithStops? _currentRoute;
  
  // Datos de asignación
  int? _selectedVehicleId;
  DateTime? _selectedDate;
  final List<RouteAssignmentWithDetails> _assignments = [];
  
  // Búsqueda
  String _searchQuery = '';
  final List<RouteWithStops> _searchResults = [];

  // Getters públicos
  RouteManagementState get state => _state;
  String? get errorMessage => _errorMessage;
  String get routeName => _routeName;
  String get routeDescription => _routeDescription;
  List<Stop> get stops => List.unmodifiable(_stops);
  int? get currentRouteId => _currentRouteId;
  RouteWithStops? get currentRoute => _currentRoute;
  int? get selectedVehicleId => _selectedVehicleId;
  DateTime? get selectedDate => _selectedDate;
  List<RouteAssignmentWithDetails> get assignments => List.unmodifiable(_assignments);
  String get searchQuery => _searchQuery;
  List<RouteWithStops> get searchResults => List.unmodifiable(_searchResults);

  // Getters de conveniencia
  bool get isLoading => _state == RouteManagementState.loading;
  bool get canCreateRoute => _routeName.trim().isNotEmpty && _stops.length >= 2;
  bool get canAssignVehicle => _currentRouteId != null && _selectedVehicleId != null && _selectedDate != null;
  bool get hasCurrentRoute => _currentRoute != null;
  int get stopsCount => _stops.length;

  // Métodos para gestionar la ruta
  void updateRouteName(String name) {
    if (_routeName != name) {
      _routeName = name;
      notifyListeners();
    }
  }

  void updateRouteDescription(String description) {
    if (_routeDescription != description) {
      _routeDescription = description;
      notifyListeners();
    }
  }

  void addStop(Stop stop) {
    _stops.add(stop);
    notifyListeners();
  }

  void removeStop(int index) {
    if (index >= 0 && index < _stops.length) {
      _stops.removeAt(index);
      notifyListeners();
    }
  }

  void updateStop(int index, Stop stop) {
    if (index >= 0 && index < _stops.length) {
      _stops[index] = stop;
      notifyListeners();
    }
  }

  void reorderStops(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _stops.removeAt(oldIndex);
    _stops.insert(newIndex, item);
    notifyListeners();
  }

  void clearStops() {
    _stops.clear();
    notifyListeners();
  }

  // Métodos para gestionar asignaciones
  void setSelectedVehicle(int vehicleId) {
    _selectedVehicleId = vehicleId;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearSelection() {
    _selectedVehicleId = null;
    _selectedDate = null;
    notifyListeners();
  }

  // Crear ruta
  Future<void> createRoute() async {
    if (!canCreateRoute) {
      _setError('Datos insuficientes para crear la ruta');
      return;
    }

    _setState(RouteManagementState.creatingRoute);

    try {

      final result = await _createRouteUseCase.execute(
        routeName: _routeName,
        stops: _stops,
      );

      if (result.success) {
        _currentRouteId = result.routeId;
        _setState(RouteManagementState.success);
        await loadCurrentRoute();
      } else {
        _setError(result.errorMessage ?? 'Error desconocido al crear la ruta');
      }
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
  }

  // Asignar vehículo a ruta
  Future<void> assignVehicleToRoute() async {
    if (!canAssignVehicle) {
      _setError('Selecciona un vehículo y fecha para la asignación');
      return;
    }

    _setState(RouteManagementState.assigningVehicle);

    try {
      final result = await _assignRouteUseCase.execute(
        routeId: _currentRouteId!,
        vehicleId: _selectedVehicleId!,
        scheduledDate: _selectedDate!,
      );

      if (result.success) {
        _setState(RouteManagementState.success);
        clearSelection();
        await loadAssignments();
      } else {
        _setError(result.errorMessage ?? 'Error desconocido al asignar vehículo');
      }
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
  }

  // Buscar rutas
  Future<void> searchRoutes({String? query}) async {
    _searchQuery = query ?? '';
    _setState(RouteManagementState.searching);

    try {
      final results = await _searchRoutesUseCase.execute(searchTerm: _searchQuery);
      _searchResults.clear();
      _searchResults.addAll(results);
      _setState(RouteManagementState.success);
    } catch (e) {
      _setError('Error en la búsqueda: ${e.toString()}');
    }
  }

  // Cargar ruta específica
  Future<void> loadRoute(int routeId) async {
    _setState(RouteManagementState.loading);

    try {
      final route = await _searchRoutesUseCase.getRouteById(routeId);
      if (route != null) {
        _currentRoute = route;
        _currentRouteId = routeId;
        _routeName = route.route.name;
        
        // Cargar stops en el formato interno
        _stops.clear();
        for (final stop in route.stops) {
          _stops.add(Stop(
            id: stop.id,
            routeId: routeId,
            latitude: stop.latitude,
            longitude: stop.longitude,
            isActive: stop.isActive,));
        }
        
        await loadAssignments();
        _setState(RouteManagementState.success);
      } else {
        _setError('Ruta no encontrada');
      }
    } catch (e) {
      _setError('Error al cargar ruta: ${e.toString()}');
    }
  }

  // Cargar asignaciones de la ruta actual
  Future<void> loadAssignments() async {
    if (_currentRouteId == null) return;

    try {
      final assignmentsList = await _manageAssignmentsUseCase.getAssignmentsByRoute(_currentRouteId!);
      _assignments.clear();
      _assignments.addAll(assignmentsList);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading assignments: ${e.toString()}');
    }
  }

  // Actualizar fecha de asignación
  Future<void> updateAssignmentDate(int assignmentId, DateTime newDate) async {
    try {
      final success = await _manageAssignmentsUseCase.updateAssignmentDate(
        assignmentId: assignmentId,
        newDate: newDate,
      );

      if (success) {
        await loadAssignments(); // Recargar para ver cambios
      } else {
        _setError('No se pudo actualizar la fecha');
      }
    } catch (e) {
      _setError('Error al actualizar fecha: ${e.toString()}');
    }
  }

  // Eliminar asignación
  Future<void> deleteAssignment(int assignmentId) async {
    try {
      final success = await _manageAssignmentsUseCase.deleteAssignment(assignmentId);
      if (success) {
        await loadAssignments(); // Recargar para ver cambios
      } else {
        _setError('No se pudo eliminar la asignación');
      }
    } catch (e) {
      _setError('Error al eliminar asignación: ${e.toString()}');
    }
  }

  // Limpiar ruta actual
  void clearCurrentRoute() {
    _currentRoute = null;
    _currentRouteId = null;
    _routeName = '';
    _routeDescription = '';
    _stops.clear();
    _assignments.clear();
    clearSelection();
    _setState(RouteManagementState.initial);
  }

  // Resetear estado
  void resetState() {
    _state = RouteManagementState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Cargar ruta actual desde la BD
  Future<void> loadCurrentRoute() async {
    if (_currentRouteId != null) {
      await loadRoute(_currentRouteId!);
    }
  }

  void _setState(RouteManagementState newState) {
    _state = newState;
    if (newState != RouteManagementState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = RouteManagementState.error;
    _errorMessage = message;
    notifyListeners();
  }
}

extension RouteManagementViewModelHelpers on RouteManagementViewModel {
  bool get isCreatingRoute => state == RouteManagementState.creatingRoute;
  bool get isAssigningVehicle => state == RouteManagementState.assigningVehicle;
  bool get isSearching => state == RouteManagementState.searching;
  bool get hasError => state == RouteManagementState.error;
  bool get isSuccess => state == RouteManagementState.success;
  
  String get stateDisplayName {
    switch (state) {
      case RouteManagementState.initial:
        return 'Inicial';
      case RouteManagementState.creatingRoute:
        return 'Creando ruta...';
      case RouteManagementState.assigningVehicle:
        return 'Asignando vehículo...';
      case RouteManagementState.searching:
        return 'Buscando rutas...';
      case RouteManagementState.loading:
        return 'Cargando...';
      case RouteManagementState.success:
        return 'Éxito';
      case RouteManagementState.error:
        return 'Error';
    }
  }
}