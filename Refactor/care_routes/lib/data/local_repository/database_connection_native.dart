// database_connection_native.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
// ignore: unused_import
import 'package:sqlite3/sqlite3.dart' as sqlite3_native;

LazyDatabase createDatabaseConnection() {
  return LazyDatabase(() async {
    debugPrint('📱 Setting up native database...');
    
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'care_routes.sqlite'));
      
      debugPrint('💾 Database path: ${file.path}');
      
      // Asegurar que el directorio existe
      await dbFolder.create(recursive: true);
      
      return NativeDatabase.createInBackground(
        file,
        logStatements: kDebugMode,
      );
    } catch (e) {
      debugPrint('❌ Failed to create file database: $e');
      debugPrint('🔄 Falling back to in-memory database...');
      
      // Fallback a base de datos en memoria
      return NativeDatabase.memory();
    }
  });
}