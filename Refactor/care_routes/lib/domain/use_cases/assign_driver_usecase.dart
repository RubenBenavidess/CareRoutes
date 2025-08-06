// domain/use_cases/assign_driver_usecase.dart
import 'package:logging/logging.dart';
import '../entities/domain_entities.dart';
import '../enums.dart'; // <- AGREGAR este import
import '../../data/local_repository/daos/drivers_dao.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/mappers.dart';

class AssignDriverUseCase {
  static final _logger = Logger('AssignDriverUseCase');
  
  final DriversDao _driversDao;
  final VehiclesDao _vehiclesDao;

  AssignDriverUseCase({
    required DriversDao driversDao,
    required VehiclesDao vehiclesDao,
  })  : _driversDao = driversDao,
        _vehiclesDao = vehiclesDao;

  /// Obtiene todos los conductores que no tienen vehículo asignado
  Future<AvailableDriversResult> getAvailableDrivers() async {
    _logger.info('Obteniendo conductores disponibles');
    
    try {
      // Obtener todos los conductores activos
      final allDriversData = await _driversDao.getAllActive();
      final allDrivers = allDriversData.map((d) => d.toDomain()).toList();
      
      // Obtener todos los vehículos activos que tienen conductor asignado
      final allVehiclesData = await _vehiclesDao.getAllActive();
      final assignedDriverIds = allVehiclesData
          .where((v) => v.idDriver != null)
          .map((v) => v.idDriver!)
          .toSet();
      
      // Filtrar conductores que no están asignados
      final availableDrivers = allDrivers
          .where((driver) => !assignedDriverIds.contains(driver.id))
          .toList();
      
      _logger.info('Encontrados ${availableDrivers.length} conductores disponibles de ${allDrivers.length} total');
      
      return AvailableDriversResult.success(
        drivers: availableDrivers,
        totalAvailable: availableDrivers.length,
        totalDrivers: allDrivers.length,
        message: 'Conductores disponibles obtenidos exitosamente',
      );
    } catch (e) {
      _logger.severe('Error obteniendo conductores disponibles: $e');
      return AvailableDriversResult.failure(
        error: 'Error al obtener conductores disponibles: $e',
      );
    }
  }

  /// Obtiene la información del conductor asignado a un vehículo
  Future<AssignedDriverResult> getAssignedDriver(Vehicle vehicle) async {
    _logger.info('Obteniendo conductor asignado al vehículo ${vehicle.licensePlate}');
    
    try {
      if (vehicle.driverId == null) {
        return AssignedDriverResult.noDriver(
          message: 'El vehículo ${vehicle.licensePlate} no tiene conductor asignado',
        );
      }

      final driverData = await _driversDao.getDriverById(vehicle.driverId!);
      
      if (driverData == null) {
        _logger.warning('No se encontró conductor con ID ${vehicle.driverId} para vehículo ${vehicle.licensePlate}');
        return AssignedDriverResult.notFound(
          message: 'Conductor con ID ${vehicle.driverId} no encontrado',
        );
      }

      final driver = driverData.toDomain();
      
      return AssignedDriverResult.success(
        driver: driver,
        message: 'Conductor asignado encontrado',
      );
    } catch (e) {
      _logger.severe('Error obteniendo conductor asignado: $e');
      return AssignedDriverResult.failure(
        error: 'Error al obtener conductor asignado: $e',
      );
    }
  }

  /// Obtiene estadísticas de asignaciones
  Future<AssignmentStatsResult> getAssignmentStats() async {
    _logger.info('Calculando estadísticas de asignaciones');
    
    try {
      final allDriversData = await _driversDao.getAllActive();
      final allVehiclesData = await _vehiclesDao.getAllActive();
      
      final totalDrivers = allDriversData.length;
      final totalVehicles = allVehiclesData.length;
      final assignedVehicles = allVehiclesData.where((v) => v.idDriver != null).length;
      final availableVehicles = totalVehicles - assignedVehicles;
      
      // Obtener IDs de conductores asignados
      final assignedDriverIds = allVehiclesData
          .where((v) => v.idDriver != null)
          .map((v) => v.idDriver!)
          .toSet();
      
      final assignedDrivers = assignedDriverIds.length;
      final availableDrivers = totalDrivers - assignedDrivers;

      final stats = AssignmentStats(
        totalVehicles: totalVehicles,
        assignedVehicles: assignedVehicles,
        availableVehicles: availableVehicles,
        totalDrivers: totalDrivers,
        assignedDrivers: assignedDrivers,
        availableDrivers: availableDrivers,
        assignmentRate: totalVehicles > 0 ? (assignedVehicles / totalVehicles) * 100 : 0,
      );

      return AssignmentStatsResult.success(
        stats: stats,
        message: 'Estadísticas calculadas exitosamente',
      );
    } catch (e) {
      _logger.severe('Error calculando estadísticas: $e');
      return AssignmentStatsResult.failure(
        error: 'Error al calcular estadísticas: $e',
      );
    }
  }

  /// Asigna un conductor a un vehículo
  Future<AssignmentResult> assignDriverToVehicle(Vehicle vehicle, Driver driver) async {
    _logger.info('Asignando conductor ${driver.firstName} ${driver.lastName} al vehículo ${vehicle.licensePlate}');
    
    try {
      // Verificar que el conductor no esté ya asignado a otro vehículo
      final driverVehicle = await _getVehicleByDriverId(driver.id);
      if (driverVehicle != null) {
        return AssignmentResult.failure(
          error: 'El conductor ${driver.firstName} ${driver.lastName} ya está asignado al vehículo ${driverVehicle.licensePlate}',
        );
      }

      // Verificar que el vehículo no tenga ya un conductor asignado
      if (vehicle.driverId != null) {
        final currentDriverData = await _driversDao.getDriverById(vehicle.driverId!);
        if (currentDriverData != null) {
          final currentDriver = currentDriverData.toDomain();
          return AssignmentResult.failure(
            error: 'El vehículo ${vehicle.licensePlate} ya tiene asignado al conductor ${currentDriver.firstName} ${currentDriver.lastName}',
          );
        }
      }

      // Crear vehículo actualizado con el conductor asignado
      final updatedVehicle = Vehicle(
        id: vehicle.id,
        driverId: driver.id,
        licensePlate: vehicle.licensePlate,
        brand: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
        status: VehicleStatus.assigned,
        mileage: vehicle.mileage,
        gpsDeviceId: vehicle.gpsDeviceId,
        obdDeviceId: vehicle.obdDeviceId,
        isActive: vehicle.isActive,
      );

      // Actualizar en la base de datos usando companion
      final updateCompanion = updatedVehicle.toCompanionUpdate();
      
      final updatedRows = await (_vehiclesDao.update(_vehiclesDao.vehicles)
        ..where((t) => t.idVehicle.equals(vehicle.id)))
        .write(updateCompanion);
      
      if (updatedRows == 0) {
        throw Exception('No se pudo actualizar el vehículo en la base de datos');
      }

      _logger.info('Conductor ${driver.firstName} ${driver.lastName} asignado exitosamente al vehículo ${vehicle.licensePlate}');
      
      return AssignmentResult.success(
        updatedVehicle: updatedVehicle,
        assignedDriver: driver,
        message: 'Conductor asignado exitosamente al vehículo ${vehicle.licensePlate}',
      );
    } catch (e) {
      _logger.severe('Error asignando conductor: $e');
      return AssignmentResult.failure(
        error: 'Error al asignar conductor: $e',
      );
    }
  }

  /// Desasigna el conductor de un vehículo
  Future<AssignmentResult> unassignDriverFromVehicle(Vehicle vehicle) async {
    _logger.info('Desasignando conductor del vehículo ${vehicle.licensePlate}');
    
    try {
      if (vehicle.driverId == null) {
        return AssignmentResult.failure(
          error: 'El vehículo ${vehicle.licensePlate} no tiene conductor asignado',
        );
      }

      // Obtener información del conductor antes de desasignarlo
      final currentDriverData = await _driversDao.getDriverById(vehicle.driverId!);
      final currentDriver = currentDriverData?.toDomain();

      // Crear vehículo actualizado sin conductor
      final updatedVehicle = Vehicle(
        id: vehicle.id,
        driverId: null,
        licensePlate: vehicle.licensePlate,
        brand: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
        status: VehicleStatus.available,
        mileage: vehicle.mileage,
        gpsDeviceId: vehicle.gpsDeviceId,
        obdDeviceId: vehicle.obdDeviceId,
        isActive: vehicle.isActive,
      );

      // Actualizar en la base de datos usando companion
      final updateCompanion = updatedVehicle.toCompanionUpdate();
      
      final updatedRows = await (_vehiclesDao.update(_vehiclesDao.vehicles)
        ..where((t) => t.idVehicle.equals(vehicle.id)))
        .write(updateCompanion);
      
      if (updatedRows == 0) {
        throw Exception('No se pudo actualizar el vehículo en la base de datos');
      }

      _logger.info('Conductor desasignado exitosamente del vehículo ${vehicle.licensePlate}');
      
      return AssignmentResult.success(
        updatedVehicle: updatedVehicle,
        unassignedDriver: currentDriver,
        message: currentDriver != null 
          ? 'Conductor ${currentDriver.firstName} ${currentDriver.lastName} desasignado exitosamente'
          : 'Conductor desasignado exitosamente',
      );
    } catch (e) {
      _logger.severe('Error desasignando conductor: $e');
      return AssignmentResult.failure(
        error: 'Error al desasignar conductor: $e',
      );
    }
  }

  // Método auxiliar privado
  Future<Vehicle?> _getVehicleByDriverId(int driverId) async {
    try {
      final vehiclesData = await _vehiclesDao.getAllActive();
      final vehicleData = vehiclesData.where((v) => v.idDriver == driverId).firstOrNull;
      return vehicleData?.toDomain();
    } catch (e) {
      _logger.warning('Error obteniendo vehículo por driver ID $driverId: $e');
      return null;
    }
  }
}

class AvailableDriversResult {
  final bool isSuccess;
  final List<Driver> drivers;
  final int totalAvailable;
  final int totalDrivers;
  final String message;
  final String? error;

  const AvailableDriversResult._({
    required this.isSuccess,
    required this.drivers,
    required this.totalAvailable,
    required this.totalDrivers,
    required this.message,
    this.error,
  });

  factory AvailableDriversResult.success({
    required List<Driver> drivers,
    required int totalAvailable,
    required int totalDrivers,
    required String message,
  }) {
    return AvailableDriversResult._(
      isSuccess: true,
      drivers: drivers,
      totalAvailable: totalAvailable,
      totalDrivers: totalDrivers,
      message: message,
    );
  }

  factory AvailableDriversResult.failure({
    required String error,
  }) {
    return AvailableDriversResult._(
      isSuccess: false,
      drivers: [],
      totalAvailable: 0,
      totalDrivers: 0,
      message: 'Error obteniendo conductores',
      error: error,
    );
  }
}

class AssignedDriverResult {
  final bool isSuccess;
  final bool hasDriver;
  final Driver? driver;
  final String message;
  final String? error;

  const AssignedDriverResult._({
    required this.isSuccess,
    required this.hasDriver,
    this.driver,
    required this.message,
    this.error,
  });

  factory AssignedDriverResult.success({
    required Driver driver,
    required String message,
  }) {
    return AssignedDriverResult._(
      isSuccess: true,
      hasDriver: true,
      driver: driver,
      message: message,
    );
  }

  factory AssignedDriverResult.noDriver({
    required String message,
  }) {
    return AssignedDriverResult._(
      isSuccess: true,
      hasDriver: false,
      message: message,
    );
  }

  factory AssignedDriverResult.notFound({
    required String message,
  }) {
    return AssignedDriverResult._(
      isSuccess: true,
      hasDriver: false,
      message: message,
    );
  }

  factory AssignedDriverResult.failure({
    required String error,
  }) {
    return AssignedDriverResult._(
      isSuccess: false,
      hasDriver: false,
      message: 'Error obteniendo conductor asignado',
      error: error,
    );
  }
}

class AssignmentResult {
  final bool isSuccess;
  final Vehicle? updatedVehicle;
  final Driver? assignedDriver;
  final Driver? unassignedDriver;
  final String message;
  final String? error;

  const AssignmentResult._({
    required this.isSuccess,
    this.updatedVehicle,
    this.assignedDriver,
    this.unassignedDriver,
    required this.message,
    this.error,
  });

  factory AssignmentResult.success({
    required Vehicle updatedVehicle,
    Driver? assignedDriver,
    Driver? unassignedDriver,
    required String message,
  }) {
    return AssignmentResult._(
      isSuccess: true,
      updatedVehicle: updatedVehicle,
      assignedDriver: assignedDriver,
      unassignedDriver: unassignedDriver,
      message: message,
    );
  }

  factory AssignmentResult.failure({
    required String error,
  }) {
    return AssignmentResult._(
      isSuccess: false,
      message: 'Operación fallida',
      error: error,
    );
  }
}

class AssignmentStatsResult {
  final bool isSuccess;
  final AssignmentStats? stats;
  final String message;
  final String? error;

  const AssignmentStatsResult._({
    required this.isSuccess,
    this.stats,
    required this.message,
    this.error,
  });

  factory AssignmentStatsResult.success({
    required AssignmentStats stats,
    required String message,
  }) {
    return AssignmentStatsResult._(
      isSuccess: true,
      stats: stats,
      message: message,
    );
  }

  factory AssignmentStatsResult.failure({
    required String error,
  }) {
    return AssignmentStatsResult._(
      isSuccess: false,
      message: 'Error calculando estadísticas',
      error: error,
    );
  }
}

class AssignmentStats {
  final int totalVehicles;
  final int assignedVehicles;
  final int availableVehicles;
  final int totalDrivers;
  final int assignedDrivers;
  final int availableDrivers;
  final double assignmentRate;

  const AssignmentStats({
    required this.totalVehicles,
    required this.assignedVehicles,
    required this.availableVehicles,
    required this.totalDrivers,
    required this.assignedDrivers,
    required this.availableDrivers,
    required this.assignmentRate,
  });
}