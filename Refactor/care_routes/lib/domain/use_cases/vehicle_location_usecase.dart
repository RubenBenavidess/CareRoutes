// domain/use_cases/vehicle_location_usecase.dart
import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';
import '../entities/domain_entities.dart';

class VehicleLocationUseCase {
  static final _logger = Logger('VehicleLocationUseCase');

  VehicleLocationUseCase();

  /// Obtiene la ubicación actual del vehículo (una sola vez)
  Future<VehicleLocationResult> getCurrentLocation(Vehicle vehicle) async {
    _logger.info('Obteniendo ubicación actual del vehículo ${vehicle.licensePlate}');

    try {
      if (vehicle.gpsDeviceId == null) {
        throw Exception('El vehículo ${vehicle.licensePlate} no tiene dispositivo GPS asignado');
      }

      // Simular llamada al dispositivo GPS
      await Future.delayed(const Duration(seconds: 2));
      
      final location = _simulateGpsReading(vehicle);
      
      _logger.info('Ubicación obtenida para ${vehicle.licensePlate}: ${location.latitude}, ${location.longitude}');

      return VehicleLocationResult.success(
        location: location,
        message: 'Ubicación obtenida exitosamente',
      );
    } catch (e) {
      _logger.severe('Error obteniendo ubicación del vehículo ${vehicle.licensePlate}: $e');
      return VehicleLocationResult.failure(
        error: 'Error al obtener la ubicación: $e',
      );
    }
  }

  /// Stream que obtiene la ubicación del vehículo cada 30 segundos
  Stream<VehicleLocationResult> watchVehicleLocation(Vehicle vehicle) {
    _logger.info('Iniciando stream de ubicación para ${vehicle.licensePlate}');

    if (vehicle.gpsDeviceId == null) {
      return Stream.error('El vehículo ${vehicle.licensePlate} no tiene dispositivo GPS asignado');
    }

    return Stream.periodic(const Duration(seconds: 30), (count) {
      try {
        final location = _simulateGpsReading(vehicle);
        _logger.info('Ubicación actualizada para ${vehicle.licensePlate} (${count + 1})');
        
        return VehicleLocationResult.success(
          location: location,
          message: 'Ubicación actualizada automáticamente',
        );
      } catch (e) {
        _logger.warning('Error en actualización automática para ${vehicle.licensePlate}: $e');
        return VehicleLocationResult.failure(
          error: 'Error al actualizar ubicación: $e',
        );
      }
    });
  }

  /// Verifica si un vehículo tiene GPS disponible
  Future<GpsStatusResult> checkGpsStatus(Vehicle vehicle) async {
    _logger.info('Verificando estado del GPS para ${vehicle.licensePlate}');

    try {
      if (vehicle.gpsDeviceId == null) {
        return GpsStatusResult(
          hasGps: false,
          isOnline: false,
          message: 'Vehículo sin dispositivo GPS asignado',
        );
      }

      // Simular verificación de conexión del dispositivo
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simular que 90% de los dispositivos están online
      final isOnline = Random().nextDouble() > 0.1;
      
      return GpsStatusResult(
        hasGps: true,
        isOnline: isOnline,
        deviceId: vehicle.gpsDeviceId!.toString(),
        message: isOnline ? 'Dispositivo GPS conectado' : 'Dispositivo GPS desconectado',
        lastConnection: isOnline ? DateTime.now() : DateTime.now().subtract(Duration(minutes: Random().nextInt(60))),
      );
    } catch (e) {
      _logger.severe('Error verificando GPS del vehículo ${vehicle.licensePlate}: $e');
      return GpsStatusResult(
        hasGps: false,
        isOnline: false,
        message: 'Error al verificar estado del GPS: $e',
      );
    }
  }

  // Simula la lectura del GPS (en producción esto sería una llamada real al dispositivo)
  CurrentVehicleLocation _simulateGpsReading(Vehicle vehicle) {
    final random = Random();
    
    // Coordenadas base de Quito, Ecuador (puedes cambiar por tu ciudad)
    final baseLatitude = -0.2201641;
    final baseLongitude = -78.5123274;
    
    // Agregar variación aleatoria para simular movimiento (radio de ~10km)
    final latVariation = (random.nextDouble() - 0.5) * 0.2;
    final lngVariation = (random.nextDouble() - 0.5) * 0.2;
    
    return CurrentVehicleLocation(
      vehicleId: vehicle.id,
      licensePlate: vehicle.licensePlate,
      gpsDeviceId: vehicle.gpsDeviceId!.toString(),
      latitude: baseLatitude + latVariation,
      longitude: baseLongitude + lngVariation,
      speed: random.nextDouble() * 80, // 0-80 km/h
      timestamp: DateTime.now(),
      accuracy: 5.0 + random.nextDouble() * 10, // 5-15 metros
    );
  }
}

// Clases de resultado

class VehicleLocationResult {
  final bool isSuccess;
  final CurrentVehicleLocation? location;
  final String message;
  final String? error;

  const VehicleLocationResult._({
    required this.isSuccess,
    this.location,
    required this.message,
    this.error,
  });

  factory VehicleLocationResult.success({
    required CurrentVehicleLocation location,
    required String message,
  }) {
    return VehicleLocationResult._(
      isSuccess: true,
      location: location,
      message: message,
    );
  }

  factory VehicleLocationResult.failure({
    required String error,
  }) {
    return VehicleLocationResult._(
      isSuccess: false,
      message: 'Error en ubicación',
      error: error,
    );
  }
}

class GpsStatusResult {
  final bool hasGps;
  final bool isOnline;
  final String? deviceId;
  final String message;
  final DateTime? lastConnection;

  const GpsStatusResult({
    required this.hasGps,
    required this.isOnline,
    this.deviceId,
    required this.message,
    this.lastConnection,
  });
}
