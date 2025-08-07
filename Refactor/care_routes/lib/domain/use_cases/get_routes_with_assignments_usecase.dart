// domain/use_cases/get_routes_with_assignments_usecase.dart
import '../../data/local_repository/mappers.dart';
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/routes_dao.dart';
import '../../data/local_repository/daos/stops_dao.dart';
import '../../data/local_repository/daos/route_assignments_dao.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';

class RouteWithAssignments {
  final Route route;
  final List<Stop> stops;
  List<RouteAssignmentWithVehicle> assignments;

  RouteWithAssignments({
    required this.route,
    required this.stops,
    required this.assignments,
  });
}

class RouteAssignmentWithVehicle {
  final RouteAssignment assignment;
  final Vehicle vehicle;

  RouteAssignmentWithVehicle({
    required this.assignment,
    required this.vehicle,
  });
}

class GetRoutesWithAssignmentsUseCase {
  final RoutesDao _routesDao;
  final StopsDao _stopsDao;
  final RouteAssignmentsDao _assignmentsDao;
  final VehiclesDao _vehiclesDao;

  GetRoutesWithAssignmentsUseCase({
    required RoutesDao routesDao,
    required StopsDao stopsDao,
    required RouteAssignmentsDao assignmentsDao,
    required VehiclesDao vehiclesDao,
  }) : _routesDao = routesDao,
        _stopsDao = stopsDao,
        _assignmentsDao = assignmentsDao,
        _vehiclesDao = vehiclesDao;

  Future<List<RouteWithAssignments>> execute({
    String? vehicleFilter,
    bool sortDatesAscending = true,
  }) async {
    try {
      // Obtener todas las rutas activas
      final routeEntities = await _routesDao.getAllActiveRoutes();
      final routes = routeEntities.map((e) => e.toDomain()).toList();

      List<RouteWithAssignments> routesWithAssignments = [];

      for (final route in routes) {
        // Obtener paradas de la ruta ordenadas
        final stopEntities = await _stopsDao.getStopsByRouteIdOrdered(route.id);
        final stops = stopEntities.map((e) => e.toDomain()).toList();

        // Obtener asignaciones de la ruta
        final assignmentEntities = await _assignmentsDao.getAssignmentsByRouteId(route.id);
        List<RouteAssignmentWithVehicle> assignmentsWithVehicles = [];

        for (final assignmentEntity in assignmentEntities) {
          final assignment = assignmentEntity.toDomain();
          
          // Obtener vehículo de la asignación
          final vehicleEntity = await _vehiclesDao.getVehicleById(assignment.vehicleId);
          if (vehicleEntity != null) {
            final vehicle = vehicleEntity.toDomain();
            assignmentsWithVehicles.add(RouteAssignmentWithVehicle(
              assignment: assignment,
              vehicle: vehicle,
            ));
          }
        }

        // Aplicar filtro por vehículo si existe
        if (vehicleFilter != null && vehicleFilter.trim().isNotEmpty) {
          assignmentsWithVehicles = assignmentsWithVehicles.where((assignmentWithVehicle) {
            return assignmentWithVehicle.vehicle.licensePlate
                .toLowerCase()
                .contains(vehicleFilter.toLowerCase());
          }).toList();
        }

        // Solo incluir rutas que tienen asignaciones (después del filtro si aplicó)
        if (vehicleFilter == null || vehicleFilter.trim().isEmpty || assignmentsWithVehicles.isNotEmpty) {
          // Ordenar asignaciones con lógica especial
          assignmentsWithVehicles = _sortAssignments(assignmentsWithVehicles, sortDatesAscending);

          routesWithAssignments.add(RouteWithAssignments(
            route: route,
            stops: stops,
            assignments: assignmentsWithVehicles,
          ));
        }
      }

      // Ordenar rutas por nombre
      routesWithAssignments.sort((a, b) => a.route.name.compareTo(b.route.name));

      return routesWithAssignments;
    } catch (e) {
      throw Exception('Error al obtener rutas con asignaciones: ${e.toString()}');
    }
  }

  List<RouteAssignmentWithVehicle> _sortAssignments(
    List<RouteAssignmentWithVehicle> assignments,
    bool sortAscending,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Separar asignaciones pasadas y futuras/actuales
    final pastAssignments = assignments.where((assignment) {
      final assignmentDate = DateTime(
        assignment.assignment.assignedDate.year,
        assignment.assignment.assignedDate.month,
        assignment.assignment.assignedDate.day,
      );
      return assignmentDate.isBefore(today);
    }).toList();

    final currentAndFutureAssignments = assignments.where((assignment) {
      final assignmentDate = DateTime(
        assignment.assignment.assignedDate.year,
        assignment.assignment.assignedDate.month,
        assignment.assignment.assignedDate.day,
      );
      return assignmentDate.isAtSameMomentAs(today) || assignmentDate.isAfter(today);
    }).toList();

    // Ordenar cada grupo según el parámetro
    if (sortAscending) {
      currentAndFutureAssignments.sort((a, b) =>
          a.assignment.assignedDate.compareTo(b.assignment.assignedDate));
      pastAssignments.sort((a, b) =>
          a.assignment.assignedDate.compareTo(b.assignment.assignedDate));
    } else {
      currentAndFutureAssignments.sort((a, b) =>
          b.assignment.assignedDate.compareTo(a.assignment.assignedDate));
      pastAssignments.sort((a, b) =>
          b.assignment.assignedDate.compareTo(a.assignment.assignedDate));
    }

    // REGLA IMPORTANTE: Futuras/actuales primero, pasadas siempre al final
    return [...currentAndFutureAssignments, ...pastAssignments];
  }
}