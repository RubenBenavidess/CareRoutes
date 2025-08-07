// domain/use_cases/get_assigned_vehicles_usecase.dart
import 'package:care_routes/data/local_repository/mappers.dart';
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/daos/route_assignments_dao.dart';

class VehicleWithAssignmentCount {
  final Vehicle vehicle;
  final int assignmentCount;
  final int activeAssignmentCount;
  final DateTime? lastAssignmentDate;

  VehicleWithAssignmentCount({
    required this.vehicle,
    required this.assignmentCount,
    required this.activeAssignmentCount,
    this.lastAssignmentDate,
  });
}

class GetAssignedVehiclesUseCase {
  final VehiclesDao _vehiclesDao;
  final RouteAssignmentsDao _assignmentsDao;

  GetAssignedVehiclesUseCase({
    required VehiclesDao vehiclesDao,
    required RouteAssignmentsDao assignmentsDao,
  }) : _vehiclesDao = vehiclesDao,
        _assignmentsDao = assignmentsDao;

  Future<List<VehicleWithAssignmentCount>> execute() async {
    try {
      // Obtener todas las asignaciones
      final assignmentEntities = await _assignmentsDao.getAllActiveRouteAssignments();
      final assignments = assignmentEntities.map((e) => e.toDomain()).toList();

      // Agrupar asignaciones por vehículo y calcular estadísticas
      final Map<int, List<RouteAssignment>> vehicleAssignmentsMap = {};
      for (final assignment in assignments) {
        if (!vehicleAssignmentsMap.containsKey(assignment.vehicleId)) {
          vehicleAssignmentsMap[assignment.vehicleId] = [];
        }
        vehicleAssignmentsMap[assignment.vehicleId]!.add(assignment);
      }

      // Construir lista de vehículos con estadísticas
      List<VehicleWithAssignmentCount> vehiclesWithCounts = [];
      final now = DateTime.now();

      for (final vehicleId in vehicleAssignmentsMap.keys) {
        // Obtener información del vehículo
        final vehicleEntity = await _vehiclesDao.getVehicleById(vehicleId);
        if (vehicleEntity != null) {
          final vehicle = vehicleEntity.toDomain();
          final vehicleAssignments = vehicleAssignmentsMap[vehicleId]!;

          // Calcular estadísticas
          final totalCount = vehicleAssignments.length;
          final activeCount = vehicleAssignments.where((assignment) {
            return assignment.assignedDate.isAfter(now.subtract(const Duration(days: 1)));
          }).length;

          // Encontrar la fecha de la asignación más reciente
          DateTime? lastAssignmentDate;
          if (vehicleAssignments.isNotEmpty) {
            vehicleAssignments.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
            lastAssignmentDate = vehicleAssignments.first.assignedDate;
          }

          vehiclesWithCounts.add(VehicleWithAssignmentCount(
            vehicle: vehicle,
            assignmentCount: totalCount,
            activeAssignmentCount: activeCount,
            lastAssignmentDate: lastAssignmentDate,
          ));
        }
      }

      // Ordenar por placa del vehículo
      vehiclesWithCounts.sort((a, b) => 
          a.vehicle.licensePlate.compareTo(b.vehicle.licensePlate));

      return vehiclesWithCounts;
    } catch (e) {
      throw Exception('Error al obtener vehículos asignados: ${e.toString()}');
    }
  }

  // Método adicional para obtener solo vehículos con asignaciones activas
  Future<List<VehicleWithAssignmentCount>> getVehiclesWithActiveAssignments() async {
    try {
      final allVehicles = await execute();
      
      // Filtrar solo vehículos que tienen asignaciones activas (futuras o recientes)
      final now = DateTime.now();
      final cutoffDate = now.subtract(const Duration(days: 30)); // Últimos 30 días
      
      return allVehicles.where((vehicleWithCount) {
        return vehicleWithCount.activeAssignmentCount > 0 ||
                (vehicleWithCount.lastAssignmentDate != null &&
                vehicleWithCount.lastAssignmentDate!.isAfter(cutoffDate));
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener vehículos con asignaciones activas: ${e.toString()}');
    }
  }

  // Método adicional para estadísticas rápidas
  Future<Map<String, int>> getVehicleAssignmentStats() async {
    try {
      final vehicles = await execute();
      
      final totalVehiclesWithAssignments = vehicles.length;
      final totalAssignments = vehicles.fold(0, (sum, v) => sum + v.assignmentCount);
      final totalActiveAssignments = vehicles.fold(0, (sum, v) => sum + v.activeAssignmentCount);
      
      return {
        'totalVehiclesWithAssignments': totalVehiclesWithAssignments,
        'totalAssignments': totalAssignments,
        'totalActiveAssignments': totalActiveAssignments,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: ${e.toString()}');
    }
  }
}