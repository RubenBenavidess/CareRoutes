import 'package:care_routes/data/enums.dart';
import 'package:care_routes/domain/vehicle_with_driver.dart';
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


  /// Busca por placa o por nombre de conductor.
  Stream<List<VehicleWithDriver>> search(String query) {
    final veh = alias(vehicles, 'v');
    final drv = alias(drivers,  'd');

    JoinedSelectStatement stmt;

    if(query.isEmpty) {
      stmt = select(veh).join([
        innerJoin(drv, drv.idDriver.equalsExp(veh.idDriver)),
      ])
        ..where(veh.isActive.equals(true))
        ..orderBy([OrderingTerm.asc(veh.licensePlate)]);
    } else {
      stmt = select(veh).join([
      innerJoin(drv, drv.idDriver.equalsExp(veh.idDriver)),
      ])
      ..where(
        veh.isActive.equals(true) &
        (veh.licensePlate.like('%$query%') |
          veh.model.like('%$query%') |
          drv.firstName.like('%$query%')) |
          drv.lastName.like('%$query%') |
          drv.idNumber.like('%$query%'),
      )
      ..orderBy([OrderingTerm.asc(veh.licensePlate)]);
    }

    return stmt.watch().map((rows) => rows.map((row) {
          return VehicleWithDriver(
            idVehicle:       row.readTable(veh).idVehicle,
            licensePlate:       row.read(veh.licensePlate)!,
            model:       row.read(veh.model)!,
            idDriver:          row.read(veh.idDriver)!,
            driverName:  '${row.read(drv.firstName)!} ${row.read(drv.lastName)!}',
            idNumber: row.read(drv.idNumber)!,
          );
        }).toList());
  }

  Future<int> assignDriver(int vehicleId, int driverId) {
    return (update(vehicles)..where((t) => t.idVehicle.equals(vehicleId)))
        .write(VehiclesCompanion(idDriver: Value(driverId), status: Value(VehicleStatus.assigned)));
  }

  Future<int> unassignDriver(int vehicleId) {
    return (update(vehicles)..where((t) => t.idVehicle.equals(vehicleId)))
        .write(const VehiclesCompanion(idDriver: Value(null), status: Value(VehicleStatus.available)));
  }
}
