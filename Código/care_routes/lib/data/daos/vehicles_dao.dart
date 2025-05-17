import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'vehicles_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehiclesDao extends DatabaseAccessor<AppDatabase>
    with _$VehiclesDaoMixin {
  final AppDatabase db;
  VehiclesDao(this.db) : super(db);

  Future<List<Vehicle>> getAllActive() =>
      (select(vehicles)..where((t) => t.isActive.equals(true))).get();

  Stream<List<Vehicle>> watchAllActive() =>
      (select(vehicles)..where((t) => t.isActive.equals(true))).watch();

  Future<Vehicle?> getVehicleById(int id) =>
      (select(vehicles)..where(
        (t) => t.idVehicle.equals(id) & t.isActive.equals(true),
      )).getSingleOrNull();

  Future<int> insertVehicle(VehiclesCompanion entity) =>
      into(vehicles).insert(entity);

  Future<bool> updateVehicle(Vehicle entity) =>
      update(vehicles).replace(entity);

  Future<int> softDeleteVehicle(int id) => (update(vehicles)..where(
    (t) => t.idVehicle.equals(id),
  )).write(const VehiclesCompanion(isActive: Value(false)));
}
