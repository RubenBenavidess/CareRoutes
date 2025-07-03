// controllers/usable_vehicle_controller.dart
import 'dart:async';
import 'package:care_routes/data/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usable_vehicle.dart';
import '../providers/database_providers.dart';

// Provider para el texto de búsqueda
final vehicleSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider principal con todos los vehículos
final usableVehiclesStreamProvider = StreamProvider<List<UsableVehicle>>((ref) {
  final vehiclesDao = ref.watch(vehiclesDaoProvider);

  return vehiclesDao.watchAllActive().map(
    (vehicles) =>
        vehicles
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

// Provider filtrado por placa
final filteredVehiclesProvider = Provider<AsyncValue<List<UsableVehicle>>>((
  ref,
) {
  final vehiclesAsync = ref.watch(usableVehiclesStreamProvider);
  final searchQuery =
      ref.watch(vehicleSearchQueryProvider).toLowerCase().trim();

  return vehiclesAsync.whenData((vehicles) {
    if (searchQuery.isEmpty) {
      return vehicles;
    }

    return vehicles.where((vehicle) {
      // Buscar en placa, marca y modelo
      return vehicle.licensePlate.toLowerCase().contains(searchQuery) ||
          vehicle.brand.toLowerCase().contains(searchQuery) ||
          vehicle.model.toLowerCase().contains(searchQuery);
    }).toList();
  });
});

// Provider para buscar vehículo específico por placa exacta
final vehicleByLicensePlateProvider =
    FutureProvider.family<UsableVehicle?, String>((ref, licensePlate) async {
      final vehiclesDao = ref.watch(vehiclesDaoProvider);

      try {
        final vehicles = await vehiclesDao.getAllActive();
        final vehicle = vehicles.firstWhere(
          (v) => v.licensePlate.toLowerCase() == licensePlate.toLowerCase(),
          orElse: () => throw Exception('Vehículo no encontrado'),
        );

        return UsableVehicle(
          idVehicle: vehicle.idVehicle,
          licensePlate: vehicle.licensePlate,
          brand: vehicle.brand,
          model: vehicle.model ?? '',
          mileage: vehicle.mileage,
          year: vehicle.year ?? 0,
          idDriver: vehicle.idDriver,
          status: vehicle.status,
        );
      } catch (e) {
        return null;
      }
    });
