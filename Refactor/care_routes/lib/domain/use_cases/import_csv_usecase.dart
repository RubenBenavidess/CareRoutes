// import_csv_usecase.dart
import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:logging/logging.dart';
import '../entities/domain_entities.dart';
import '../enums.dart';
import '../../data/local_repository/daos/drivers_dao.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/mappers.dart';

class ImportCsvUseCase {
  static final _logger = Logger('ImportCsvUseCase');
  
  final DriversDao _driversDao;
  final VehiclesDao _vehiclesDao;

  ImportCsvUseCase({
    required DriversDao driversDao,
    required VehiclesDao vehiclesDao,
  })  : _driversDao = driversDao,
        _vehiclesDao = vehiclesDao;

  Future<ImportResult> execute(XFile file) async {
    _logger.info('Iniciando importación de archivo: ${file.name}');
    
    try {
      final content = await file.readAsString();
      
      if (!_isValidCsvFormat(content)) {
        throw FormatException('El archivo no tiene un formato CSV válido');
      }

      final nameLower = file.name.toLowerCase();

      if (nameLower.contains('conductor')) {
        return await _importDrivers(content, file.name);
      } else if (nameLower.contains('vehiculo')) {
        return await _importVehicles(content, file.name);
      } else {
        throw UnsupportedError(
          'Tipo de archivo no soportado. '
          'El nombre del archivo debe contener "conductor" o "vehiculo". '
          'Archivo recibido: ${file.name}'
        );
      }
    } catch (e) {
      _logger.severe('Error durante la importación: $e');
      return ImportResult(
        totalProcessed: 0,
        successful: 0,
        failed: 1,
        duplicatesSkipped: 0,
        errors: [e.toString()],
        fileType: 'unknown',
      );
    }
  }

  Future<ImportResult> _importDrivers(String content, String fileName) async {
    _logger.info('Procesando archivo de conductores');
    
    final errors = <String>[];
    final drivers = <Driver>[];
    int duplicatesSkipped = 0;
    int processed = 0;

    try {
      final lines = const LineSplitter().convert(content);
      final delimiter = _detectDelimiter(lines.first);
      final headers = lines.first.split(delimiter)
          .map((h) => h.trim().toLowerCase().replaceAll('"', ''))
          .toList();

      final firstNameIndex = _findIndex(headers, ['nombre', 'first name', 'firstname']);
      final lastNameIndex = _findIndex(headers, ['apellido', 'last name', 'lastname']);
      final idNumberIndex = _findIndex(headers, ['cedula', 'dni', 'id', 'idnumber']);

      if (firstNameIndex == -1) {
        throw FormatException('No se encontró la columna de nombre (nombre, first name, firstname)');
      }
      if (idNumberIndex == -1) {
        throw FormatException('No se encontró la columna de cédula (cedula, dni, id, idnumber)');
      }

      final existingIdNumbers = await _driversDao.getAllIdNumbers();

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        processed++;
        try {
          final columns = line.split(delimiter)
              .map((col) => col.trim().replaceAll('"', ''))
              .toList();

          final firstName = _validateRequiredField(columns, firstNameIndex, 'nombre', i + 1);
          final lastName = (lastNameIndex >= 0 && columns.length > lastNameIndex)
              ? columns[lastNameIndex].trim()
              : '';
          final idNumber = _validateRequiredField(columns, idNumberIndex, 'cédula', i + 1);

          if (existingIdNumbers.contains(idNumber)) {
            duplicatesSkipped++;
            _logger.warning('Conductor con cédula $idNumber ya existe, omitiendo...');
            continue;
          }

          if (!_isValidIdNumber(idNumber)) {
            errors.add('Línea ${i + 1}: Formato de cédula inválido: $idNumber');
            continue;
          }

          final driver = Driver(
            id: 0,
            firstName: firstName,
            lastName: lastName,
            idNumber: idNumber,
            isActive: true,
          );

          drivers.add(driver);
          
        } catch (e) {
          errors.add('Línea ${i + 1}: $e');
          _logger.warning('Error procesando línea ${i + 1}: $e');
        }
      }

      int successful = 0;
      if (drivers.isNotEmpty) {
        successful = await _insertDriversBatch(drivers);
        _logger.info('Insertados $successful conductores exitosamente');
      }

      return ImportResult(
        totalProcessed: processed,
        successful: successful,
        failed: errors.length,
        duplicatesSkipped: duplicatesSkipped,
        errors: errors,
        fileType: 'conductores',
      );

    } catch (e) {
      _logger.severe('Error procesando archivo de conductores: $e');
      return ImportResult(
        totalProcessed: processed,
        successful: 0,
        failed: processed,
        duplicatesSkipped: duplicatesSkipped,
        errors: [e.toString(), ...errors],
        fileType: 'conductores',
      );
    }
  }

  Future<ImportResult> _importVehicles(String content, String fileName) async {
    _logger.info('Procesando archivo de vehículos');
    
    final errors = <String>[];
    final vehicles = <Vehicle>[];
    int duplicatesSkipped = 0;
    int processed = 0;

    try {
      final lines = const LineSplitter().convert(content);
      final delimiter = _detectDelimiter(lines.first);
      final headers = lines.first.split(delimiter)
          .map((h) => h.trim().toLowerCase().replaceAll('"', ''))
          .toList();

      final brandIndex = _findIndex(headers, ['marca', 'brand']);
      final plateIndex = _findIndex(headers, ['placa', 'license plate', 'plate']);
      final driverIndex = _findIndex(headers, ['conductor', 'driver', 'cedula_conductor']);
      final modelIndex = _findIndex(headers, ['modelo', 'model']);
      final mileageIndex = _findIndex(headers, ['kilometraje', 'mileage', 'km']);
      final yearIndex = _findIndex(headers, ['año', 'year', 'ano']);

      if (brandIndex == -1) {
        throw FormatException('No se encontró la columna de marca (marca, brand)');
      }
      if (plateIndex == -1) {
        throw FormatException('No se encontró la columna de placa (placa, license plate, plate)');
      }

      final existingPlates = await _vehiclesDao.getAllLicensePlates();
      
      final driversMap = await _createDriversMapByIdNumber();

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        processed++;
        try {
          final columns = line.split(delimiter)
              .map((col) => col.trim().replaceAll('"', ''))
              .toList();

          final brand = _validateRequiredField(columns, brandIndex, 'marca', i + 1);
          final licensePlate = _validateRequiredField(columns, plateIndex, 'placa', i + 1);

          if (existingPlates.contains(licensePlate.toUpperCase())) {
            duplicatesSkipped++;
            _logger.warning('Vehículo con placa $licensePlate ya existe, omitiendo...');
            continue;
          }

          int? driverId;
          if (driverIndex >= 0 && columns.length > driverIndex && columns[driverIndex].isNotEmpty) {
            final driverIdNumber = columns[driverIndex].trim();
            driverId = driversMap[driverIdNumber];
            if (driverId == null) {
              _logger.warning('Línea ${i + 1}: No se encontró conductor con cédula: $driverIdNumber');
            }
          }

          final model = (modelIndex >= 0 && columns.length > modelIndex && columns[modelIndex].isNotEmpty)
              ? columns[modelIndex].trim()
              : null;

          int? year;
          if (yearIndex >= 0 && columns.length > yearIndex && columns[yearIndex].isNotEmpty) {
            year = int.tryParse(columns[yearIndex].trim());
            if (year != null && (year < 1900 || year > DateTime.now().year + 1)) {
              _logger.warning('Línea ${i + 1}: Año inválido: $year');
              year = null;
            }
          }

          int mileage = 0;
          if (mileageIndex >= 0 && columns.length > mileageIndex && columns[mileageIndex].isNotEmpty) {
            final mileageStr = columns[mileageIndex].replaceAll(RegExp(r'[^\d]'), '');
            mileage = int.tryParse(mileageStr) ?? 0;
          }

          final vehicle = Vehicle(
            id: 0,
            driverId: driverId,
            licensePlate: licensePlate.toUpperCase(),
            brand: brand,
            model: model,
            year: year,
            status: VehicleStatus.available,
            mileage: mileage,
            gpsDeviceId: null,
            obdDeviceId: null,
            isActive: true,
          );

          vehicles.add(vehicle);
          
        } catch (e) {
          errors.add('Línea ${i + 1}: $e');
          _logger.warning('Error procesando línea ${i + 1}: $e');
        }
      }

      int successful = 0;
      if (vehicles.isNotEmpty) {
        successful = await _insertVehiclesBatch(vehicles);
        _logger.info('Insertados $successful vehículos exitosamente');
      }

      return ImportResult(
        totalProcessed: processed,
        successful: successful,
        failed: errors.length,
        duplicatesSkipped: duplicatesSkipped,
        errors: errors,
        fileType: 'vehículos',
      );

    } catch (e) {
      _logger.severe('Error procesando archivo de vehículos: $e');
      return ImportResult(
        totalProcessed: processed,
        successful: 0,
        failed: processed,
        duplicatesSkipped: duplicatesSkipped,
        errors: [e.toString(), ...errors],
        fileType: 'vehículos',
      );
    }
  }

  Future<int> _insertDriversBatch(List<Driver> drivers) async {
    if (drivers.isEmpty) return 0;

    return await _driversDao.db.transaction(() async {
      int successful = 0;
      for (final driver in drivers) {
        try {
          final companion = driver.toCompanionInsert();
          await _driversDao.insertDriver(companion);
          successful++;
        } catch (e) {
          _logger.warning('Error insertando conductor ${driver.firstName} ${driver.lastName}: $e');
        }
      }
      return successful;
    });
  }

  Future<int> _insertVehiclesBatch(List<Vehicle> vehicles) async {
    if (vehicles.isEmpty) return 0;

    return await _vehiclesDao.db.transaction(() async {
      int successful = 0;
      for (final vehicle in vehicles) {
        try {
          final companion = vehicle.toCompanionInsert();
          await _vehiclesDao.insertVehicle(companion);
          successful++;
        } catch (e) {
          _logger.warning('Error insertando vehículo ${vehicle.licensePlate}: $e');
        }
      }
      return successful;
    });
  }

  Future<Map<String, int>> _createDriversMapByIdNumber() async {
    final drivers = await _driversDao.getAllDrivers();
    return {
      for (final driver in drivers)
        driver.idNumber: driver.idDriver,
    };
  }

  bool _isValidCsvFormat(String content) {
    if (content.trim().isEmpty) return false;
    
    final lines = const LineSplitter().convert(content);
    return lines.isNotEmpty && 
            lines.first.isNotEmpty && 
            lines.length > 1;
  }

  String _validateRequiredField(List<String> columns, int index, String fieldName, int lineNumber) {
    if (index < 0) {
      throw FormatException('Columna $fieldName no encontrada en el archivo');
    }
    
    if (columns.length <= index) {
      throw FormatException('Línea $lineNumber: Falta la columna $fieldName');
    }
    
    final value = columns[index].trim();
    if (value.isEmpty) {
      throw FormatException('Línea $lineNumber: El campo $fieldName no puede estar vacío');
    }
    
    return value;
  }

  bool _isValidIdNumber(String idNumber) {
    return RegExp(r'^\d{9,10}$').hasMatch(idNumber);
  }

  String _detectDelimiter(String header) {
    final counts = {
      ',': ','.allMatches(header).length,
      ';': ';'.allMatches(header).length,
      '\t': '\t'.allMatches(header).length,
    };
    
    final maxEntry = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    
    return maxEntry.value > 0 ? maxEntry.key : ',';
  }

  int _findIndex(List<String> headers, List<String> candidates) {
    for (final candidate in candidates) {
      final index = headers.indexWhere((header) => 
        header.toLowerCase().trim() == candidate.toLowerCase().trim());
      if (index != -1) return index;
    }
    return -1;
  }
}