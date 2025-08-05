class MaintenanceDetail {
  final int id;
  final int maintenanceId;
  final String description;
  final double cost;
  final bool isActive;

  MaintenanceDetail({
    required this.id,
    required this.maintenanceId,
    required this.description,
    required this.cost,
    required this.isActive,
  });
}