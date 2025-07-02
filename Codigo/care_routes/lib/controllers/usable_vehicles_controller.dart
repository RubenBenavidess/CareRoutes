import 'dart:async';
import 'package:care_routes/data/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usable_driver.dart';
import '../providers/database_providers.dart';

// Opción 1: Usando StateNotifier con manejo correcto de streams
class UsableVehicleNotifier
    extends StateNotifier<AsyncValue<List<UsableVehicle>>> {
  final Ref _ref;
  StreamSubscription<List<Vehicle>>? _subscription;

  UsableVehicleNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initializeStream();
  }

  void _initializeStream() {
    state = const AsyncValue.loading();

    // Cancelar suscripción anterior si existe
    _subscription?.cancel();

    try {
      final vehiclesDao = _ref.read(vehiclesDaoProvider);

      _subscription = vehiclesDao.watchAllActive().listen(
        (vehicles) {
          final usableVehicles =
              vehicles
                  .map(
                    (vehicle) => UsableVehicle(
                      idVehicle: vehicle.idVehicle,
                      make: vehicle.make,
                      model: vehicle.model,
                      year: vehicle.year,
                    ),
                  )
                  .toList();

          state = AsyncValue.data(usableVehicles);
        },
        onError: (error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
          state = AsyncValue.data(usableVehicles);
        },
        onError: (error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Provider principal
final usableVehicleNotifierProvider =
    StateNotifierProvider<UsableVehicleNotifier, AsyncValue<List<UsableVehicle>>>(
      (ref) => UsableVehicleNotifier(ref),
    );

// Opción 2 (RECOMENDADA): Usar StreamProvider directamente
final usableVehiclesStreamProvider = StreamProvider<List<UsableVehicle>>((ref) {
  final vehiclesDao = ref.watch(vehiclesDaoProvider);

  return vehiclesDao.watchAllActive().map(
    (vehicles) =>
        vehicles
            .map(
              (vehicle) => UsableVehicle(
                idVehicle: vehicle.idVehicle,
                make: vehicle.make,
                model: vehicle.model,
                year: vehicle.year,
              ),
            )
            .toList(),
  );
});

// Provider para obtener un vehicle específico
final vehicleByIdProvider = FutureProvider.family<UsableVehicle?, int>((
  ref,
  id,
) async {
  final vehiclesDao = ref.watch(vehiclesDaoProvider);
  final vehicle = await vehiclesDao.getVehicleById(id);

  if (vehicle == null) return null;

  return UsableVehicle(
    idVehicle: vehicle.idVehicle,
    make: vehicle.make,
    model: vehicle.model,
    year: vehicle.year,
  );
});
