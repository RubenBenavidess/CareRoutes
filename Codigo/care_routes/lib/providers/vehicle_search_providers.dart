import 'package:care_routes/domain/vehicle_with_driver.dart';
import 'package:care_routes/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleQueryProvider = StateProvider<String>((_) => '');

final vehicleSearchProvider =
    StreamProvider.autoDispose.family<List<VehicleWithDriver>, String>(
  (ref, query) {
    final dao = ref.watch(vehiclesDaoProvider);
    // ahora *siempre* consultamos – el DAO decide si filtra
    return dao.search(query);
  },
);