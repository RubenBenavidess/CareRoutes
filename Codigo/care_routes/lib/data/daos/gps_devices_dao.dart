import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'gps_devices_dao.g.dart';

@DriftAccessor(tables: [GpsDevices])
class GpsDevicesDao extends DatabaseAccessor<AppDatabase>
    with _$GpsDevicesDaoMixin {
  final AppDatabase db;
  GpsDevicesDao(this.db) : super(db);

  Future<List<GpsDevice>> getAllActive() =>
      (select(gpsDevices)..where((t) => t.isActive.equals(true))).get();

  Stream<List<GpsDevice>> watchAllActive() =>
      (select(gpsDevices)..where((t) => t.isActive.equals(true))).watch();

  Future<GpsDevice?> getDeviceById(int id) =>
      (select(gpsDevices)..where(
        (t) => t.idGps.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertDevice(GpsDevicesCompanion entity) =>
      into(gpsDevices).insert(entity);

  Future<bool> updateDevice(GpsDevice entity) =>
      update(gpsDevices).replace(entity);

  Future<int> softDeleteDevice(int id) => (update(gpsDevices)..where(
    (t) => t.idGps.equals(id),
  )).write(const GpsDevicesCompanion(isActive: Value(false)));
}
