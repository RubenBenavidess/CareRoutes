// lib/domain/use_cases/maintenance_usecase.dart

import 'package:drift/drift.dart';
import 'package:logging/logging.dart';
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/maintenance_dao.dart';
import '../../data/local_repository/daos/maintenance_details_dao.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/mappers.dart';

class MaintenanceUseCase {
  static final _logger = Logger('MaintenanceUseCase');
  
  final MaintenancesDao _maintenancesDao;
  final MaintenanceDetailsDao _maintenanceDetailsDao;
  final VehiclesDao _vehiclesDao;

  MaintenanceUseCase({
    required MaintenancesDao maintenancesDao,
    required MaintenanceDetailsDao maintenanceDetailsDao,
    required VehiclesDao vehiclesDao,
  }) : _maintenancesDao = maintenancesDao,
       _maintenanceDetailsDao = maintenanceDetailsDao,
       _vehiclesDao = vehiclesDao;

  /// Obtiene todos los mantenimientos activos con información del vehículo
  Future<MaintenanceQueryResult> getAllActiveMaintenances() async {
    _logger.info('Consultando todos los mantenimientos activos');
    
    try {
      final maintenanceDataList = await _maintenancesDao.getAllActiveMaintenances();
      final maintenancesWithVehicle = <MaintenanceWithVehicle>[];
      
      for (final maintenanceData in maintenanceDataList) {
        final maintenance = maintenanceData.toDomain();
        final vehicle = await _vehiclesDao.getVehicleById(maintenance.vehicleId);
        
        maintenancesWithVehicle.add(MaintenanceWithVehicle(
          maintenance: maintenance,
          vehicleLicensePlate: vehicle?.licensePlate ?? 'N/A',
          vehicleBrand: vehicle?.brand ?? 'N/A',
          vehicleModel: vehicle?.model ?? 'N/A',
        ));
      }
      
      _logger.info('Se obtuvieron ${maintenancesWithVehicle.length} mantenimientos activos');
      
      return MaintenanceQueryResult.success(
        maintenances: maintenancesWithVehicle,
        totalFound: maintenancesWithVehicle.length,
        message: 'Consulta exitosa: ${maintenancesWithVehicle.length} mantenimientos encontrados',
      );
    } catch (e) {
      _logger.severe('Error consultando mantenimientos activos: $e');
      return MaintenanceQueryResult.failure(
        error: 'Error al obtener los mantenimientos: $e',
      );
    }
  }

  /// Obtiene un mantenimiento específico por su ID
  Future<MaintenanceQueryResult> getMaintenanceById(int maintenanceId) async {
    _logger.info('Consultando mantenimiento con ID: $maintenanceId');
    
    try {
      if (maintenanceId <= 0) {
        throw ArgumentError('El ID del mantenimiento debe ser mayor a 0');
      }

      final maintenanceData = await _maintenancesDao.getMaintenanceById(maintenanceId);
      
      if (maintenanceData == null) {
        _logger.warning('No se encontró mantenimiento con ID: $maintenanceId');
        return MaintenanceQueryResult.notFound(
          message: 'No se encontró un mantenimiento con el ID: $maintenanceId',
        );
      }

      final maintenance = maintenanceData.toDomain();
      final vehicle = await _vehiclesDao.getVehicleById(maintenance.vehicleId);
      
      final maintenanceWithVehicle = MaintenanceWithVehicle(
        maintenance: maintenance,
        vehicleLicensePlate: vehicle?.licensePlate ?? 'N/A',
        vehicleBrand: vehicle?.brand ?? 'N/A',
        vehicleModel: vehicle?.model ?? 'N/A',
      );
      
      _logger.info('Mantenimiento encontrado para vehículo: ${vehicle?.licensePlate}');
      
      return MaintenanceQueryResult.success(
        maintenances: [maintenanceWithVehicle],
        totalFound: 1,
        message: 'Mantenimiento encontrado exitosamente',
      );
    } catch (e) {
      _logger.severe('Error consultando mantenimiento por ID $maintenanceId: $e');
      return MaintenanceQueryResult.failure(
        error: 'Error al obtener el mantenimiento: $e',
      );
    }
  }

  /// Busca mantenimientos por placa de vehículo
  Future<MaintenanceQueryResult> getMaintenancesByLicensePlate(String licensePlate) async {
    _logger.info('Consultando mantenimientos para vehículo con placa: $licensePlate');
    
    try {
      if (licensePlate.trim().isEmpty) {
        throw ArgumentError('La placa no puede estar vacía');
      }

      final normalizedPlate = licensePlate.trim().toUpperCase();
      final vehicle = await _vehiclesDao.getVehicleByLicensePlate(normalizedPlate);
      
      if (vehicle == null) {
        _logger.warning('No se encontró vehículo con placa: $normalizedPlate');
        return MaintenanceQueryResult.notFound(
          message: 'No se encontró un vehículo con la placa: $normalizedPlate',
        );
      }

      final allMaintenances = await _maintenancesDao.getAllActiveMaintenances();
      final vehicleMaintenances = allMaintenances
          .where((m) => m.idVehicle == vehicle.idVehicle)
          .toList();

      final maintenancesWithVehicle = vehicleMaintenances.map((maintenanceData) {
        final maintenance = maintenanceData.toDomain();
        return MaintenanceWithVehicle(
          maintenance: maintenance,
          vehicleLicensePlate: vehicle.licensePlate,
          vehicleBrand: vehicle.brand,
          vehicleModel: vehicle.model ?? 'N/A',
        );
      }).toList();

      _logger.info('Se encontraron ${maintenancesWithVehicle.length} mantenimientos para el vehículo $normalizedPlate');
      
      return MaintenanceQueryResult.success(
        maintenances: maintenancesWithVehicle,
        totalFound: maintenancesWithVehicle.length,
        message: 'Se encontraron ${maintenancesWithVehicle.length} mantenimientos para el vehículo $normalizedPlate',
      );
    } catch (e) {
      _logger.severe('Error consultando mantenimientos por placa $licensePlate: $e');
      return MaintenanceQueryResult.failure(
        error: 'Error al obtener los mantenimientos: $e',
      );
    }
  }

  /// Crea un nuevo mantenimiento
  Future<MaintenanceOperationResult> createMaintenance(Maintenance maintenance) async {
    _logger.info('Creando nuevo mantenimiento para vehículo ID: ${maintenance.vehicleId}');
    
    try {
      // Verificar que el vehículo existe
      final vehicle = await _vehiclesDao.getVehicleById(maintenance.vehicleId);
      if (vehicle == null) {
        return MaintenanceOperationResult.failure(
          error: 'No se encontró un vehículo con ID: ${maintenance.vehicleId}',
        );
      }

      final companion = maintenance.toCompanionInsert();
      final newId = await _maintenancesDao.insertMaintenance(companion);
      
      _logger.info('Mantenimiento creado exitosamente con ID: $newId');
      
      return MaintenanceOperationResult.success(
        maintenanceId: newId,
        message: 'Mantenimiento creado exitosamente para el vehículo ${vehicle.licensePlate}',
      );
    } catch (e) {
      _logger.severe('Error creando mantenimiento: $e');
      return MaintenanceOperationResult.failure(
        error: 'Error al crear el mantenimiento: $e',
      );
    }
  }

  /// Actualiza un mantenimiento existente
  Future<MaintenanceOperationResult> updateMaintenance(Maintenance maintenance) async {
    _logger.info('Actualizando mantenimiento ID: ${maintenance.id}');
    
    try {
      // Verificar que el mantenimiento existe
      final existingMaintenance = await _maintenancesDao.getMaintenanceById(maintenance.id);
      if (existingMaintenance == null) {
        return MaintenanceOperationResult.failure(
          error: 'No se encontró un mantenimiento con ID: ${maintenance.id}',
        );
      }

      // Verificar que el vehículo existe
      final vehicle = await _vehiclesDao.getVehicleById(maintenance.vehicleId);
      if (vehicle == null) {
        return MaintenanceOperationResult.failure(
          error: 'No se encontró un vehículo con ID: ${maintenance.vehicleId}',
        );
      }

      // Crear la entidad de Drift actualizada
      final updatedMaintenance = existingMaintenance.copyWith(
        idVehicle: maintenance.vehicleId,
        maintenanceDate: maintenance.maintenanceDate,
        vehicleMileage: maintenance.vehicleMileage,
        details: Value(maintenance.details),
        isActive: maintenance.isActive,
      );
      
      final success = await _maintenancesDao.updateMaintenance(updatedMaintenance);
      
      if (success) {
        _logger.info('Mantenimiento actualizado exitosamente');
        return MaintenanceOperationResult.success(
          maintenanceId: maintenance.id,
          message: 'Mantenimiento actualizado exitosamente',
        );
      } else {
        return MaintenanceOperationResult.failure(
          error: 'No se pudo actualizar el mantenimiento',
        );
      }
    } catch (e) {
      _logger.severe('Error actualizando mantenimiento: $e');
      return MaintenanceOperationResult.failure(
        error: 'Error al actualizar el mantenimiento: $e',
      );
    }
  }

  /// Elimina (soft delete) un mantenimiento
  Future<MaintenanceOperationResult> deleteMaintenance(int maintenanceId) async {
    _logger.info('Eliminando mantenimiento ID: $maintenanceId');
    
    try {
      // Verificar que el mantenimiento existe
      final existingMaintenance = await _maintenancesDao.getMaintenanceById(maintenanceId);
      if (existingMaintenance == null) {
        return MaintenanceOperationResult.failure(
          error: 'No se encontró un mantenimiento con ID: $maintenanceId',
        );
      }

      // Eliminar también los detalles asociados
      final allDetails = await _maintenanceDetailsDao.getAllActiveDetails();
      final maintenanceDetails = allDetails.where((d) => d.idMaintenance == maintenanceId).toList();
      
      for (final detail in maintenanceDetails) {
        await _maintenanceDetailsDao.softDeleteMaintenanceDetail(detail.idDetail);
      }

      // Eliminar el mantenimiento
      final result = await _maintenancesDao.softDeleteMaintenance(maintenanceId);
      
      if (result > 0) {
        _logger.info('Mantenimiento eliminado exitosamente');
        return MaintenanceOperationResult.success(
          maintenanceId: maintenanceId,
          message: 'Mantenimiento eliminado exitosamente',
        );
      } else {
        return MaintenanceOperationResult.failure(
          error: 'No se pudo eliminar el mantenimiento',
        );
      }
    } catch (e) {
      _logger.severe('Error eliminando mantenimiento: $e');
      return MaintenanceOperationResult.failure(
        error: 'Error al eliminar el mantenimiento: $e',
      );
    }
  }

  /// Obtiene los detalles de un mantenimiento específico
  Future<MaintenanceDetailQueryResult> getMaintenanceDetails(int maintenanceId) async {
    _logger.info('Consultando detalles del mantenimiento ID: $maintenanceId');
    
    try {
      // Usar el método específico en lugar de getAllActive
      final maintenanceDetails = await _maintenanceDetailsDao.getDetailsByMaintenanceId(maintenanceId);
      final details = maintenanceDetails.map((d) => d.toDomain()).toList();

      _logger.info('Se encontraron ${details.length} detalles para el mantenimiento $maintenanceId');
      
      return MaintenanceDetailQueryResult.success(
        details: details,
        totalFound: details.length,
        message: 'Detalles obtenidos exitosamente',
      );
    } catch (e) {
      _logger.severe('Error consultando detalles del mantenimiento: $e');
      return MaintenanceDetailQueryResult.failure(
        error: 'Error al obtener los detalles: $e',
      );
    }
  }

  /// Crea un nuevo detalle de mantenimiento
  Future<MaintenanceDetailOperationResult> createMaintenanceDetail(MaintenanceDetail detail) async {
    _logger.info('Creando nuevo detalle para mantenimiento ID: ${detail.maintenanceId}');
    
    try {
      // Verificar que el mantenimiento existe
      final maintenance = await _maintenancesDao.getMaintenanceById(detail.maintenanceId);
      if (maintenance == null) {
        return MaintenanceDetailOperationResult.failure(
          error: 'No se encontró un mantenimiento con ID: ${detail.maintenanceId}',
        );
      }

      final companion = detail.toCompanionInsert();
      final newId = await _maintenanceDetailsDao.insertMaintenanceDetail(companion);
      
      _logger.info('Detalle de mantenimiento creado exitosamente con ID: $newId');
      
      return MaintenanceDetailOperationResult.success(
        detailId: newId,
        message: 'Detalle de mantenimiento creado exitosamente',
      );
    } catch (e) {
      _logger.severe('Error creando detalle de mantenimiento: $e');
      return MaintenanceDetailOperationResult.failure(
        error: 'Error al crear el detalle: $e',
      );
    }
  }

  /// Actualiza un detalle de mantenimiento
  Future<MaintenanceDetailOperationResult> updateMaintenanceDetail(MaintenanceDetail detail) async {
    _logger.info('Actualizando detalle ID: ${detail.id}');
    
    try {
      // Verificar que el detalle existe
      final existingDetail = await _maintenanceDetailsDao.getDetailById(detail.id);
      if (existingDetail == null) {
        return MaintenanceDetailOperationResult.failure(
          error: 'No se encontró un detalle con ID: ${detail.id}',
        );
      }

      // Crear la entidad de Drift actualizada
      final updatedDetail = existingDetail.copyWith(
        idMaintenance: detail.maintenanceId,
        description: detail.description,
        cost: detail.cost,
        isActive: detail.isActive,
      );

      final success = await _maintenanceDetailsDao.updateMaintenanceDetail(updatedDetail);
      
      if (success) {
        _logger.info('Detalle de mantenimiento actualizado exitosamente');
        return MaintenanceDetailOperationResult.success(
          detailId: detail.id,
          message: 'Detalle actualizado exitosamente',
        );
      } else {
        return MaintenanceDetailOperationResult.failure(
          error: 'No se pudo actualizar el detalle',
        );
      }
    } catch (e) {
      _logger.severe('Error actualizando detalle: $e');
      return MaintenanceDetailOperationResult.failure(
        error: 'Error al actualizar el detalle: $e',
      );
    }
  }

  /// Elimina un detalle de mantenimiento
  Future<MaintenanceDetailOperationResult> deleteMaintenanceDetail(int detailId) async {
    _logger.info('Eliminando detalle ID: $detailId');
    
    try {
      // Verificar que el detalle existe
      final existingDetail = await _maintenanceDetailsDao.getDetailById(detailId);
      if (existingDetail == null) {
        return MaintenanceDetailOperationResult.failure(
          error: 'No se encontró un detalle con ID: $detailId',
        );
      }

      final result = await _maintenanceDetailsDao.softDeleteMaintenanceDetail(detailId);
      
      if (result > 0) {
        _logger.info('Detalle eliminado exitosamente');
        return MaintenanceDetailOperationResult.success(
          detailId: detailId,
          message: 'Detalle eliminado exitosamente',
        );
      } else {
        return MaintenanceDetailOperationResult.failure(
          error: 'No se pudo eliminar el detalle',
        );
      }
    } catch (e) {
      _logger.severe('Error eliminando detalle: $e');
      return MaintenanceDetailOperationResult.failure(
        error: 'Error al eliminar el detalle: $e',
      );
    }
  }

  /// Stream de todos los mantenimientos activos
  Stream<List<MaintenanceWithVehicle>> watchAllActiveMaintenances() {
    _logger.info('Iniciando stream de mantenimientos activos');
    
    try {
      return _maintenancesDao.watchAllActiveMaintenances().asyncMap((maintenanceDataList) async {
        final maintenancesWithVehicle = <MaintenanceWithVehicle>[];
        
        for (final maintenanceData in maintenanceDataList) {
          final maintenance = maintenanceData.toDomain();
          final vehicle = await _vehiclesDao.getVehicleById(maintenance.vehicleId);
          
          maintenancesWithVehicle.add(MaintenanceWithVehicle(
            maintenance: maintenance,
            vehicleLicensePlate: vehicle?.licensePlate ?? 'N/A',
            vehicleBrand: vehicle?.brand ?? 'N/A',
            vehicleModel: vehicle?.model ?? 'N/A',
          ));
        }
        
        return maintenancesWithVehicle;
      });
    } catch (e) {
      _logger.severe('Error iniciando stream de mantenimientos: $e');
      return Stream.error('Error al obtener stream de mantenimientos: $e');
    }
  }

  /// Obtiene todos los vehículos activos para el dropdown
  Future<List<Vehicle>> getAllActiveVehicles() async {
    try {
      final vehicleDataList = await _vehiclesDao.getAllActive();
      return vehicleDataList.map((v) => v.toDomain()).toList();
    } catch (e) {
      _logger.severe('Error obteniendo vehículos activos: $e');
      return [];
    }
  }
}

// Clases de resultado y modelos adicionales

class MaintenanceWithVehicle {
  final Maintenance maintenance;
  final String vehicleLicensePlate;
  final String vehicleBrand;
  final String vehicleModel;

  const MaintenanceWithVehicle({
    required this.maintenance,
    required this.vehicleLicensePlate,
    required this.vehicleBrand,
    required this.vehicleModel,
  });
}

class MaintenanceQueryResult {
  final bool isSuccess;
  final List<MaintenanceWithVehicle> maintenances;
  final int totalFound;
  final String message;
  final String? error;

  const MaintenanceQueryResult._({
    required this.isSuccess,
    required this.maintenances,
    required this.totalFound,
    required this.message,
    this.error,
  });

  factory MaintenanceQueryResult.success({
    required List<MaintenanceWithVehicle> maintenances,
    required int totalFound,
    required String message,
  }) {
    return MaintenanceQueryResult._(
      isSuccess: true,
      maintenances: maintenances,
      totalFound: totalFound,
      message: message,
    );
  }

  factory MaintenanceQueryResult.failure({
    required String error,
  }) {
    return MaintenanceQueryResult._(
      isSuccess: false,
      maintenances: [],
      totalFound: 0,
      message: 'Consulta fallida',
      error: error,
    );
  }

  factory MaintenanceQueryResult.notFound({
    required String message,
  }) {
    return MaintenanceQueryResult._(
      isSuccess: true,
      maintenances: [],
      totalFound: 0,
      message: message,
    );
  }
}

class MaintenanceOperationResult {
  final bool isSuccess;
  final int? maintenanceId;
  final String message;
  final String? error;

  const MaintenanceOperationResult._({
    required this.isSuccess,
    this.maintenanceId,
    required this.message,
    this.error,
  });

  factory MaintenanceOperationResult.success({
    int? maintenanceId,
    required String message,
  }) {
    return MaintenanceOperationResult._(
      isSuccess: true,
      maintenanceId: maintenanceId,
      message: message,
    );
  }

  factory MaintenanceOperationResult.failure({
    required String error,
  }) {
    return MaintenanceOperationResult._(
      isSuccess: false,
      message: 'Operación fallida',
      error: error,
    );
  }
}

class MaintenanceDetailQueryResult {
  final bool isSuccess;
  final List<MaintenanceDetail> details;
  final int totalFound;
  final String message;
  final String? error;

  const MaintenanceDetailQueryResult._({
    required this.isSuccess,
    required this.details,
    required this.totalFound,
    required this.message,
    this.error,
  });

  factory MaintenanceDetailQueryResult.success({
    required List<MaintenanceDetail> details,
    required int totalFound,
    required String message,
  }) {
    return MaintenanceDetailQueryResult._(
      isSuccess: true,
      details: details,
      totalFound: totalFound,
      message: message,
    );
  }

  factory MaintenanceDetailQueryResult.failure({
    required String error,
  }) {
    return MaintenanceDetailQueryResult._(
      isSuccess: false,
      details: [],
      totalFound: 0,
      message: 'Consulta fallida',
      error: error,
    );
  }
}

class MaintenanceDetailOperationResult {
  final bool isSuccess;
  final int? detailId;
  final String message;
  final String? error;

  const MaintenanceDetailOperationResult._({
    required this.isSuccess,
    this.detailId,
    required this.message,
    this.error,
  });

  factory MaintenanceDetailOperationResult.success({
    int? detailId,
    required String message,
  }) {
    return MaintenanceDetailOperationResult._(
      isSuccess: true,
      detailId: detailId,
      message: message,
    );
  }

  factory MaintenanceDetailOperationResult.failure({
    required String error,
  }) {
    return MaintenanceDetailOperationResult._(
      isSuccess: false,
      message: 'Operación fallida',
      error: error,
    );
  }
}