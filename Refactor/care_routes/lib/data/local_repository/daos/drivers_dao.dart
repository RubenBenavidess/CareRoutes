import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'drivers_dao.g.dart';

@DriftAccessor(tables: [Drivers])
class DriversDao extends DatabaseAccessor<AppDatabase>
    with _$DriversDaoMixin {
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

  Future<bool> updateDriver(Driver entity) =>
      update(drivers).replace(entity);

  Future<int> softDeleteDriver(int id) => (update(drivers)..where(
    (t) => t.idDriver.equals(id),
  )).write(const DriversCompanion(isActive: Value(false)));

  Future<List<String>> getAllIdNumbers() async {
    final query = selectOnly(drivers)
      ..addColumns([drivers.idNumber])
      ..where(drivers.isActive.equals(true));
    
    final result = await query.get();
    return result
        .map((row) => row.read(drivers.idNumber) ?? '')
        .where((idNumber) => idNumber.isNotEmpty)
        .toList();
  }

  Future<List<Driver>> getAllDrivers() =>
      (select(drivers)..where((t) => t.isActive.equals(true))).get();

  Future<Driver?> getDriverByIdNumber(String idNumber) =>
      (select(drivers)..where(
        (t) => t.idNumber.equals(idNumber) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<bool> existsDriverWithIdNumber(String idNumber) async {
    final query = selectOnly(drivers)
      ..addColumns([drivers.idDriver])
      ..where(drivers.idNumber.equals(idNumber) & drivers.isActive.equals(true))
      ..limit(1);
    
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<List<Driver>> searchDriversByName(String searchTerm) {
    final term = '%${searchTerm.toLowerCase()}%';
    return (select(drivers)..where(
      (t) => (t.firstName.lower().like(term) | 
              t.lastName.lower().like(term)) &
              t.isActive.equals(true),
    )).get();
  }

  Future<int?> getDriverIdByIdNumber(String idNumber) async {
    final query = selectOnly(drivers)
      ..addColumns([drivers.idDriver])
      ..where(drivers.idNumber.equals(idNumber) & drivers.isActive.equals(true))
      ..limit(1);
    
    final result = await query.get();
    return result.isNotEmpty ? result.first.read(drivers.idDriver) : null;
  }

  Future<List<int>> insertDriversBatch(List<DriversCompanion> driversList) async {
    return await db.transaction(() async {
      final ids = <int>[];
      for (final driver in driversList) {
        final id = await into(drivers).insert(driver);
        ids.add(id);
      }
      return ids;
    });
  }
}