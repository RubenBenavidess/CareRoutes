class ImportResult {
  final int totalProcessed;
  final int successful;
  final int failed;
  final int duplicatesSkipped;
  final List<String> errors;
  final String fileType;

  ImportResult({
    required this.totalProcessed,
    required this.successful,
    required this.failed,
    required this.duplicatesSkipped,
    required this.errors,
    required this.fileType,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccessful => successful > 0 && failed == 0;
}
