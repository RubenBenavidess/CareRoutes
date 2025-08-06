//main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:care_routes/presentation/views/home_state.dart';
import 'package:care_routes/presentation/themes/main_theme.dart';
import 'package:care_routes/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/file_upload_viewmodel.dart';
import 'package:care_routes/presentation/viewmodels/consult_vehicles_viewmodel.dart';
import 'package:care_routes/domain/use_cases/import_csv_usecase.dart';
import 'package:care_routes/domain/use_cases/consult_vehicles_usecase.dart';
import 'package:care_routes/domain/use_cases/assign_driver_usecase.dart'; // <- NUEVO
import 'package:care_routes/data/local_repository/database.dart';
import 'package:get_it/get_it.dart';
import 'package:care_routes/domain/use_cases/vehicle_location_usecase.dart';

import 'data/local_repository/daos/daos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Configurar dependencias
    await _setupDependencies();
    
    runApp(const CareRoutesApp());
  } catch (e) {
    debugPrint('❌ Error initializing app: $e');
    runApp(const ErrorApp());
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

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error al inicializar la aplicación'),
              SizedBox(height: 8),
              Text('Revisa la consola para más detalles'),
            ],
          ),
        ),
      ),
    );
  }
}