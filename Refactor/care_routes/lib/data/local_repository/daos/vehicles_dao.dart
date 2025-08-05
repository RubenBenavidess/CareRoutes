import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'vehicles_dao.g.dart';

@DriftAccessor(tables: [Vehicles, Drivers])
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

  Future<List<String>> getAllLicensePlates() async {
    final query = selectOnly(vehicles)
      ..addColumns([vehicles.licensePlate])
      ..where(vehicles.isActive.equals(true));
    
    final result = await query.get();
    return result
        .map((row) => row.read(vehicles.licensePlate) ?? '')
        .where((plate) => plate.isNotEmpty)
        .map((plate) => plate.toUpperCase())
        .toList();
  }

  Future<Vehicle?> getVehicleByLicensePlate(String licensePlate) =>
      (select(vehicles)..where(
        (t) => t.licensePlate.upper().equals(licensePlate.toUpperCase()) &
                t.isActive.equals(true),
      )).getSingleOrNull();

  Future<bool> existsVehicleWithPlate(String licensePlate) async {
    final query = selectOnly(vehicles)
      ..addColumns([vehicles.idVehicle])
      ..where(vehicles.licensePlate.upper().equals(licensePlate.toUpperCase()) &
              vehicles.isActive.equals(true))
      ..limit(1);
    
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<List<Vehicle>> getAllVehicles() =>
      (select(vehicles)..where((t) => t.isActive.equals(true))).get();
}