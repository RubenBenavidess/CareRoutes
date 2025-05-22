import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vehicle_with_driver.dart';

class AssignRoutesState {
  const AssignRoutesState({
    this.selected = const [],
    this.dates    = const {}
  });
  final List<VehicleWithDriver> selected;
  final Map<int, DateTime?> dates;

  AssignRoutesState copyWith({List<VehicleWithDriver>? selected, Map<int, DateTime?>? dates}) =>
      AssignRoutesState(
        selected: selected ?? this.selected,
        dates: dates ?? this.dates,
      );
}

class AssignRoutesController extends StateNotifier<AssignRoutesState> {
  AssignRoutesController() : super(const AssignRoutesState());

  /// Añade o quita el vehículo de la lista seleccionada
  void toggleVehicle(VehicleWithDriver v) {
    final list = [...state.selected];
    list.contains(v) ? list.remove(v) : list.add(v);
    state = state.copyWith(selected: list);
  }

  void setDate(VehicleWithDriver v, DateTime date) {
    final newDates = Map<int, DateTime?>.from(state.dates)
      ..[v.idVehicle] = date;
    state = state.copyWith(dates: newDates);
  }
}

/// Provider que expone **el estado** (AssignRoutesState)
final assignRoutesControllerProvider = StateNotifierProvider<
    AssignRoutesController, AssignRoutesState>(
  (ref) => AssignRoutesController(),
);