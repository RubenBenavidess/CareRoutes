import 'package:flutter/material.dart';
import '../../../domain/use_cases/create_route_usecase.dart';
import '../../../domain/use_cases/assign_route_usecase.dart';
import '../../../domain/use_cases/search_route_usecase.dart';
import '../../../domain/use_cases/manage_route_assginments_usecase.dart';
import '../../../domain/entities/domain_entities.dart';
import '../../domain/use_cases/get_assigned_vehicles_usecase.dart';
import '../../domain/use_cases/get_routes_with_assignments_usecase.dart';
import '../../domain/use_cases/update_route_usecase.dart';

enum RouteManagementState {
  initial,
  creatingRoute,
  assigningVehicle,
  searching,
  loading,
  success,
  error,
  loadingOverview,  // Nuevo estado para la vista de overview
  refreshingOverview, // Nuevo estado para refresh
}

// Agregar al enum existente
enum DateSortOrder {
  ascending,
  descending,
}

class RouteManagementViewModel extends ChangeNotifier {
  final CreateRouteUseCase _createRouteUseCase;
  final AssignRouteUseCase _assignRouteUseCase;
  final SearchRoutesUseCase _searchRoutesUseCase;
  final ManageRouteAssignmentsUseCase _manageAssignmentsUseCase;
  final UpdateRouteUseCase _updateRouteUseCase;
  final GetRoutesWithAssignmentsUseCase _getRoutesWithAssignmentsUseCase;
  final GetAssignedVehiclesUseCase _getAssignedVehiclesUseCase;
  
  
  // Datos para overview
  final List<RouteWithAssignments> _routesWithAssignments = [];
  final List<VehicleWithAssignmentCount> _availableVehicles = [];
  
  // Filtros y configuración para overview
  VehicleWithAssignmentCount? _selectedVehicleFilter;
  DateSortOrder _dateSortOrder = DateSortOrder.ascending;
  
  // Estado de UI para overview
  final Set<int> _expandedRoutes = <int>{};

  RouteManagementViewModel({
    required CreateRouteUseCase createRouteUseCase,
    required AssignRouteUseCase assignRouteUseCase,
    required SearchRoutesUseCase searchRoutesUseCase,
    required ManageRouteAssignmentsUseCase manageAssignmentsUseCase,
    required UpdateRouteUseCase updateRouteUseCase,
    required GetRoutesWithAssignmentsUseCase getRoutesWithAssignmentsUseCase, // Opcional
    required GetAssignedVehiclesUseCase getAssignedVehiclesUseCase, // Opcional
  }) : _createRouteUseCase = createRouteUseCase,
        _assignRouteUseCase = assignRouteUseCase,
        _searchRoutesUseCase = searchRoutesUseCase,
        _manageAssignmentsUseCase = manageAssignmentsUseCase,
        _getRoutesWithAssignmentsUseCase = getRoutesWithAssignmentsUseCase,
        _getAssignedVehiclesUseCase = getAssignedVehiclesUseCase,
        _updateRouteUseCase = updateRouteUseCase;

  // Estado del ViewModel
  RouteManagementState _state = RouteManagementState.initial;
  String? _errorMessage;

  bool _isEditMode = false;
  
  // ... constructor existente ...

  // AGREGAR: Getters faltantes para modo edición
  bool get isEditMode => _isEditMode;
  bool get canSaveRoute => _routeName.trim().isNotEmpty && _stops.length >= 2;
  String get saveButtonText => _isEditMode ? 'Actualizar Ruta' : 'Guardar Ruta';
  
  // CAMBIAR: Reemplaza canCreateRoute por canSaveRoute
  // bool get canCreateRoute => _routeName.trim().isNotEmpty && _stops.length >= 2;

  // AGREGAR: Método público para guardar (crear o actualizar)
  Future<void> saveRoute() async {
    if (!canSaveRoute) {
      _setError('Datos insuficientes para guardar la ruta');
      return;
    }

    if (_isEditMode) {
      await _updateRoute();
    } else {
      await _createNewRoute();
    }
  }

  // CAMBIAR: Renombrar createRoute a _createNewRoute y hacerlo privado
  Future<void> _createNewRoute() async {
    _setState(RouteManagementState.creatingRoute);

    try {
      final result = await _createRouteUseCase.execute(
        routeName: _routeName,
        stops: _stops,
      );

      if (result.success) {
        _currentRouteId = result.routeId;
        _isEditMode = true; // AGREGAR: Cambiar a modo edición después de crear
        _setState(RouteManagementState.success);
        await loadCurrentRoute();
      } else {
        _setError(result.errorMessage ?? 'Error desconocido al crear la ruta');
      }
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
  }

  // El método _updateRoute ya existe, solo necesita ser llamado desde saveRoute()

  // MODIFICAR: loadRoute para activar modo edición
  @override
  Future<void> loadRoute(int routeId) async {
    _setState(RouteManagementState.loading);

    try {
      final route = await _searchRoutesUseCase.getRouteById(routeId);
      if (route != null) {
        _currentRoute = route;
        _currentRouteId = routeId;
        _routeName = route.route.name;
        _isEditMode = true; // AGREGAR: Activar modo edición
        
        // Cargar stops en el formato interno
        _stops.clear();
        for (final stop in route.stops) {
          _stops.add(Stop(
            id: stop.id,
            routeId: routeId,
            latitude: stop.latitude,
            longitude: stop.longitude,
            isActive: stop.isActive,
          ));
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

  // MODIFICAR: clearCurrentRoute para resetear modo edición
  @override
  void clearCurrentRoute() {
    _currentRoute = null;
    _currentRouteId = null;
    _routeName = '';
    _routeDescription = '';
    _stops.clear();
    _assignments.clear();
    _isEditMode = false; // AGREGAR: Volver a modo creación
    
    // Limpiar datos de overview también
    _routesWithAssignments.clear();
    _availableVehicles.clear();
    _selectedVehicleFilter = null;
    _dateSortOrder = DateSortOrder.ascending;
    _expandedRoutes.clear();
    
    clearSelection();
    _setState(RouteManagementState.initial);
  }

  void startNewRoute() {
    clearCurrentRoute();
    _isEditMode = false;
    notifyListeners();
  }
  
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

  RouteWithStops? getRouteForEdit(int routeId) {
    try {
      // Opción 1: Si existe en routesWithAssignments
      final routeData = _routesWithAssignments.firstWhere(
        (r) => r.route.id == routeId,
        orElse: () => throw StateError('Route not found'),
      );
      
      return RouteWithStops(
        route: routeData.route,
        stops: routeData.stops,
      );
    } catch (e) {
      // Opción 2: Usar el método existente como fallback
      debugPrint('Route not found in overview, using existing method');
      return _currentRoute?.route.id == routeId ? _currentRoute : null;
    }
  }

  // NUEVOS métodos para overview
  Future<void> loadRoutesOverview() async {
    if (_getRoutesWithAssignmentsUseCase == null || _getAssignedVehiclesUseCase == null) {
      _setError('Funcionalidad de overview no disponible');
      return;
    }

    _setState(RouteManagementState.loadingOverview);
    await Future.wait([
      _loadAvailableVehiclesInternal(),
      _loadRoutesWithAssignmentsInternal(),
    ]);
  }

  Future<void> refreshRoutesOverview() async {
    if (_getRoutesWithAssignmentsUseCase == null || _getAssignedVehiclesUseCase == null) {
      return;
    }

    _setState(RouteManagementState.refreshingOverview);
    await Future.wait([
      _loadAvailableVehiclesInternal(),
      _loadRoutesWithAssignmentsInternal(),
    ]);
  }

  Future<void> _loadAvailableVehiclesInternal() async {
    try {
      final vehicles = await _getAssignedVehiclesUseCase!.execute();
      _availableVehicles.clear();
      _availableVehicles.addAll(vehicles);
    } catch (e) {
      debugPrint('Error loading vehicles: ${e.toString()}');
    }
  }

  // NUEVOS getters para overview
  List<RouteWithAssignments> get routesWithAssignments => List.unmodifiable(_routesWithAssignments);
  List<VehicleWithAssignmentCount> get availableVehicles => List.unmodifiable(_availableVehicles);
  VehicleWithAssignmentCount? get selectedVehicleFilter => _selectedVehicleFilter;
  DateSortOrder get dateSortOrder => _dateSortOrder;
  Set<int> get expandedRoutes => Set.unmodifiable(_expandedRoutes);
  
  // Getters de conveniencia para overview
  bool get isLoadingOverview => _state == RouteManagementState.loadingOverview;
  bool get isRefreshingOverview => _state == RouteManagementState.refreshingOverview;
  bool get hasRoutesWithAssignments => _routesWithAssignments.isNotEmpty;
  bool get hasVehicleFilter => _selectedVehicleFilter != null;
  bool get isDateSortAscending => _dateSortOrder == DateSortOrder.ascending;
  int get totalRoutesWithAssignments => _routesWithAssignments.length;
  int get totalOverviewAssignments => _routesWithAssignments.fold(0, (sum, route) => sum + route.assignments.length);
  
  String get dateSortOrderText => 
      _dateSortOrder == DateSortOrder.ascending ? 'Fechas: Más antiguas primero' : 'Fechas: Más recientes primero';
  
  String get filterStatusText {
    if (_selectedVehicleFilter != null) {
      return 'Filtrando por: ${_selectedVehicleFilter!.vehicle.licensePlate} (${_selectedVehicleFilter!.assignmentCount} asignaciones)';
    }
    return 'Mostrando todas las rutas';
  }

  Future<void> _loadRoutesWithAssignmentsInternal() async {
    try {
      final routes = await _getRoutesWithAssignmentsUseCase!.execute(
        vehicleFilter: _selectedVehicleFilter?.vehicle.licensePlate,
        sortDatesAscending: _dateSortOrder == DateSortOrder.ascending,
      );
      
      _routesWithAssignments.clear();
      _routesWithAssignments.addAll(routes);
      _setState(RouteManagementState.success);
    } catch (e) {
      _setError('Error al cargar rutas: ${e.toString()}');
    }
  }

  Future<void> setVehicleFilter(VehicleWithAssignmentCount? vehicle) async {
    if (_selectedVehicleFilter?.vehicle.id != vehicle?.vehicle.id) {
      _selectedVehicleFilter = vehicle;
      notifyListeners();
      await _loadRoutesWithAssignmentsInternal();
    }
  }

  void clearVehicleFilter() {
    setVehicleFilter(null);
  }

  // Métodos de ordenamiento para overview
  Future<void> toggleDateSortOrder() async {
    _dateSortOrder = _dateSortOrder == DateSortOrder.ascending 
        ? DateSortOrder.descending 
        : DateSortOrder.ascending;
    
    notifyListeners();
    await _loadRoutesWithAssignmentsInternal();
  }

  Future<void> setDateSortOrder(DateSortOrder order) async {
    if (_dateSortOrder != order) {
      _dateSortOrder = order;
      notifyListeners();
      await _loadRoutesWithAssignmentsInternal();
    }
  }

  void toggleRouteExpansion(int routeId) {
    if (_expandedRoutes.contains(routeId)) {
      _expandedRoutes.remove(routeId);
    } else {
      _expandedRoutes.add(routeId);
    }
    notifyListeners();
  }

  void expandRoute(int routeId) {
    if (!_expandedRoutes.contains(routeId)) {
      _expandedRoutes.add(routeId);
      notifyListeners();
    }
  }

  void collapseRoute(int routeId) {
    if (_expandedRoutes.contains(routeId)) {
      _expandedRoutes.remove(routeId);
      notifyListeners();
    }
  }

  void expandAllRoutes() {
    _expandedRoutes.clear();
    _expandedRoutes.addAll(_routesWithAssignments.map((route) => route.route.id));
    notifyListeners();
  }

  void collapseAllRoutes() {
    _expandedRoutes.clear();
    notifyListeners();
  }

  bool isRouteExpanded(int routeId) {
    return _expandedRoutes.contains(routeId);
  }

  // Métodos de utilidad para estadísticas (NUEVOS)
  int getUpcomingAssignmentsCount() {
    final now = DateTime.now();
    return _routesWithAssignments.fold(0, (count, route) {
      return count + route.assignments.where((assignment) {
        return assignment.assignment.assignedDate.isAfter(now);
      }).length;
    });
  }

  int getPastAssignmentsCount() {
    final now = DateTime.now();
    return _routesWithAssignments.fold(0, (count, route) {
      return count + route.assignments.where((assignment) {
        return assignment.assignment.assignedDate.isBefore(now);
      }).length;
    });
  }

  int getTodayAssignmentsCount() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    return _routesWithAssignments.fold(0, (count, route) {
      return count + route.assignments.where((assignment) {
        final assignmentDate = assignment.assignment.assignedDate;
        return assignmentDate.isAfter(todayStart) && assignmentDate.isBefore(todayEnd);
      }).length;
    });
  }

  // En el RouteManagementViewModel, actualiza el método _updateRoute:
  Future<void> _updateRoute() async {
    if (_currentRouteId == null) {
      _setError('No hay ruta cargada para actualizar');
      return;
    }

    _setState(RouteManagementState.creatingRoute); // Reusamos el estado

    try {
      final result = await _updateRouteUseCase.execute(
        routeId: _currentRouteId!,
        routeName: _routeName,
        stops: _stops,
      );

      if (result.success) {
        _setState(RouteManagementState.success);
        await loadCurrentRoute(); // Recargar para ver cambios
      } else {
        _setError(result.errorMessage ?? 'Error desconocido al actualizar la ruta');
      }
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
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
        return isEditMode ? 'Actualizando ruta...' : 'Creando ruta...';
      case RouteManagementState.assigningVehicle:
        return 'Asignando vehículo...';
      case RouteManagementState.searching:
        return 'Buscando rutas...';
      case RouteManagementState.loading:
        return 'Cargando...';
      case RouteManagementState.loadingOverview:
        return 'Cargando vista general...';
      case RouteManagementState.refreshingOverview:
        return 'Actualizando...';
      case RouteManagementState.success:
        return 'Éxito';
      case RouteManagementState.error:
        return 'Error';
    }
  }
}