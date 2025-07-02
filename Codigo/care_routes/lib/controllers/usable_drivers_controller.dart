import 'package:care_routes/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usable_driver.dart';
import '../data/daos/drivers_dao.dart';

// Class that allows the interaction with service and manage the state of course.

class UsableDriverNotifier extends StateNotifier<List<UsableDriver>>{

    late DriversDao _usableDriversService;

    UsableDriverNotifier() : super([]);

    void initService(WidgetRef ref){
        _usableDriversService = DriversDao(ref.read(dbProvider));
    }

    Future<void> loadUsableDrivers() async {
        final drivers = await _usableDriversService.getAllActive();
        // List<UsableDriver> usableDrivers = List.of(drivers.map(
        //     (d) => UsableDriver(
        //         idDriver: d.idDriver, firstName: d.firstName,
        //         lastName: d.lastName, idNumber: d.idNumber)
        // ));
         List<UsableDriver> usableDrivers = List.from(
            [UsableDriver(idDriver: 1, firstName: "Ruben", lastName: "Benavides", idNumber: "1723011696")]
         );
        state = usableDrivers;
    }

}

final usableDriverNotifierProvider = StateNotifierProvider<UsableDriverNotifier, List<UsableDriver>>(
  (ref) => UsableDriverNotifier()
);
