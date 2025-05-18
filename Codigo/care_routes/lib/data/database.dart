import 'package:drift/drift.dart';
import 'tables.dart';
import 'daos/daos.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    GpsDevices,
    ObdDevices,
    Vehicles,
    Drivers,
    Stops,
    Routes,
    RouteStops,
    Maintenances,
    MaintenanceDetails,
  ],
  daos: [
    GpsDevicesDao,
    ObdDevicesDao,
    VehiclesDao,
    DriversDao,
    StopsDao,
    RoutesDao,
    MaintenancesDao,
    MaintenanceDetailsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
