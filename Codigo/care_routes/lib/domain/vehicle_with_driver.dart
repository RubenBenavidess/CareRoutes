import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_with_driver.freezed.dart';

@freezed
abstract class VehicleWithDriver with _$VehicleWithDriver {
  const factory VehicleWithDriver({
    required int    idVehicle,     // PK vehículo
    required String licensePlate,
    required String model,
    required int    idDriver,
    required String driverName,
    required String idNumber,
  }) = _VehicleWithDriver;
}
