import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'tables.dart';
import 'daos/daos.dart';
import '../../domain/enums.dart';

import 'database_connection_native.dart' if (dart.library.js) 'database_connection_web.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    GpsDevices,
    ObdDevices,
    Vehicles,
    Drivers,
    Stops,
    Routes,
    RouteAssignments,
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
    RouteAssignmentsDao,
    MaintenancesDao,
    MaintenanceDetailsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      if (!kIsWeb) {
        await customStatement('PRAGMA foreign_keys = ON');
      }
    },
  );

  Future<void> resetDatabase() async {
    if (kDebugMode) {
      await transaction(() async {
        await delete(maintenanceDetails).go();
        await delete(maintenances).go();
        await delete(routeAssignments).go();
        await delete(stops).go();
        await delete(routes).go();
        await delete(vehicles).go();
        await delete(obdDevices).go();
        await delete(gpsDevices).go();
        await delete(drivers).go();
      });
    }
  }

  Future<void> validateConnection() async {
    try {
      await customSelect('SELECT 1 as test').get();
      debugPrint('✅ Database connection validated successfully');
    } catch (e) {
      debugPrint('❌ Database connection failed: $e');
      rethrow;
    }
  }

  static Future<AppDatabase> initAndSeed() async {
    final db = AppDatabase.open();
    await db.validateConnection();
    return db;
  }

  factory AppDatabase.open() {
    return AppDatabase(createDatabaseConnection());
  }
}