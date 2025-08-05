import '../enums.dart';

class Vehicle {
  final int id;
  final int? driverId;
  final String licensePlate;
  final String brand;
  final String? model;
  final int? year;
  final VehicleStatus status;
  final int mileage;
  final int? gpsDeviceId;
  final int? obdDeviceId;
  final bool isActive;

  Vehicle({
    required this.id,
    this.driverId,
    required this.licensePlate,
    required this.brand,
    this.model,
    this.year,
    required this.status,
    required this.mileage,
    this.gpsDeviceId,
    this.obdDeviceId,
    required this.isActive,
  });
}