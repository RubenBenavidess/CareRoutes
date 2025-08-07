import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'maintenance_details_dao.g.dart';

@DriftAccessor(tables: [MaintenanceDetails])
class MaintenanceDetailsDao extends DatabaseAccessor<AppDatabase>
    with _$MaintenanceDetailsDaoMixin {
  final AppDatabase db;
  MaintenanceDetailsDao(this.db) : super(db);

  Future<List<MaintenanceDetail>> getAllActiveDetails() =>
      (select(maintenanceDetails)..where((t) => t.isActive.equals(true))).get();

  Stream<List<MaintenanceDetail>> watchAllActiveDetails() =>
      (select(maintenanceDetails)
        ..where((t) => t.isActive.equals(true))).watch();

  Future<MaintenanceDetail?> getDetailById(int id) =>
      (select(maintenanceDetails)..where(
        (t) => t.idDetail.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertMaintenanceDetail(MaintenanceDetailsCompanion entry) =>
      into(maintenanceDetails).insert(entry);

  Future<bool> updateMaintenanceDetail(MaintenanceDetail detail) =>
      update(maintenanceDetails).replace(detail);

  Future<int> softDeleteMaintenanceDetail(int id) => (update(maintenanceDetails)
    ..where(
      (t) => t.idDetail.equals(id),
    )).write(const MaintenanceDetailsCompanion(isActive: Value(false)));

  // En MaintenanceDetailsDao
  Future<List<MaintenanceDetail>> getDetailsByMaintenanceId(int maintenanceId) =>
    (select(maintenanceDetails)..where(
      (t) => t.idMaintenance.equals(maintenanceId) & t.isActive.equals(true),
    )).get();
}
