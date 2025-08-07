// manage_route_assignments_usecase.dart
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/route_assignments_dao.dart';

class RouteAssignmentWithDetails {
  final RouteAssignment assignment;
  final Route route;
  final Vehicle vehicle;
  final Driver? driver;

  RouteAssignmentWithDetails({
    required this.assignment,
    required this.route,
    required this.vehicle,
    this.driver,
  });
}

class ManageRouteAssignmentsUseCase {
  final RouteAssignmentsDao _routeAssignmentsDao;

  ManageRouteAssignmentsUseCase({
    required RouteAssignmentsDao routeAssignmentsDao,
  }) : _routeAssignmentsDao = routeAssignmentsDao;

  Future<List<RouteAssignmentWithDetails>> getAssignmentsByRoute(int routeId) async {
    try {
      return await _routeAssignmentsDao.getAssignmentsByRouteWithDetails(routeId);
    } catch (e) {
      throw Exception('Error al obtener asignaciones: ${e.toString()}');
    }
  }

  Future<bool> updateAssignmentDate({
    required int assignmentId,
    required DateTime newDate,
  }) async {
    try {
      if (newDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        throw Exception('La nueva fecha no puede ser en el pasado');
      }

      return await _routeAssignmentsDao.updateScheduledDate(assignmentId, newDate);
    } catch (e) {
      throw Exception('Error al actualizar fecha: ${e.toString()}');
    }
  }

  Future<bool> deleteAssignment(int assignmentId) async {
    try {
      return await _routeAssignmentsDao.softDeleteRouteAssignment(assignmentId) > 0;
    } catch (e) {
      throw Exception('Error al eliminar asignación: ${e.toString()}');
    }
  }
}