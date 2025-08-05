class Stop {
  final int id;
  final int routeId;
  final double latitude;
  final double longitude;
  final bool isActive;

  Stop({
    required this.id,
    required this.routeId,
    required this.latitude,
    required this.longitude,
    required this.isActive,
  });
}