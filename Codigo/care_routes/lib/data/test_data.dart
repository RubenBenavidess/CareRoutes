import 'package:care_routes/data/enums.dart';
import 'package:drift/drift.dart';
import 'database.dart';

/// Clase para gestionar la carga de datos de prueba en la base de datos
class TestDataSeeder {
  final AppDatabase db;

  TestDataSeeder(this.db);

  /// Método principal para cargar todos los datos de prueba
  Future<void> seedAllData() async {
    await _seedDrivers();
    await _seedGpsDevices();
    await _seedObdDevices();
    await _seedVehicles();
    await _seedRoutes();
    await _seedStops();
    await _seedRouteAssignments();
    await _seedMaintenances();
  }

  /// Carga conductores de prueba
  Future<void> _seedDrivers() async {
    // Verificar si ya hay datos para no duplicar
    final count = await db.select(db.drivers).get().then((list) => list.length);
    if (count > 0) return;

    // dataframe excel = excel{'nonbre', 'apell', 'dni'}

    // nombre_conductores = excel['NOMBRE CONDUCTORES'].toList();
    // dni_conductores = excel['DNI CONDUCTORES'].toList();
    // apellido_conductores = excel['APELLIDO CONDUCTORES'].toList();

    final drivers = [
      DriversCompanion.insert(
        firstName: 'Juan',
        lastName: 'Pérez',
        idNumber: 'DNI12345678',
      ),
      DriversCompanion.insert(
        firstName: 'María',
        lastName: 'Gómez',
        idNumber: 'DNI87654321',
      ),
      DriversCompanion.insert(
        firstName: 'Carlos',
        lastName: 'López',
        idNumber: 'DNI23456789',
      ),
      DriversCompanion.insert(
        firstName: 'Ana',
        lastName: 'Martínez',
        idNumber: 'DNI34567890',
      ),
      DriversCompanion.insert(
        firstName: 'Luis',
        lastName: 'Rodríguez',
        idNumber: 'DNI45678901',
      ),
    ];

    // Insertar todos los conductores en una transacción
    await db.transaction(() async {
      for (final driver in drivers) {
        await db.into(db.drivers).insert(driver);
      }
    });
  }

  /// Carga dispositivos GPS de prueba
  Future<void> _seedGpsDevices() async {
    final count = await db
        .select(db.gpsDevices)
        .get()
        .then((list) => list.length);
    if (count > 0) return;

    final devices = [
      GpsDevicesCompanion.insert(
        model: const Value('TK-103'),
        serialNumber: 'GPS12345',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 90))),
      ),
      GpsDevicesCompanion.insert(
        model: const Value('GT06N'),
        serialNumber: 'GPS23456',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 60))),
      ),
      GpsDevicesCompanion.insert(
        model: const Value('Coban 303G'),
        serialNumber: 'GPS34567',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 30))),
      ),
    ];

    await db.transaction(() async {
      for (final device in devices) {
        await db.into(db.gpsDevices).insert(device);
      }
    });
  }

  /// Carga dispositivos OBD de prueba
  Future<void> _seedObdDevices() async {
    final count = await db
        .select(db.obdDevices)
        .get()
        .then((list) => list.length);
    if (count > 0) return;

    final devices = [
      ObdDevicesCompanion.insert(
        model: const Value('ELM327'),
        serialNumber: 'OBD12345',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 80))),
      ),
      ObdDevicesCompanion.insert(
        model: const Value('Vgate iCar Pro'),
        serialNumber: 'OBD23456',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 50))),
      ),
      ObdDevicesCompanion.insert(
        model: const Value('ANCEL AD310'),
        serialNumber: 'OBD34567',
        installedAt: Value(DateTime.now().subtract(const Duration(days: 20))),
      ),
    ];

    await db.transaction(() async {
      for (final device in devices) {
        await db.into(db.obdDevices).insert(device);
      }
    });
  }

  /// Carga vehículos de prueba
  Future<void> _seedVehicles() async {
    final count = await db
        .select(db.vehicles)
        .get()
        .then((list) => list.length);
    if (count > 0) return;

    // Primero obtener los IDs de conductores, GPS y OBD
    final drivers = await db.select(db.drivers).get();
    final gpsDevices = await db.select(db.gpsDevices).get();
    final obdDevices = await db.select(db.obdDevices).get();

    // Verificar que haya datos disponibles para referenciar
    if (drivers.isEmpty || gpsDevices.isEmpty || obdDevices.isEmpty) return;

    final vehicles = [
      VehiclesCompanion.insert(
        idDriver: Value(drivers[0].idDriver),
        licensePlate: 'ABC123',
        brand: 'Toyota',
        model: const Value('Corolla'),
        year: const Value(2020),
        mileage: const Value(15000),
        gpsDeviceId: Value(gpsDevices[0].idGps),
        obdDeviceId: Value(obdDevices[0].idObd),
        status: Value(VehicleStatus.assigned),
      ),
      VehiclesCompanion.insert(
        idDriver: Value(drivers[1].idDriver),
        licensePlate: 'DEF456',
        brand: 'Honda',
        model: const Value('Civic'),
        year: const Value(2019),
        mileage: const Value(22000),
        gpsDeviceId: Value(gpsDevices[1].idGps),
        obdDeviceId: Value(obdDevices[1].idObd),
        status: Value(VehicleStatus.assigned),
      ),
      VehiclesCompanion.insert(
        idDriver: Value(drivers[2].idDriver),
        licensePlate: 'GHI789',
        brand: 'Nissan',
        model: const Value('Sentra'),
        year: const Value(2021),
        mileage: const Value(8000),
        gpsDeviceId: Value(gpsDevices[2].idGps),
        obdDeviceId: Value(obdDevices[2].idObd),
        status: Value(VehicleStatus.assigned),
      ),
      VehiclesCompanion.insert(
        idDriver: Value(drivers[3].idDriver),
        licensePlate: 'JKL012',
        brand: 'Hyundai',
        model: const Value('Elantra'),
        year: const Value(2018),
        mileage: const Value(35000),
        status: Value(VehicleStatus.assigned),
      ),
      VehiclesCompanion.insert(
        idDriver: Value(drivers[4].idDriver),
        licensePlate: 'MNO345',
        brand: 'Ford',
        model: const Value('Focus'),
        year: const Value(2020),
        mileage: const Value(18000),
        status: Value(VehicleStatus.assigned),
      ),
    ];

    await db.transaction(() async {
      for (final vehicle in vehicles) {
        await db.into(db.vehicles).insert(vehicle);
      }
    });
  }

  /// Carga rutas de prueba
  Future<void> _seedRoutes() async {
    final count = await db.select(db.routes).get().then((list) => list.length);
    if (count > 0) return;

    final routes = [
      RoutesCompanion.insert(
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      RoutesCompanion.insert(
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      RoutesCompanion.insert(
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RoutesCompanion.insert(
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RoutesCompanion.insert(date: DateTime.now()),
    ];

    await db.transaction(() async {
      for (final route in routes) {
        await db.into(db.routes).insert(route);
      }
    });
  }

  /// Carga paradas de prueba
  Future<void> _seedStops() async {
    final count = await db.select(db.stops).get().then((list) => list.length);
    if (count > 0) return;

    final routes = await db.select(db.routes).get();
    if (routes.isEmpty) return;

    List<StopsCompanion> allStops = [];

    // Coordenadas base (Lima, Perú)
    final baseLatitude = -12.046374;
    final baseLongitude = -77.042793;

    for (var route in routes) {
      // Generar 3-5 paradas por ruta
      final stopCount = 3 + (route.idRoute % 3); // 3-5 paradas

      for (var i = 0; i < stopCount; i++) {
        // Añadir pequeñas variaciones a las coordenadas base
        final latitude = baseLatitude + (i * 0.002) + (route.idRoute * 0.001);
        final longitude = baseLongitude + (i * 0.002) - (route.idRoute * 0.001);

        allStops.add(
          StopsCompanion.insert(
            idRoute: route.idRoute,
            latitude: latitude,
            longitude: longitude,
          ),
        );
      }
    }

    await db.transaction(() async {
      for (final stop in allStops) {
        await db.into(db.stops).insert(stop);
      }
    });
  }

  /// Carga asignaciones de rutas
  Future<void> _seedRouteAssignments() async {
    final count = await db
        .select(db.routeAssignments)
        .get()
        .then((list) => list.length);
    if (count > 0) return;

    final routes = await db.select(db.routes).get();
    final vehicles = await db.select(db.vehicles).get();

    if (routes.isEmpty || vehicles.isEmpty) return;

    List<RouteAssignmentsCompanion> assignments = [];

    // Asignar vehículos a rutas
    for (var i = 0; i < routes.length; i++) {
      // Asignar vehículos de forma circular si hay más rutas que vehículos
      final vehicleIndex = i % vehicles.length;

      assignments.add(
        RouteAssignmentsCompanion.insert(
          idRoute: routes[i].idRoute,
          idVehicle: vehicles[vehicleIndex].idVehicle,
          assignedAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }

    await db.transaction(() async {
      for (final assignment in assignments) {
        await db.into(db.routeAssignments).insert(assignment);
      }
    });
  }

  /// Carga datos de mantenimiento
  Future<void> _seedMaintenances() async {
    final maintenanceCount = await db
        .select(db.maintenances)
        .get()
        .then((list) => list.length);
    if (maintenanceCount > 0) return;

    final vehicles = await db.select(db.vehicles).get();
    if (vehicles.isEmpty) return;

    List<MaintenancesCompanion> maintenances = [];

    // Crear mantenimientos para cada vehículo
    for (var vehicle in vehicles) {
      // Un mantenimiento antiguo
      maintenances.add(
        MaintenancesCompanion.insert(
          idVehicle: vehicle.idVehicle,
          maintenanceDate: DateTime.now().subtract(const Duration(days: 60)),
          vehicleMileage: vehicle.mileage - 3000,
          details: const Value('Mantenimiento preventivo'),
        ),
      );

      // Un mantenimiento reciente
      maintenances.add(
        MaintenancesCompanion.insert(
          idVehicle: vehicle.idVehicle,
          maintenanceDate: DateTime.now().subtract(const Duration(days: 15)),
          vehicleMileage: vehicle.mileage - 500,
          details: const Value('Cambio de aceite y filtros'),
        ),
      );
    }

    // Insertar mantenimientos y luego sus detalles
    List<Maintenance> insertedMaintenances = [];
    await db.transaction(() async {
      for (final maintenance in maintenances) {
        final id = await db.into(db.maintenances).insert(maintenance);
        // Obtener el mantenimiento insertado para luego crear sus detalles
        final inserted =
            await (db.select(db.maintenances)
              ..where((m) => m.idMaintenance.equals(id))).getSingle();
        insertedMaintenances.add(inserted);
      }
    });

    // Crear detalles de mantenimiento
    List<MaintenanceDetailsCompanion> details = [];
    for (var maintenance in insertedMaintenances) {
      if (maintenance.idMaintenance % 2 == 0) {
        // Para mantenimientos pares (los más recientes)
        details.add(
          MaintenanceDetailsCompanion.insert(
            idMaintenance: maintenance.idMaintenance,
            description: 'Cambio de aceite',
            cost: const Value(45.0),
          ),
        );
        details.add(
          MaintenanceDetailsCompanion.insert(
            idMaintenance: maintenance.idMaintenance,
            description: 'Cambio de filtro de aire',
            cost: const Value(20.0),
          ),
        );
      } else {
        // Para mantenimientos impares (los más antiguos)
        details.add(
          MaintenanceDetailsCompanion.insert(
            idMaintenance: maintenance.idMaintenance,
            description: 'Revisión general',
            cost: const Value(80.0),
          ),
        );
        details.add(
          MaintenanceDetailsCompanion.insert(
            idMaintenance: maintenance.idMaintenance,
            description: 'Alineación y balanceo',
            cost: const Value(60.0),
          ),
        );
        details.add(
          MaintenanceDetailsCompanion.insert(
            idMaintenance: maintenance.idMaintenance,
            description: 'Cambio de filtro de combustible',
            cost: const Value(35.0),
          ),
        );
      }
    }

    await db.transaction(() async {
      for (final detail in details) {
        await db.into(db.maintenanceDetails).insert(detail);
      }
    });
  }
}
