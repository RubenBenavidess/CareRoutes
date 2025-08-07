import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'stops_dao.g.dart';

@DriftAccessor(tables: [Stops])
class StopsDao extends DatabaseAccessor<AppDatabase> with _$StopsDaoMixin {
  final AppDatabase db;
  StopsDao(this.db) : super(db);

  Future<List<Stop>> getAllActive() =>
      (select(stops)..where((t) => t.isActive.equals(true))).get();

  Stream<List<Stop>> watchAllActive() =>
      (select(stops)..where((t) => t.isActive.equals(true))).watch();

  Future<Stop?> getStopById(int id) =>
      (select(stops)..where(
        (t) => t.idStop.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertStop(StopsCompanion entity) => into(stops).insert(entity);

  Future<bool> updateStop(Stop entity) => update(stops).replace(entity);

  Future<int> softDeleteStop(int id) => (update(stops)..where(
    (t) => t.idStop.equals(id),
  )).write(const StopsCompanion(isActive: Value(false)));

  Future<List<Stop>> getStopsByRoute(int id) =>
      (select(stops)..where(
        (t) => t.idRoute.equals(id) & t.isActive.equals(true),
      )).get();

  Future<List<Stop>> getStopsByRouteIdOrdered(int id) async {
    final query = select(stops)
      ..where((t) => t.idRoute.equals(id) & t.isActive.equals(true))
      ..orderBy([
        (t) => OrderingTerm(expression: t.idRoute, mode: OrderingMode.asc),
      ]);

    return query.get();
  }

  Future<void> deleteStopsByRouteId(int routeId) async {
    await (delete(stops)..where((t) => t.idRoute.equals(routeId))).go();
  }

  Future<List<Stop>> getStopsByRouteId(int routeId) async {
    final query = select(stops)
      ..where((t) => t.idRoute.equals(routeId) & t.isActive.equals(true));

    return query.get();
  }
}
