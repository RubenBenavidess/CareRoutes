import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'routes_dao.g.dart';

@DriftAccessor(tables: [Routes])
class RoutesDao extends DatabaseAccessor<AppDatabase> with _$RoutesDaoMixin {
  final AppDatabase db;
  RoutesDao(this.db) : super(db);

  Future<List<Route>> getAllActiveRoutes() =>
      (select(routes)..where((t) => t.isActive.equals(true))).get();

  Stream<List<Route>> watchAllActiveRoutes() =>
      (select(routes)..where((t) => t.isActive.equals(true))).watch();

  Future<Route?> getRouteById(int id) =>
      (select(routes)..where(
        (t) => t.idRoute.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertRoute(RoutesCompanion entry) => into(routes).insert(entry);

  Future<bool> updateRoute(Route route) => update(routes).replace(route);

  Future<bool> updateRouteE(RoutesCompanion entity) =>
      update(routes).replace(entity);

  Future<int> softDeleteRoute(int id) => (update(routes)..where(
    (t) => t.idRoute.equals(
      id,
    ), // or (t) => t.routeID.equals(id), depending on your table definition
  )).write(const RoutesCompanion(isActive: Value(false)));

  Future<List<Route>> searchRoutes(String trim) =>
      (select(routes)..where(
        (t) => t.name.contains(trim) & t.isActive.equals(true),
      )).get();
}
