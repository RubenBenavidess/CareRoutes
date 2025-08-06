import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

LazyDatabase createDatabaseConnection() {
  return LazyDatabase(() async {
    debugPrint('📱 Setting up native database...');
    
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'care_routes.sqlite'));
    
    debugPrint('💾 Database path: ${file.path}');
    
    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode,
    );
  });
}