// domain/entities/current_vehicle_location.dart
class CurrentVehicleLocation {
  final int vehicleId;
  final String licensePlate;
  final String gpsDeviceId;
  final double latitude;
  final double longitude;
  final double? speed;
  final DateTime timestamp;
  final double? accuracy;

  CurrentVehicleLocation({
    required this.vehicleId,
    required this.licensePlate,
    required this.gpsDeviceId,
    required this.latitude,
    required this.longitude,
    this.speed,
    required this.timestamp,
    this.accuracy,
  });

  String get coordinates => '$latitude, $longitude';
  
  bool get isRecentLocation {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes <= 5;
  }

  String get speedText {
    if (speed == null) return 'N/A';
    return '${speed!.toStringAsFixed(1)} km/h';
  }

  String get accuracyText {
    if (accuracy == null) return 'Desconocida';
    if (accuracy! <= 5) return 'Excelente';
    if (accuracy! <= 10) return 'Buena';
    if (accuracy! <= 20) return 'Regular';
    return 'Baja';
  }
}