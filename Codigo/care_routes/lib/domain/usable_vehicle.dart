import 'package:freezed_annotation/freezed_annotation.dart';

part 'usable_vehicle.freezed.dart';

@freezed
abstract class UsableVehicle with _$UsableVehicle {
  const factory UsableVehicle({
    required int idVehicle, // PK vehículo
    required String make,
    required String model,
    required String year,
  }) = _UsableVehicle;
}
