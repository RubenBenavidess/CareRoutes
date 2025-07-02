import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';

class ImportServices {
  static Future<void> importCsv(XFile xfile, AppDatabase db) async {
    final fileName = xfile.name.toLowerCase();

    // Usa contains en lugar de comparaciones exactas para mayor flexibilidad
    if (fileName.contains('conductor')) {
      await importDriversCsv(xfile, db);
    } else if (fileName.contains('vehiculo')) {
      await importVehiclesCsv(xfile, db);
    } else {
      throw Exception('Formato de archivo no soportado: $fileName');
    }
  }

  static Future<void> importDriversCsv(XFile xfile, AppDatabase db) async {
    try {
      // Lee el archivo CSV
      final content = await xfile.readAsString();
      final rows = const LineSplitter().convert(content);

      // Detectar automáticamente el delimitador
      String delimiter = detectDelimiter(content);
      print('Delimitador detectado: "$delimiter"');

      final data = rows.map((r) => r.split(delimiter)).toList();

      // Obtiene los índices de las columnas
      final headers = data[0];
      print('Encabezados: $headers');

      // Verificar diferentes posibilidades para nombres de columnas
      int firstNameIndex = findColumnIndex(headers, [
        'nombre',
        'first name',
        'firstname',
        'name',
      ]);
      int lastNameIndex = findColumnIndex(headers, [
        'apellido',
        'last name',
        'lastname',
      ]);
      int idNumberIndex = findColumnIndex(headers, [
        'cedula',
        'dni',
        'id',
        'idnumber',
        'id number',
      ]);

      if (firstNameIndex == -1) {
        throw Exception(
          'No se encontró una columna para el nombre del conductor',
        );
      }

      // Crea una lista de DriversCompanion
      List<DriversCompanion> drivers = [];

      for (var i = 1; i < data.length; i++) {
        if (data[i].isNotEmpty && data[i].length > firstNameIndex) {
          final driver = DriversCompanion.insert(
            firstName: data[i][firstNameIndex].trim(),
            lastName:
                lastNameIndex != -1 && data[i].length > lastNameIndex
                    ? data[i][lastNameIndex].trim()
                    : '',
            idNumber:
                idNumberIndex != -1 && data[i].length > idNumberIndex
                    ? data[i][idNumberIndex].trim()
                    : 'DNI${DateTime.now().millisecondsSinceEpoch}',
          );
          drivers.add(driver);
        }
      }

      // Verificar si hay conductores para importar
      if (drivers.isEmpty) {
        throw Exception('No se encontraron conductores válidos para importar');
      }

      // Usar una transacción para insertar los datos en lote
      await db.transaction(() async {
        for (final driver in drivers) {
          await db.into(db.drivers).insert(driver);
        }
      });

      print('${drivers.length} conductores importados exitosamente');
    } catch (e) {
      print('Error al importar conductores: $e');
      rethrow; // Propaga el error para que se pueda manejar en el nivel superior
    }
  }

  static Future<void> importVehiclesCsv(XFile xfile, AppDatabase db) async {
    try {
      // Lee el archivo CSV
      final content = await xfile.readAsString();
      final rows = const LineSplitter().convert(content);

      // Detectar automáticamente el delimitador
      String delimiter = detectDelimiter(content);
      print('Delimitador detectado: "$delimiter"');

      final data = rows.map((r) => r.split(delimiter)).toList();

      // Obtiene los índices de las columnas
      final headers = data[0];
      print('Encabezados: $headers');

      // Buscar columnas con diferentes posibles nombres
      int marcaIndex = findColumnIndex(headers, ['marca', 'brand']);
      int placaIndex = findColumnIndex(headers, [
        'placa',
        'license plate',
        'licenseplate',
      ]);
      int conductorIndex = findColumnIndex(headers, [
        'conductor designado',
        'driver',
        'conductor',
      ]);
      int modeloIndex = findColumnIndex(headers, ['modelo', 'model']);
      int kilometrajeIndex = findColumnIndex(headers, [
        'kilometraje',
        'mileage',
        'km',
      ]);
      int yearIndex = findColumnIndex(headers, ['year', 'año', 'modelo año']);

      if (marcaIndex == -1 || placaIndex == -1) {
        throw Exception(
          'No se encontraron las columnas requeridas (marca/brand, placa/license plate)',
        );
      }

      // Lista para almacenar los vehículos a insertar
      List<VehiclesCompanion> vehicles = [];

      // Obtener todos los conductores para buscar sus IDs
      final drivers = await db.select(db.drivers).get();
      if (drivers.isEmpty) {
        print(
          'Advertencia: No hay conductores en la base de datos para asignar a los vehículos',
        );
      }

      for (var i = 1; i < data.length; i++) {
        if (data[i].isNotEmpty &&
            data[i].length > marcaIndex &&
            data[i].length > placaIndex) {
          // Buscar el ID del conductor por nombre completo
          int? driverId;

          if (conductorIndex != -1 &&
              data[i].length > conductorIndex &&
              !data[i][conductorIndex].trim().isEmpty) {
            String conductorNombre = data[i][conductorIndex].trim();
            driverId = findDriverId(drivers, conductorNombre);

            // Si no encontramos un conductor, mostramos mensaje pero continuamos
            if (driverId == null) {
              print(
                'No se encontró el conductor: "$conductorNombre" - El vehículo se creará sin conductor asignado',
              );
            }
          }

          // Parsear el año y kilometraje
          int? year;
          int? mileage;

          if (yearIndex != -1 &&
              data[i].length > yearIndex &&
              !data[i][yearIndex].trim().isEmpty) {
            try {
              year = int.parse(data[i][yearIndex].trim());
            } catch (e) {
              print(
                'Error al parsear el año para el vehículo ${data[i][placaIndex]}: ${e}',
              );
            }
          }

          if (kilometrajeIndex != -1 &&
              data[i].length > kilometrajeIndex &&
              !data[i][kilometrajeIndex].trim().isEmpty) {
            try {
              // Eliminar caracteres no numéricos
              mileage = int.parse(
                data[i][kilometrajeIndex].trim().replaceAll(
                  RegExp(r'[^\d]'),
                  '',
                ),
              );
            } catch (e) {
              print(
                'Error al parsear el kilometraje para el vehículo ${data[i][placaIndex]}: ${e}',
              );
            }
          }

          // Crear el vehículo
          final vehicle = VehiclesCompanion.insert(
            licensePlate: data[i][placaIndex].trim(),
            brand: data[i][marcaIndex].trim(),
            model:
                modeloIndex != -1 &&
                        data[i].length > modeloIndex &&
                        !data[i][modeloIndex].trim().isEmpty
                    ? Value(data[i][modeloIndex].trim())
                    : const Value.absent(),
            year: year != null ? Value(year) : const Value.absent(),
            mileage: mileage != null ? Value(mileage) : const Value.absent(),
            idDriver: Value(null),
          );

          vehicles.add(vehicle);
        }
      }

      // Verificar si hay vehículos para importar
      if (vehicles.isEmpty) {
        throw Exception('No se encontraron vehículos válidos para importar');
      }

      // Usar una transacción para insertar los datos en lote
      await db.transaction(() async {
        for (final vehicle in vehicles) {
          await db.into(db.vehicles).insert(vehicle);
        }
      });

      print('${vehicles.length} vehículos importados exitosamente');
    } catch (e) {
      print('Error al importar vehículos: $e');
      rethrow; // Propaga el error para manejo en nivel superior
    }
  }

  // Método auxiliar para detectar el delimitador del CSV
  static String detectDelimiter(String content) {
    // Contar las ocurrencias de posibles delimitadores en la primera línea
    int commaCount = ','.allMatches(content.split('\n')[0]).length;
    int semicolonCount = ';'.allMatches(content.split('\n')[0]).length;
    int tabCount = '\t'.allMatches(content.split('\n')[0]).length;

    // Elegir el delimitador con más ocurrencias
    if (semicolonCount >= commaCount && semicolonCount >= tabCount) {
      return ';';
    } else if (commaCount >= semicolonCount && commaCount >= tabCount) {
      return ',';
    } else {
      return '\t';
    }
  }

  // Método auxiliar para encontrar índices de columnas con varios posibles nombres
  static int findColumnIndex(List<String> headers, List<String> possibleNames) {
    for (var name in possibleNames) {
      int index = headers.indexWhere(
        (header) => header.trim().toLowerCase() == name.toLowerCase(),
      );
      if (index != -1) return index;
    }
    return -1;
  }

  // Método para encontrar conductor por nombre
  static int? findDriverId(List<Driver> drivers, String fullName) {
    // Normalizar el nombre completo
    String normalizedName = fullName.toLowerCase().trim();
    List<String> nameParts = normalizedName.split(' ');

    // Estrategia 1: Buscar coincidencia exacta
    for (var driver in drivers) {
      String driverFullName =
          '${driver.firstName} ${driver.lastName}'.toLowerCase();
      if (driverFullName == normalizedName) {
        return driver.idDriver;
      }
    }

    // Estrategia 2: Buscar por partes del nombre
    if (nameParts.length > 0) {
      for (var driver in drivers) {
        String firstName = driver.firstName.toLowerCase();
        String lastName = driver.lastName.toLowerCase();

        // Verificar si el primer nombre coincide con cualquier parte
        bool nameMatch = nameParts.any(
          (part) => firstName.contains(part) || lastName.contains(part),
        );

        if (nameMatch) {
          return driver.idDriver;
        }
      }
    }

    return null; // No se encontró coincidencia
  }
}
