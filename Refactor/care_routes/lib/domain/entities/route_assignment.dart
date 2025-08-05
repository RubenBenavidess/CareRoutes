
class RouteAssignment {
  final int id;
  final int routeId;
  final int vehicleId;
  final DateTime assignedDate;
  final bool isActive;

  RouteAssignment({
    required this.id,
    required this.routeId,
    required this.vehicleId,
    required this.assignedDate,
    required this.isActive,
  });
}