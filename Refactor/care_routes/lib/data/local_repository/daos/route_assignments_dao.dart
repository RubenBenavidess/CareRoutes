import 'package:care_routes/domain/use_cases/manage_route_assginments_usecase.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';
import '../mappers.dart';
part 'route_assignments_dao.g.dart';

@DriftAccessor(tables: [RouteAssignments])
class RouteAssignmentsDao extends DatabaseAccessor<AppDatabase> with _$RouteAssignmentsDaoMixin {
  final AppDatabase db;
  RouteAssignmentsDao(this.db) : super(db);

  Future<List<RouteAssignment>> getAllActiveRouteAssignments() =>
      (select(routeAssignments)..where((t) => t.isActive.equals(true))).get();

  Stream<List<RouteAssignment>> watchAllActiveRouteAssignments() =>
      (select(routeAssignments)..where((t) => t.isActive.equals(true))).watch();

  Future<RouteAssignment?> getRouteAssigmentById(int id) =>
      (select(routeAssignments)..where(
        (t) => t.idAssignment.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertRouteAssignment(RouteAssignmentsCompanion entry) => into(routeAssignments).insert(entry);

  Future<bool> updateRouteAssignmentS(RouteAssignment assigment) => update(routeAssignments).replace(assigment);

  Future<int> softDeleteRouteAssignment(int id) => (update(routeAssignments)..where(
    (t) => t.idAssignment.equals(
      id,
    ),
  )).write(const RouteAssignmentsCompanion(isActive: Value(false)));

  Future<RouteAssignment?> getAssignmentsByVehicleAndDate(int vehicleId, DateTime scheduledDate) =>
      (select(routeAssignments)..where(
        (t) => t.idVehicle.equals(vehicleId) & 
                t.assignedDate.equals(scheduledDate) & 
                t.isActive.equals(true),
      )).getSingleOrNull();

  Future<List<RouteAssignmentWithDetails>> getAssignmentsByRouteWithDetails(int routeId) async {
    final query = select(routeAssignments).join([
      innerJoin(db.routes, db.routes.idRoute.equalsExp(routeAssignments.idRoute)),
      innerJoin(db.vehicles, db.vehicles.idVehicle.equalsExp(routeAssignments.idVehicle)),
      leftOuterJoin(db.drivers, db.drivers.idDriver.equalsExp(vehicles.idDriver)),
    ])
    ..where(routeAssignments.idRoute.equals(routeId) & routeAssignments.isActive.equals(true));

    final results = await query.get();

    return results.map((row) {
      final assignment = row.readTable(routeAssignments).toDomain();
      final route = row.readTable(db.routes).toDomain();
      final vehicle = row.readTable(db.vehicles).toDomain();
      final driverTable = row.readTableOrNull(db.drivers);
      final driver = driverTable?.toDomain();

      return RouteAssignmentWithDetails(
        assignment: assignment,
        route: route,
        vehicle: vehicle,
        driver: driver,
      );
    }).toList();
  }

  Future<Future<bool>> updateScheduledDate(int assignmentId, DateTime newDate) async {
    final assignment = await getRouteAssigmentById(assignmentId);
    if (assignment == null) {
      throw Exception('Asignación no encontrada');
    }

    final updatedAssignment = assignment.copyWith(
      assignedDate: newDate,
    );

    return updateRouteAssignmentS(updatedAssignment);
  }

  Future<List<RouteAssignment>> getAssignmentsByRouteId(int id) async {
    final query = select(routeAssignments)..where(
      (t) => t.idRoute.equals(id) & t.isActive.equals(true),
    );

    return query.get();
  } 
}