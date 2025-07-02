// controllers/usable_vehicle_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usable_vehicle.dart';
import '../providers/database_providers.dart';

final usableVehiclesStreamProvider = StreamProvider<List<UsableVehicle>>((ref) {
  final vehiclesDao = ref.watch(vehiclesDaoProvider);
  
  return vehiclesDao.watchAllActive().map(
    (vehicles) => vehicles
        .map(
          (vehicle) => UsableVehicle(
            idVehicle: vehicle.idVehicle,
            licensePlate: vehicle.licensePlate,
            brand: vehicle.brand,
            model: vehicle.model ?? '',
            mileage: vehicle.mileage,
            year: vehicle.year ?? 0,
            idDriver: vehicle.idDriver,
            status: vehicle.status,
          ),
        )
        .toList(),
  );
});