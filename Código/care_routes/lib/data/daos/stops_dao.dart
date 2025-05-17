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
}
