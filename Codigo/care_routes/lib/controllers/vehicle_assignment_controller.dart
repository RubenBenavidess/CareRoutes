// controllers/vehicle_assignment_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_providers.dart';

class VehicleAssignmentController {
  final Ref ref;
  
  VehicleAssignmentController(this.ref);
  
  Future<void> assignDriverToVehicle(int vehicleId, int driverId) async {
    final vehiclesDao = ref.read(vehiclesDaoProvider);
    
    await vehiclesDao.assignDriver(vehicleId, driverId);
  }
  
  Future<void> unassignDriverFromVehicle(int vehicleId) async {
    final vehiclesDao = ref.read(vehiclesDaoProvider);
    await vehiclesDao.unassignDriver(vehicleId);
  }
}

final vehicleAssignmentControllerProvider = Provider((ref) {
  return VehicleAssignmentController(ref);
});