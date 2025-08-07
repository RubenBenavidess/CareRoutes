// consult_vehicles_usecase.dart

import 'package:logging/logging.dart';
import '../entities/domain_entities.dart';
import '../enums.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/mappers.dart';

class ConsultVehiclesUseCase {
  static final _logger = Logger('ConsultVehiclesUseCase');
  
  final VehiclesDao _vehiclesDao;

  ConsultVehiclesUseCase({
    required VehiclesDao vehiclesDao,
  }) : _vehiclesDao = vehiclesDao;

  /// Obtiene todos los vehículos activos
  Future<VehicleQueryResult> getAllActiveVehicles() async {
    _logger.info('Consultando todos los vehículos activos');
    
    try {
      final vehicleDataList = await _vehiclesDao.getAllActive();
      final vehicles = vehicleDataList.map((v) => v.toDomain()).toList();
      
      _logger.info('Se obtuvieron ${vehicles.length} vehículos activos');
      
      return VehicleQueryResult.success(
        vehicles: vehicles,
        totalFound: vehicles.length,
        message: 'Consulta exitosa: ${vehicles.length} vehículos encontrados',
      );
    } catch (e) {
      _logger.severe('Error consultando vehículos activos: $e');
      return VehicleQueryResult.failure(
        error: 'Error al obtener los vehículos: $e',
      );
    }
  }

  /// Obtiene un vehículo específico por su ID
  Future<VehicleQueryResult> getVehicleById(int vehicleId) async {
    _logger.info('Consultando vehículo con ID: $vehicleId');
    
    try {
      if (vehicleId <= 0) {
        throw ArgumentError('El ID del vehículo debe ser mayor a 0');
      }

      final vehicleData = await _vehiclesDao.getVehicleById(vehicleId);
      
      if (vehicleData == null) {
        _logger.warning('No se encontró vehículo con ID: $vehicleId');
        return VehicleQueryResult.notFound(
          message: 'No se encontró un vehículo con el ID: $vehicleId',
        );
      }

      final vehicle = vehicleData.toDomain();
      _logger.info('Vehículo encontrado: ${vehicle.licensePlate}');
      
      return VehicleQueryResult.success(
        vehicles: [vehicle],
        totalFound: 1,
        message: 'Vehículo encontrado exitosamente',
      );
    } catch (e) {
      _logger.severe('Error consultando vehículo por ID $vehicleId: $e');
      return VehicleQueryResult.failure(
        error: 'Error al obtener el vehículo: $e',
      );
    }
  }

  /// Obtiene un vehículo por su placa
  Future<VehicleQueryResult> getVehicleByLicensePlate(String licensePlate) async {
    _logger.info('Consultando vehículo con placa: $licensePlate');
    
    try {
      if (licensePlate.trim().isEmpty) {
        throw ArgumentError('La placa no puede estar vacía');
      }

      final normalizedPlate = licensePlate.trim().toUpperCase();
      final vehicleData = await _vehiclesDao.getVehicleByLicensePlate(normalizedPlate);
      
      if (vehicleData == null) {
        _logger.warning('No se encontró vehículo con placa: $normalizedPlate');
        return VehicleQueryResult.notFound(
          message: 'No se encontró un vehículo con la placa: $normalizedPlate',
        );
      }

      final vehicle = vehicleData.toDomain();
      _logger.info('Vehículo encontrado con placa $normalizedPlate: ID ${vehicle.id}');
      
      return VehicleQueryResult.success(
        vehicles: [vehicle],
        totalFound: 1,
        message: 'Vehículo encontrado exitosamente',
      );
    } catch (e) {
      _logger.severe('Error consultando vehículo por placa $licensePlate: $e');
      return VehicleQueryResult.failure(
        error: 'Error al obtener el vehículo: $e',
      );
    }
  }

  /// Verifica si existe un vehículo con una placa específica
  Future<VehicleExistenceResult> checkVehicleExists(String licensePlate) async {
    _logger.info('Verificando existencia de vehículo con placa: $licensePlate');
    
    try {
      if (licensePlate.trim().isEmpty) {
        throw ArgumentError('La placa no puede estar vacía');
      }

      final normalizedPlate = licensePlate.trim().toUpperCase();
      final exists = await _vehiclesDao.existsVehicleWithPlate(normalizedPlate);
      
      _logger.info('Vehículo con placa $normalizedPlate ${exists ? 'existe' : 'no existe'}');
      
      return VehicleExistenceResult(
        exists: exists,
        licensePlate: normalizedPlate,
        message: exists 
          ? 'El vehículo con placa $normalizedPlate existe'
          : 'No existe un vehículo con la placa $normalizedPlate',
      );
    } catch (e) {
      _logger.severe('Error verificando existencia de vehículo con placa $licensePlate: $e');
      return VehicleExistenceResult(
        exists: false,
        licensePlate: licensePlate,
        message: 'Error al verificar la existencia del vehículo: $e',
        error: e.toString(),
      );
    }
  }

  /// Obtiene vehículos filtrados por criterios específicos
  Future<VehicleQueryResult> getVehiclesFiltered(VehicleFilter filter) async {
    _logger.info('Consultando vehículos con filtros aplicados');
    
    try {
      final allVehicles = await _vehiclesDao.getAllActive();
      var filteredVehicles = allVehicles.map((v) => v.toDomain()).toList();

      // Aplicar filtros
      if (filter.brand != null && filter.brand!.isNotEmpty) {
        filteredVehicles = filteredVehicles.where((v) =>
          v.brand.toLowerCase().contains(filter.brand!.toLowerCase())
        ).toList();
      }
// consult_vehicles_usecase.dart
      if (filter.model != null && filter.model!.isNotEmpty) {
        filteredVehicles = filteredVehicles.where((v) =>
          v.model?.toLowerCase().contains(filter.model!.toLowerCase()) == true
        ).toList();
      }

      if (filter.year != null) {
        filteredVehicles = filteredVehicles.where((v) => v.year == filter.year).toList();
      }

      if (filter.status != null) {
        filteredVehicles = filteredVehicles.where((v) => v.status == filter.status).toList();
      }

      if (filter.hasDriver != null) {
        filteredVehicles = filteredVehicles.where((v) =>
          filter.hasDriver! ? v.driverId != null : v.driverId == null
        ).toList();
      }

      if (filter.minMileage != null) {
        filteredVehicles = filteredVehicles.where((v) =>
          v.mileage >= filter.minMileage!
        ).toList();
      }

      if (filter.maxMileage != null) {
        filteredVehicles = filteredVehicles.where((v) =>
          v.mileage <= filter.maxMileage!
        ).toList();
      }

      _logger.info('Filtros aplicados: ${filteredVehicles.length} vehículos encontrados de ${allVehicles.length} totales');
      
      return VehicleQueryResult.success(
        vehicles: filteredVehicles,
        totalFound: filteredVehicles.length,
        message: 'Consulta con filtros exitosa: ${filteredVehicles.length} vehículos encontrados',
      );
    } catch (e) {
      _logger.severe('Error consultando vehículos con filtros: $e');
      return VehicleQueryResult.failure(
        error: 'Error al obtener los vehículos filtrados: $e',
      );
    }
  }

  /// Stream de todos los vehículos activos para actualizaciones en tiempo real
  Stream<List<Vehicle>> watchAllActiveVehicles() {
    _logger.info('Iniciando stream de vehículos activos');
    
    try {
      return _vehiclesDao.watchAllActive()
          .map((vehicleDataList) => vehicleDataList.map((v) => v.toDomain()).toList());
    } catch (e) {
      _logger.severe('Error iniciando stream de vehículos: $e');
      return Stream.error('Error al obtener stream de vehículos: $e');
    }
  }

  /// Obtiene estadísticas básicas de los vehículos
  Future<VehicleStatsResult> getVehicleStats() async {
    _logger.info('Calculando estadísticas de vehículos');
    
    try {
      final allVehicles = await _vehiclesDao.getAllActive();
      final vehicles = allVehicles.map((v) => v.toDomain()).toList();

      final stats = _calculateVehicleStatistics(vehicles);
      
      _logger.info('Estadísticas calculadas para ${vehicles.length} vehículos');
      
      return VehicleStatsResult.success(
        stats: stats,
        message: 'Estadísticas calculadas exitosamente',
      );
    } catch (e) {
      _logger.severe('Error calculando estadísticas de vehículos: $e');
      return VehicleStatsResult.failure(
        error: 'Error al calcular las estadísticas: $e',
      );
    }
  }

  /// Calcula estadísticas básicas de una lista de vehículos
  VehicleStats _calculateVehicleStatistics(List<Vehicle> vehicles) {
    final totalVehicles = vehicles.length;
    final vehiclesWithDriver = vehicles.where((v) => v.driverId != null).length;
    final vehiclesWithoutDriver = totalVehicles - vehiclesWithDriver;
    
    final statusCounts = <VehicleStatus, int>{};
    for (final status in VehicleStatus.values) {
      statusCounts[status] = vehicles.where((v) => v.status == status).length;
    }

    final brandCounts = <String, int>{};
    for (final vehicle in vehicles) {
      brandCounts[vehicle.brand] = (brandCounts[vehicle.brand] ?? 0) + 1;
    }

    final yearsWithData = vehicles.where((v) => v.year != null).map((v) => v.year!);
    final avgYear = yearsWithData.isNotEmpty 
        ? yearsWithData.reduce((a, b) => a + b) / yearsWithData.length
        : null;

    final mileages = vehicles.map((v) => v.mileage);
    final avgMileage = mileages.isNotEmpty
        ? mileages.reduce((a, b) => a + b) / mileages.length
        : 0.0;

    return VehicleStats(
      totalVehicles: totalVehicles,
      vehiclesWithDriver: vehiclesWithDriver,
      vehiclesWithoutDriver: vehiclesWithoutDriver,
      statusCounts: statusCounts,
      brandCounts: brandCounts,
      averageYear: avgYear?.round(),
      averageMileage: avgMileage.round(),
    );
  }
}

// Clases de resultado y filtros

class VehicleQueryResult {
  final bool isSuccess;
  final List<Vehicle> vehicles;
  final int totalFound;
  final String message;
  final String? error;

  const VehicleQueryResult._({
    required this.isSuccess,
    required this.vehicles,
    required this.totalFound,
    required this.message,
    this.error,
  });

  factory VehicleQueryResult.success({
    required List<Vehicle> vehicles,
    required int totalFound,
    required String message,
  }) {
    return VehicleQueryResult._(
      isSuccess: true,
      vehicles: vehicles,
      totalFound: totalFound,
      message: message,
    );
  }

  factory VehicleQueryResult.failure({
    required String error,
  }) {
    return VehicleQueryResult._(
      isSuccess: false,
      vehicles: [],
      totalFound: 0,
      message: 'Consulta fallida',
      error: error,
    );
  }

  factory VehicleQueryResult.notFound({
    required String message,
  }) {
    return VehicleQueryResult._(
      isSuccess: true,
      vehicles: [],
      totalFound: 0,
      message: message,
    );
  }
}

class VehicleExistenceResult {
  final bool exists;
  final String licensePlate;
  final String message;
  final String? error;

  const VehicleExistenceResult({
    required this.exists,
    required this.licensePlate,
    required this.message,
    this.error,
  });
}

class VehicleFilter {
  final String? brand;
  final String? model;
  final int? year;
  final VehicleStatus? status;
  final bool? hasDriver;
  final int? minMileage;
  final int? maxMileage;

  const VehicleFilter({
    this.brand,
    this.model,
    this.year,
    this.status,
    this.hasDriver,
    this.minMileage,
    this.maxMileage,
  });
}

class VehicleStatsResult {
  final bool isSuccess;
  final VehicleStats? stats;
  final String message;
  final String? error;

  const VehicleStatsResult._({
    required this.isSuccess,
    this.stats,
    required this.message,
    this.error,
  });

  factory VehicleStatsResult.success({
    required VehicleStats stats,
    required String message,
  }) {
    return VehicleStatsResult._(
      isSuccess: true,
      stats: stats,
      message: message,
    );
  }

  factory VehicleStatsResult.failure({
    required String error,
  }) {
    return VehicleStatsResult._(
      isSuccess: false,
      message: 'Error calculando estadísticas',
      error: error,
    );
  }
}

class VehicleStats {
  final int totalVehicles;
  final int vehiclesWithDriver;
  final int vehiclesWithoutDriver;
  final Map<VehicleStatus, int> statusCounts;
  final Map<String, int> brandCounts;
  final int? averageYear;
  final int averageMileage;

  const VehicleStats({
    required this.totalVehicles,
    required this.vehiclesWithDriver,
    required this.vehiclesWithoutDriver,
    required this.statusCounts,
    required this.brandCounts,
    this.averageYear,
    required this.averageMileage,
  });
}