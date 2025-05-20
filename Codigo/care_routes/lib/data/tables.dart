import 'package:drift/drift.dart';

// 1. GPS Devices
class GpsDevices extends Table {
  IntColumn get idGps => integer().autoIncrement()();
  TextColumn get model => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 50).unique()();
  DateTimeColumn get installedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 2. OBD Devices
class ObdDevices extends Table {
  IntColumn get idObd => integer().autoIncrement()();
  TextColumn get model => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 50).unique()();
  DateTimeColumn get installedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 3. Vehicles
class Vehicles extends Table {
  IntColumn get idVehicle => integer().autoIncrement()();
  IntColumn get idDriver =>
      integer().customConstraint('REFERENCES drivers(id_driver)')();
  TextColumn get licensePlate => text().withLength(min: 1, max: 10).unique()();
  TextColumn get brand => text().withLength(min: 1, max: 50)();
  TextColumn get model => text().withLength(min: 1, max: 50).nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get status =>
      text()
          .withLength(min: 1, max: 20)
          .withDefault(const Constant('active'))();
  IntColumn get mileage => integer().withDefault(const Constant(0))();
  IntColumn get gpsDeviceId =>
      integer().nullable().customConstraint(
        'NULL REFERENCES gps_devices(id_gps)',
      )();
  IntColumn get obdDeviceId =>
      integer().nullable().customConstraint(
        'NULL REFERENCES obd_devices(id_obd)',
      )();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 4. Drivers
class Drivers extends Table {
  IntColumn get idDriver => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 50)();
  TextColumn get lastName => text().withLength(min: 1, max: 50)();
  TextColumn get idNumber => text().withLength(min: 1, max: 15).unique()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 5. RputeAssignments
class RouteAssignments extends Table {
  IntColumn get idAssignment => integer().autoIncrement()();
  IntColumn get idRoute =>
      integer().customConstraint('REFERENCES routes(id_route)')();
  IntColumn get idVehicle =>
      integer().customConstraint('REFERENCES vehicles(id_vehicle)')();
  DateTimeColumn get assignedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 6. Routes
class Routes extends Table {
  IntColumn get idRoute => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 7. Stops (sequence)
class Stops extends Table {
  IntColumn get idStop => integer().autoIncrement()();
  IntColumn get idRoute =>
      integer().customConstraint('REFERENCES routes(id_route)')();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 8. Maintenances
class Maintenances extends Table {
  IntColumn get idMaintenance => integer().autoIncrement()();
  IntColumn get idVehicle =>
      integer().customConstraint('REFERENCES vehicles(id_vehicle)')();
  DateTimeColumn get maintenanceDate => dateTime()();
  IntColumn get vehicleMileage => integer()();
  TextColumn get details => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 9. MaintenanceDetails
class MaintenanceDetails extends Table {
  IntColumn get idDetail => integer().autoIncrement()();
  IntColumn get idMaintenance =>
      integer().customConstraint('REFERENCES maintenances(id_maintenance)')();
  TextColumn get description => text()();
  RealColumn get cost => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
