import 'package:drift/drift.dart';
import 'tables.dart';
import 'daos/daos.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  factory AppDatabase.open() {
    final executor = _openConnection();
    return AppDatabase(executor);
  }
}

// lazy database asincrono para abrir la base cuando se necesite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //Obtiene la carpeta de docs de la app
    // y crea la base de datos en esa carpeta
    final dbFolder = await getApplicationDocumentsDirectory();
    // ruta al archivo .sqlite dentro de la carpeta de docs
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    // usa nativedatabase para moviles y desktop
    return NativeDatabase.createInBackground(file);
  });
}
