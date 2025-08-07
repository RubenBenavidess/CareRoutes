// database_connection_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart' as sqlite3_wasm;
import 'package:flutter/foundation.dart';

LazyDatabase createDatabaseConnection() {
  return LazyDatabase(() async {
    debugPrint('🌐 Setting up WASM database for web...');
    
    try {
      // Cargar el módulo SQLite3 WASM
      final sqlite = await sqlite3_wasm.WasmSqlite3.loadFromUrl(
        Uri.parse('sqlite3.wasm'),
      );
      
      debugPrint('✅ SQLite3 WASM loaded successfully');
      
      // Crear base de datos WASM con persistencia
      return WasmDatabase(
        sqlite3: sqlite,
        path: 'care_routes.db',
      );
    } catch (e) {
      debugPrint('❌ Failed to load WASM database: $e');
      debugPrint('🔄 Trying fallback to in-memory database...');
      
      // Fallback: base de datos en memoria
      return await _createFallbackDatabase();
    }
  });
}

Future<WasmDatabase> _createFallbackDatabase() async {
  try {
    final sqlite = await sqlite3_wasm.WasmSqlite3.loadFromUrl(
      Uri.parse('sqlite3.wasm'),
    );
    
    debugPrint('✅ Fallback in-memory database created');
    return WasmDatabase.inMemory(sqlite);
  } catch (e) {
    debugPrint('❌ Even fallback failed: $e');
    rethrow;
  }
}