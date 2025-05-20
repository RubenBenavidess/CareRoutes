import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vehicle_with_driver.dart';

class AssignRoutesState {
  const AssignRoutesState({this.selected = const []});
  final List<VehicleWithDriver> selected;

  AssignRoutesState copyWith({List<VehicleWithDriver>? selected}) =>
      AssignRoutesState(selected: selected ?? this.selected);
}

class AssignRoutesController extends StateNotifier<AssignRoutesState> {
  AssignRoutesController() : super(const AssignRoutesState());

  /// Añade o quita el vehículo de la lista seleccionada
  void toggleVehicle(VehicleWithDriver v) {
    final list = [...state.selected];
    list.contains(v) ? list.remove(v) : list.add(v);
    state = state.copyWith(selected: list);
  }
}

/// Provider que expone **el estado** (AssignRoutesState)
final assignRoutesControllerProvider = StateNotifierProvider<
    AssignRoutesController, AssignRoutesState>(
  (ref) => AssignRoutesController(),
);