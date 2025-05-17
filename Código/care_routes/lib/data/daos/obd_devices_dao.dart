import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'obd_devices_dao.g.dart';

@DriftAccessor(tables: [ObdDevices])
class ObdDevicesDao extends DatabaseAccessor<AppDatabase>
    with _$ObdDevicesDaoMixin {
  final AppDatabase db;
  ObdDevicesDao(this.db) : super(db);

  Future<List<ObdDevice>> getAllActive() =>
      (select(obdDevices)..where((t) => t.isActive.equals(true))).get();

  Stream<List<ObdDevice>> watchAllActive() =>
      (select(obdDevices)..where((t) => t.isActive.equals(true))).watch();

  Future<ObdDevice?> getDeviceById(int id) =>
      (select(obdDevices)..where(
        (t) => t.idObd.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertDevice(ObdDevicesCompanion entity) =>
      into(obdDevices).insert(entity);

  Future<bool> updateDevice(ObdDevice entity) =>
      update(obdDevices).replace(entity);

  Future<int> softDeleteDevice(int id) => (update(obdDevices)..where(
    (t) => t.idObd.equals(id),
  )).write(const ObdDevicesCompanion(isActive: Value(false)));
}
