import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/wasm.dart';

LazyDatabase createDatabaseConnection() {
  return LazyDatabase(() async {
    debugPrint('🌐 Loading SQLite3 WASM module...');
    
    final sqlite = await WasmSqlite3.loadFromUrl(
      Uri.parse('sqlite3.wasm'),
    );
    
    debugPrint('✅ SQLite3 WASM loaded successfully');
    
    return WasmDatabase(
      sqlite3: sqlite,
      path: 'care_routes.db',
    );
  });
}