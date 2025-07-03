import 'dart:async';
import 'package:care_routes/data/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usable_driver.dart';
import '../providers/database_providers.dart';

// Opción 1: Usando StateNotifier con manejo correcto de streams
class UsableDriverNotifier
    extends StateNotifier<AsyncValue<List<UsableDriver>>> {
  final Ref _ref;
  StreamSubscription<List<Driver>>? _subscription;

  UsableDriverNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initializeStream();
  }

  void _initializeStream() {
    state = const AsyncValue.loading();

    // Cancelar suscripción anterior si existe
    _subscription?.cancel();

    try {
      final driversDao = _ref.read(driversDaoProvider);

      _subscription = driversDao.watchAllActive().listen(
        (drivers) {
          final usableDrivers =
              drivers
                  .map(
                    (driver) => UsableDriver(
                      idDriver: driver.idDriver,
                      firstName: driver.firstName,
                      lastName: driver.lastName,
                      idNumber: driver.idNumber,
                    ),
                  )
                  .toList();

          state = AsyncValue.data(usableDrivers);
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
final usableDriverNotifierProvider =
    StateNotifierProvider<UsableDriverNotifier, AsyncValue<List<UsableDriver>>>(
      (ref) => UsableDriverNotifier(ref),
    );

final usableDriversStreamProvider = StreamProvider<List<UsableDriver>>((ref) {
  final driversDao = ref.watch(driversDaoProvider);

  return driversDao.watchAllActive().map(
    (drivers) =>
        drivers
            .map(
              (driver) => UsableDriver(
                idDriver: driver.idDriver,
                firstName: driver.firstName,
                lastName: driver.lastName,
                idNumber: driver.idNumber,
              ),
            )
            .toList(),
  );
});
