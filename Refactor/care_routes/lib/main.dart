//main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:care_routes/presentation/views/home_state.dart';
import 'package:care_routes/presentation/themes/main_theme.dart';
import 'package:care_routes/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/file_upload_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/consult_vehicles_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/maintenance_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/reports_viewmodel.dart';
import 'package:care_routes/domain/use_cases/import_csv_usecase.dart';
import 'package:care_routes/domain/use_cases/consult_vehicles_usecase.dart';
import 'package:care_routes/domain/use_cases/assign_driver_usecase.dart';
import 'package:care_routes/domain/use_cases/maintenance_usecase.dart';
import 'package:care_routes/data/local_repository/database.dart';
import 'package:get_it/get_it.dart';
import 'package:care_routes/domain/use_cases/vehicle_location_usecase.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:care_routes/domain/use_cases/reports_usecase.dart';
import 'data/local_repository/daos/daos.dart';
import 'presentation/views/error_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializar según la plataforma
    await _initializePlatformSpecific();
    
    // Configurar dependencias
    await _setupDependencies();
    
    runApp(const CareRoutesApp());
  } catch (e) {
    debugPrint('❌ Error initializing app: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

Future<void> _initializePlatformSpecific() async {
  if (kIsWeb) {
    debugPrint('🌐 Running on web - WASM will be loaded by database connection');
    // No necesitamos inicializar nada específico para web aquí
  } else {
    debugPrint('📱💻 Running on native platform - initializing SQLite3');
    await _initSqlite3Native();
  }
}

Future<void> _initSqlite3Native() async {
  if (!kIsWeb) {
    try {
      // Verificar que SQLite3 funciona
      final testDb = sqlite3.openInMemory();
      testDb.execute('SELECT 1');
      testDb.dispose();
      
      debugPrint('✅ Native SQLite3 initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize native SQLite3: $e');
      rethrow;
    }
  }
}

Future<void> _setupDependencies() async {
  final getIt = GetIt.instance;
  
  // Base de datos
  final database = await AppDatabase.initAndSeed();
  getIt.registerSingleton<AppDatabase>(database);
  
  // DAOs
  getIt.registerSingleton(database.driversDao);
  getIt.registerSingleton(database.vehiclesDao);
  
  // Use Cases
  getIt.registerSingleton<ImportCsvUseCase>(
    ImportCsvUseCase(
      driversDao: getIt<DriversDao>(),
      vehiclesDao: getIt<VehiclesDao>(),
    ),
  );
  
  getIt.registerSingleton<ConsultVehiclesUseCase>(
    ConsultVehiclesUseCase(
      vehiclesDao: getIt<VehiclesDao>(),
    ),
  );
  
  getIt.registerSingleton<VehicleLocationUseCase>(
    VehicleLocationUseCase(),
  );

  // <- NUEVO: Registrar el AssignDriverUseCase
  getIt.registerSingleton<AssignDriverUseCase>(
    AssignDriverUseCase(
      driversDao: getIt<DriversDao>(),
      vehiclesDao: getIt<VehiclesDao>(),
    ),
  );

  // Agregar en _setupDependencies():

  // DAOs (agregar estos después de los existentes)
  getIt.registerSingleton(database.maintenancesDao);
  getIt.registerSingleton(database.maintenanceDetailsDao);

  // Use Cases (agregar después de los existentes)
  getIt.registerSingleton<MaintenanceUseCase>(
    MaintenanceUseCase(
      maintenancesDao: getIt<MaintenancesDao>(),
      maintenanceDetailsDao: getIt<MaintenanceDetailsDao>(),
      vehiclesDao: getIt<VehiclesDao>(),
    ),
  );

  // En _setupDependencies() del main.dart:

  // Use Cases (agregar después de los existentes)
  getIt.registerSingleton<ReportsUseCase>(
    ReportsUseCase(
      maintenancesDao: getIt<MaintenancesDao>(),
      maintenanceDetailsDao: getIt<MaintenanceDetailsDao>(),
      vehiclesDao: getIt<VehiclesDao>(),
    ),
  );

}

class CareRoutesApp extends StatelessWidget {
  const CareRoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationViewModel>(
          create: (context) => NavigationViewModel(),
        ),
        ChangeNotifierProvider<FileUploadViewModel>(
          create: (context) => FileUploadViewModel(
            importCsvUseCase: GetIt.instance<ImportCsvUseCase>(),
          ),
        ),
        ChangeNotifierProvider<VehicleConsultViewModel>(
          create: (context) => VehicleConsultViewModel(
            consultVehiclesUseCase: GetIt.instance<ConsultVehiclesUseCase>(),
          ),
        ),
        // Agregar en los providers de MultiProvider:
        ChangeNotifierProvider<MaintenanceViewModel>(
          create: (context) => MaintenanceViewModel(
            maintenanceUseCase: GetIt.instance<MaintenanceUseCase>(),
          ),
        ),
        // En los providers de MultiProvider:
        ChangeNotifierProvider<ReportsViewModel>(
          create: (context) => ReportsViewModel(
            reportsUseCase: GetIt.instance<ReportsUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CareRoutes',
        theme: mainTheme,
        home: const HomeState(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
