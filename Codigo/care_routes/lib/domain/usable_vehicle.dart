// domain/usable_vehicle.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/enums.dart';

part 'usable_vehicle.freezed.dart';

@freezed
abstract class UsableVehicle with _$UsableVehicle {
  const factory UsableVehicle({
    required int idVehicle,
    required String licensePlate,
    required String brand,
    required String model,
    required int mileage,
    required int year,
    int? idDriver,
    required VehicleStatus status,
  }) = _UsableVehicle;
}