class ObdDevice {
  final int id;
  final String? model;
  final String serialNumber;
  final DateTime? installedAt;
  final bool isActive;

  ObdDevice({
    required this.id,
    this.model,
    required this.serialNumber,
    this.installedAt,
    required this.isActive,
  });
}