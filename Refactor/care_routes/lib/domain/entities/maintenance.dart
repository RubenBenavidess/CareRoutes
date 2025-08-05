class Maintenance {
  final int id;
  final int vehicleId;
  final DateTime maintenanceDate;
  final int vehicleMileage;
  final String? details;
  final bool isActive;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.maintenanceDate,
    required this.vehicleMileage,
    this.details,
    required this.isActive,
  });
}