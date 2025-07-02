import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'tables.dart';
import 'daos/daos.dart';
import 'dart:io';
import 'enums.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'test_data.dart';

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
    MaintenancesDao,
    MaintenanceDetailsDao,
  ],
)

class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

/// Carga datos de prueba en la base de datos
  Future<void> seedTestData() async {
    final seeder = TestDataSeeder(this);
    await seeder.seedAllData();
  }
  
  /// Limpia y reinicia la base de datos con datos de prueba
  /// Útil para desarrollo y testing
  Future<void> resetDatabase() async {
    if (kDebugMode) {
      // Solo permitimos reseteo en modo debug
      await transaction(() async {
        // Eliminar datos en orden inverso para evitar problemas de integridad referencial
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
      
      // Cargar datos de prueba frescos
      await seedTestData();
    }
  }

  /// Método para inicializar la base de datos con datos de prueba
  static Future<AppDatabase> initAndSeed() async {
    final db = AppDatabase.open();
    
    // En modo debug, cargamos datos de prueba
    if (kDebugMode) {
      await db.seedTestData();
    }
    
    return db;
  }

  factory AppDatabase.open() {
    final executor = _openConnection();
    return AppDatabase(executor);
  }
}

// lazy database asincrono para abrir la base cuando se necesite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
      if (kIsWeb) {
        // TODO: Cambiar a drift wasm
        final dbFolder = await getApplicationDocumentsDirectory();
        // ruta al archivo .sqlite dentro de la carpeta de docs
        final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
        // usa nativedatabase para moviles y desktop
        return NativeDatabase.createInBackground(file);
      }
      else{
        //Obtiene la carpeta de docs de la app
        // y crea la base de datos en esa carpeta
        final dbFolder = await getApplicationDocumentsDirectory();
        // ruta al archivo .sqlite dentro de la carpeta de docs
        final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
        // usa nativedatabase para moviles y desktop
        return NativeDatabase.createInBackground(file);
      }
      
    }
  );
}

