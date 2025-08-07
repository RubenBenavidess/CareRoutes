// assign_route_usecase.dart
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/route_assignments_dao.dart';
import '../../data/local_repository/mappers.dart';

class AssignRouteResult {
  final int assignmentId;
  final bool success;
  final String? errorMessage;

  AssignRouteResult({
    required this.assignmentId,
    required this.success,
    this.errorMessage,
  });

  factory AssignRouteResult.success(int assignmentId) {
    return AssignRouteResult(
      assignmentId: assignmentId,
      success: true,
    );
  }

  factory AssignRouteResult.failure(String errorMessage) {
    return AssignRouteResult(
      assignmentId: -1,
      success: false,
      errorMessage: errorMessage,
    );
  }
}

class AssignRouteUseCase {
  final RouteAssignmentsDao _routeAssignmentsDao;

  AssignRouteUseCase({
    required RouteAssignmentsDao routeAssignmentsDao,
  }) : _routeAssignmentsDao = routeAssignmentsDao;

  Future<AssignRouteResult> execute({
    required int routeId,
    required int vehicleId,
    required DateTime scheduledDate,
    int? driverId,
  }) async {
    try {
      // Validaciones
      if (scheduledDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        return AssignRouteResult.failure('La fecha programada no puede ser en el pasado');
      }

      // Verificar si ya existe una asignación para ese vehículo en esa fecha
      final existingAssignments = await _routeAssignmentsDao
          .getAssignmentsByVehicleAndDate(vehicleId, scheduledDate);

      if (existingAssignments != null) {
        return AssignRouteResult.failure(
          'El vehículo ya tiene una ruta asignada para esa fecha'
        );
      }

      final assignment = RouteAssignment(
        id: 0,
        routeId: routeId,
        vehicleId: vehicleId,
        assignedDate: scheduledDate,
        isActive: true,
      );

      final assignmentId = await _routeAssignmentsDao
          .insertRouteAssignment(assignment.toCompanionInsert());

      return AssignRouteResult.success(assignmentId);

    } catch (e) {
      return AssignRouteResult.failure('Error al asignar ruta: ${e.toString()}');
    }
  }
}