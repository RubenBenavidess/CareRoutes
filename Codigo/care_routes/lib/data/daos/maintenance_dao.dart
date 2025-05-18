import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'maintenance_dao.g.dart';

@DriftAccessor(tables: [Maintenances])
class MaintenancesDao extends DatabaseAccessor<AppDatabase>
    with _$MaintenancesDaoMixin {
  final AppDatabase db;
  MaintenancesDao(this.db) : super(db);

  Future<List<Maintenance>> getAllActiveMaintenances() =>
      (select(maintenances)..where((t) => t.isActive.equals(true))).get();

  Stream<List<Maintenance>> watchAllActiveMaintenances() =>
      (select(maintenances)..where((t) => t.isActive.equals(true))).watch();

  Future<Maintenance?> getMaintenanceById(int id) =>
      (select(maintenances)..where(
        (t) => t.idMaintenance.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertMaintenance(MaintenancesCompanion entry) =>
      into(maintenances).insert(entry);

  Future<bool> updateMaintenance(Maintenance maintenance) =>
      update(maintenances).replace(maintenance);

  Future<int> softDeleteMaintenance(int id) => (update(maintenances)..where(
    (t) => t.idMaintenance.equals(id),
  )).write(const MaintenancesCompanion(isActive: Value(false)));
}
