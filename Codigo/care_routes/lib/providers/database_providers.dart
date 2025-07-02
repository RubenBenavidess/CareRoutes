import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/daos/vehicles_dao.dart';
import '../data/daos/drivers_dao.dart';

/// Instancia única de la base de datos
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();

  if (kDebugMode) {
    // Asincrónico, pero no bloqueante
    Future.microtask(() async {
      await db.seedTestData();
    });
  }

  ref.onDispose(db.close);
  return db;
}, name: 'dbProvider');

/// DAO de vehículos
final vehiclesDaoProvider = Provider<VehiclesDao>((ref) {
  final db = ref.watch(dbProvider);
  return VehiclesDao(db);
});

/// DAO de conductores
final driversDaoProvider = Provider<DriversDao>((ref) {
  final db = ref.watch(dbProvider);
  return DriversDao(db);
});
