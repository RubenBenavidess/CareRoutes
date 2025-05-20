import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/daos/vehicles_dao.dart';

/// Instancia única de la base de datos
final dbProvider = Provider<AppDatabase>(
  (ref) {
    final db = AppDatabase.open();

    if (kDebugMode) {
      // Asincrónico, pero no bloqueante
      Future.microtask(() async {
        await db.seedTestData();
      });
    }

    ref.onDispose(db.close);           // importante en tests / hot-restart
    return db;
  },
  name: 'dbProvider',                  // opcional, útil en logs
  // Si la BD sólo se usa mientras alguna pantalla esté visible:
  // isAutoDispose: true,
);

/// Exposición del DAO
final vehiclesDaoProvider = Provider<VehiclesDao>((ref) {
  final db = ref.watch(dbProvider);
  return VehiclesDao(db);
});