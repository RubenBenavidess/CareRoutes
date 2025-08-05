class GpsDevice {
  final int id;
  final String? model;
  final String serialNumber;
  final DateTime? installedAt;
  final bool isActive;

  GpsDevice({
    required this.id,
    this.model,
    required this.serialNumber,
    this.installedAt,
    required this.isActive,
  });
}