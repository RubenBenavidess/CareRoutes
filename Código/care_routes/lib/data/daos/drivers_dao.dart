import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'drivers_dao.g.dart';

@DriftAccessor(tables: [Drivers])
class DriversDao extends DatabaseAccessor<AppDatabase> with _$DriversDaoMixin {
  final AppDatabase db;
  DriversDao(this.db) : super(db);

  Future<List<Driver>> getAllActive() =>
      (select(drivers)..where((t) => t.isActive.equals(true))).get();

  Stream<List<Driver>> watchAllActive() =>
      (select(drivers)..where((t) => t.isActive.equals(true))).watch();

  Future<Driver?> getDriverById(int id) =>
      (select(drivers)..where(
        (t) => t.idDriver.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertDriver(DriversCompanion entity) =>
      into(drivers).insert(entity);

  Future<bool> updateDriver(Driver entity) => update(drivers).replace(entity);

  Future<int> softDeleteDriver(int id) => (update(drivers)..where(
    (t) => t.idDriver.equals(id),
  )).write(const DriversCompanion(isActive: Value(false)));
}
