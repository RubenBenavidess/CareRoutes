import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'route_assigments_dao.g.dart';

@DriftAccessor(tables: [RouteAssignments])
class RouteAssigmentsDao extends DatabaseAccessor<AppDatabase> with _$RouteAssigmentsDaoMixin {
  final AppDatabase db;
  RouteAssigmentsDao(this.db) : super(db);

  Future<List<RouteAssignment>> getAllActiveRouteAssignments() =>
      (select(routeAssignments)..where((t) => t.isActive.equals(true))).get();

  Stream<List<RouteAssignment>> watchAllActiveRouteAssignments() =>
      (select(routeAssignments)..where((t) => t.isActive.equals(true))).watch();

  Future<RouteAssignment?> getRouteAssigmentById(int id) =>
      (select(routeAssignments)..where(
        (t) => t.idAssignment.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertRouteAssigment(RouteAssignmentsCompanion entry) => into(routeAssignments).insert(entry);

  Future<bool> updateRoute(RouteAssignment assigment) => update(routeAssignments).replace(assigment);

  Future<int> softDeleteRoute(int id) => (update(routeAssignments)..where(
    (t) => t.idAssignment.equals(
      id,
    ), // or (t) => t.routeID.equals(id), depending on your table definition
  )).write(const RouteAssignmentsCompanion(isActive: Value(false)));
}