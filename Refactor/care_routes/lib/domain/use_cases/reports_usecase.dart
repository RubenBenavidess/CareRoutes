// lib/domain/use_cases/reports_usecase.dart

import 'package:logging/logging.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/maintenance_dao.dart';
import '../../data/local_repository/daos/maintenance_details_dao.dart';
import '../../data/local_repository/daos/vehicles_dao.dart';
import '../../data/local_repository/mappers.dart';

class ReportsUseCase {
  static final _logger = Logger('ReportsUseCase');
  
  final MaintenancesDao _maintenancesDao;
  final MaintenanceDetailsDao _maintenanceDetailsDao;
  final VehiclesDao _vehiclesDao;

  ReportsUseCase({
    required MaintenancesDao maintenancesDao,
    required MaintenanceDetailsDao maintenanceDetailsDao,
    required VehiclesDao vehiclesDao,
  }) : _maintenancesDao = maintenancesDao,
       _maintenanceDetailsDao = maintenanceDetailsDao,
       _vehiclesDao = vehiclesDao;

  /// Obtiene los datos para generar reportes con filtros aplicados
  Future<ReportDataResult> getReportData({
    List<int>? vehicleIds,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _logger.info('Obteniendo datos para reporte con filtros aplicados');
    
    try {
      // Obtener todos los mantenimientos activos
      final allMaintenances = await _maintenancesDao.getAllActiveMaintenances();
      
      // Aplicar filtros
      var filteredMaintenances = allMaintenances.where((maintenance) {
        bool includeByVehicle = vehicleIds == null || vehicleIds.isEmpty || 
                               vehicleIds.contains(maintenance.idVehicle);
        
        bool includeByDate = true;
        if (startDate != null || endDate != null) {
          final maintenanceDate = maintenance.maintenanceDate;
          
          if (startDate != null && maintenanceDate.isBefore(startDate)) {
            includeByDate = false;
          }
          
          if (endDate != null && maintenanceDate.isAfter(endDate.add(const Duration(days: 1)))) {
            includeByDate = false;
          }
        }
        
        return includeByVehicle && includeByDate;
      }).toList();

      // Agrupar por vehículo y obtener datos completos
      final vehicleReports = <VehicleReportData>[];
      final vehicleMaintenancesMap = <int, List<MaintenanceReportData>>{};

      // Agrupar mantenimientos por vehículo
      for (final maintenance in filteredMaintenances) {
        final vehicleId = maintenance.idVehicle;
        if (!vehicleMaintenancesMap.containsKey(vehicleId)) {
          vehicleMaintenancesMap[vehicleId] = [];
        }

        // Obtener detalles del mantenimiento
        final allDetails = await _maintenanceDetailsDao.getAllActiveDetails();
        final maintenanceDetails = allDetails
            .where((detail) => detail.idMaintenance == maintenance.idMaintenance)
            .map((detail) => detail.toDomain())
            .toList();

        vehicleMaintenancesMap[vehicleId]!.add(MaintenanceReportData(
          maintenance: maintenance.toDomain(),
          details: maintenanceDetails,
        ));
      }

      // Crear datos de reporte por vehículo
      for (final entry in vehicleMaintenancesMap.entries) {
        final vehicleId = entry.key;
        final maintenances = entry.value;

        // Obtener información del vehículo
        final vehicle = await _vehiclesDao.getVehicleById(vehicleId);
        if (vehicle == null) continue;

        // Calcular totales
        double totalCost = 0;
        int totalServices = 0;
        
        for (final maintenance in maintenances) {
          for (final detail in maintenance.details) {
            totalCost += detail.cost;
            totalServices++;
          }
        }

        vehicleReports.add(VehicleReportData(
          vehicle: vehicle.toDomain(),
          maintenances: maintenances,
          totalCost: totalCost,
          totalServices: totalServices,
          reportPeriod: ReportPeriod(
            startDate: startDate,
            endDate: endDate,
            vehicleIds: vehicleIds,
          ),
        ));
      }

      _logger.info('Datos de reporte obtenidos: ${vehicleReports.length} vehículos');
      
      return ReportDataResult.success(
        vehicleReports: vehicleReports,
        totalVehicles: vehicleReports.length,
        message: 'Datos obtenidos exitosamente',
      );

    } catch (e) {
      _logger.severe('Error obteniendo datos para reporte: $e');
      return ReportDataResult.failure(
        error: 'Error al obtener los datos: $e',
      );
    }
  }

  /// Genera un reporte en PDF
  Future<ReportGenerationResult> generatePdfReport(List<VehicleReportData> vehicleReports) async {
    _logger.info('Generando reporte PDF');
    
    try {
      final pdf = pw.Document();

      for (final vehicleReport in vehicleReports) {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return [
                // Título del reporte
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'REPORTE DE MANTENIMIENTOS',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Información del vehículo
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'INFORMACIÓN DEL VEHÍCULO',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text('Placa: ${vehicleReport.vehicle.licensePlate}'),
                      pw.Text('Marca: ${vehicleReport.vehicle.brand}'),
                      pw.Text('Modelo: ${vehicleReport.vehicle.model ?? 'N/A'}'),
                      if (vehicleReport.vehicle.year != null)
                        pw.Text('Año: ${vehicleReport.vehicle.year}'),
                      pw.Text('Kilometraje actual: ${vehicleReport.vehicle.mileage} km'),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Período del reporte
                if (vehicleReport.reportPeriod.startDate != null || vehicleReport.reportPeriod.endDate != null) ...[
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'PERÍODO DEL REPORTE',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        if (vehicleReport.reportPeriod.startDate != null)
                          pw.Text('Desde: ${DateFormat('dd/MM/yyyy').format(vehicleReport.reportPeriod.startDate!)}'),
                        if (vehicleReport.reportPeriod.endDate != null)
                          pw.Text('Hasta: ${DateFormat('dd/MM/yyyy').format(vehicleReport.reportPeriod.endDate!)}'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                ],
                
                // Resumen
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            '${vehicleReport.maintenances.length}',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800,
                            ),
                          ),
                          pw.Text('Mantenimientos'),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            '${vehicleReport.totalServices}',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue800,
                            ),
                          ),
                          pw.Text('Servicios'),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            '\$${vehicleReport.totalCost.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.orange800,
                            ),
                          ),
                          pw.Text('Costo Total'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 30),
                
                // Lista de mantenimientos
                pw.Text(
                  'DETALLE DE MANTENIMIENTOS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                
                pw.SizedBox(height: 16),
                
                ...vehicleReport.maintenances.map((maintenanceData) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Header del mantenimiento
                        pw.Container(
                          padding: const pw.EdgeInsets.only(bottom: 12),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(color: PdfColors.grey300),
                            ),
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Mantenimiento #${maintenanceData.maintenance.id}',
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    DateFormat('dd/MM/yyyy').format(maintenanceData.maintenance.maintenanceDate),
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              pw.Text(
                                '${maintenanceData.maintenance.vehicleMileage} km',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        pw.SizedBox(height: 12),
                        
                        // Observaciones del mantenimiento
                        if (maintenanceData.maintenance.details != null) ...[
                          pw.Text(
                            'Observaciones:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(maintenanceData.maintenance.details!),
                          pw.SizedBox(height: 12),
                        ],
                        
                        // Servicios realizados
                        if (maintenanceData.details.isNotEmpty) ...[
                          pw.Text(
                            'Servicios realizados:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          
                          // Tabla de servicios
                          pw.Table(
                            border: pw.TableBorder.all(color: PdfColors.grey300),
                            children: [
                              // Header de la tabla
                              pw.TableRow(
                                decoration: const pw.BoxDecoration(
                                  color: PdfColors.grey100,
                                ),
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      'Descripción',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      'Costo',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Filas de servicios
                              ...maintenanceData.details.map((detail) {
                                return pw.TableRow(
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(8),
                                      child: pw.Text(detail.description),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(8),
                                      child: pw.Text(
                                        '\$${detail.cost.toStringAsFixed(2)}',
                                        textAlign: pw.TextAlign.right,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              
                              // Total del mantenimiento
                              pw.TableRow(
                                decoration: const pw.BoxDecoration(
                                  color: PdfColors.grey50,
                                ),
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      'TOTAL MANTENIMIENTO',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      '\$${maintenanceData.details.fold(0.0, (sum, detail) => sum + detail.cost).toStringAsFixed(2)}',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          pw.Text('No se registraron servicios específicos'),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ];
            },
          ),
        );
      }

      // Guardar el archivo
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'reporte_mantenimientos_$timestamp.pdf';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(await pdf.save());

      _logger.info('Reporte PDF generado: ${file.path}');
      
      return ReportGenerationResult.success(
        filePath: file.path,
        fileName: fileName,
        message: 'Reporte PDF generado exitosamente',
      );

    } catch (e) {
      _logger.severe('Error generando reporte PDF: $e');
      return ReportGenerationResult.failure(
        error: 'Error al generar el reporte PDF: $e',
      );
    }
  }

  /// Genera un reporte en Excel
Future<ReportGenerationResult> generateExcelReport(List<VehicleReportData> vehicleReports) async {
  _logger.info('Generando reporte Excel');
  
  try {
    final excel = Excel.createExcel();

    // Eliminar la hoja por defecto
    excel.delete('Sheet1');

    for (final vehicleReport in vehicleReports) {
      final sheetName = vehicleReport.vehicle.licensePlate.replaceAll(RegExp(r'[^\w\s-]'), '');
      final sheet = excel[sheetName];

      int currentRow = 0;

      // Título
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue('REPORTE DE MANTENIMIENTOS')
        ..cellStyle = CellStyle(
          fontSize: 16,
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
        );
      currentRow += 2;

      // Información del vehículo
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue('INFORMACIÓN DEL VEHÍCULO')
        ..cellStyle = CellStyle(fontSize: 14, bold: true);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Placa:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue(vehicleReport.vehicle.licensePlate);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Marca:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue(vehicleReport.vehicle.brand);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Modelo:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue(vehicleReport.vehicle.model ?? 'N/A');
      currentRow++;

      if (vehicleReport.vehicle.year != null) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Año:');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = IntCellValue(vehicleReport.vehicle.year!);
        currentRow++;
      }

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Kilometraje actual:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue('${vehicleReport.vehicle.mileage} km');
      currentRow += 2;

      // Resumen
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue('RESUMEN')
        ..cellStyle = CellStyle(fontSize: 14, bold: true);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Total Mantenimientos:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = IntCellValue(vehicleReport.maintenances.length);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Total Servicios:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = IntCellValue(vehicleReport.totalServices);
      currentRow++;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = TextCellValue('Costo Total:');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue('\$${vehicleReport.totalCost.toStringAsFixed(2)}');
      currentRow += 2;

      // Headers de la tabla de mantenimientos
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue('DETALLE DE MANTENIMIENTOS')
        ..cellStyle = CellStyle(fontSize: 14, bold: true);
      currentRow += 2;

      // Headers de columnas
      final headers = ['Fecha', 'ID', 'Kilometraje', 'Observaciones', 'Servicio', 'Costo'];
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow))
          ..value = TextCellValue(headers[i])
          ..cellStyle = CellStyle(
            bold: true,
            backgroundColorHex: ExcelColor.fromHexString('FFE0E0E0'),
          );
      }
      currentRow++;

      // Datos de mantenimientos
      for (final maintenanceData in vehicleReport.maintenances) {
        if (maintenanceData.details.isNotEmpty) {
          // Si hay detalles, crear una fila por cada detalle
          for (int i = 0; i < maintenanceData.details.length; i++) {
            final detail = maintenanceData.details[i];
            
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = 
              TextCellValue(DateFormat('dd/MM/yyyy').format(maintenanceData.maintenance.maintenanceDate));
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = 
              IntCellValue(maintenanceData.maintenance.id);
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: currentRow)).value = 
              TextCellValue('${maintenanceData.maintenance.vehicleMileage} km');
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRow)).value = 
              TextCellValue(i == 0 ? (maintenanceData.maintenance.details ?? '') : '');
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRow)).value = 
              TextCellValue(detail.description);
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRow)).value = 
              TextCellValue('\$${detail.cost.toStringAsFixed(2)}');
            
            currentRow++;
          }
        } else {
          // Si no hay detalles, crear una fila solo con los datos del mantenimiento
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = 
            TextCellValue(DateFormat('dd/MM/yyyy').format(maintenanceData.maintenance.maintenanceDate));
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = 
            IntCellValue(maintenanceData.maintenance.id);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: currentRow)).value = 
            TextCellValue('${maintenanceData.maintenance.vehicleMileage} km');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRow)).value = 
            TextCellValue(maintenanceData.maintenance.details ?? '');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRow)).value = 
            TextCellValue('Sin detalles específicos');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRow)).value = 
            TextCellValue('\$0.00');
          
          currentRow++;
        }
      }
    }

    // Guardar el archivo
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'reporte_mantenimientos_$timestamp.xlsx';
    final file = File('${directory.path}/$fileName');
    
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    _logger.info('Reporte Excel generado: ${file.path}');
    
    return ReportGenerationResult.success(
      filePath: file.path,
      fileName: fileName,
      message: 'Reporte Excel generado exitosamente',
    );

  } catch (e) {
    _logger.severe('Error generando reporte Excel: $e');
    return ReportGenerationResult.failure(
      error: 'Error al generar el reporte Excel: $e',
    );
  }
}

  /// Obtiene la lista de vehículos activos para filtros
  Future<List<Vehicle>> getAllActiveVehicles() async {
    try {
      final vehicleDataList = await _vehiclesDao.getAllActive();
      return vehicleDataList.map((v) => v.toDomain()).toList();
    } catch (e) {
      _logger.severe('Error obteniendo vehículos activos: $e');
      return [];
    }
  }
}

// Clases de resultado y modelos

class ReportDataResult {
  final bool isSuccess;
  final List<VehicleReportData> vehicleReports;
  final int totalVehicles;
  final String message;
  final String? error;

  const ReportDataResult._({
    required this.isSuccess,
    required this.vehicleReports,
    required this.totalVehicles,
    required this.message,
    this.error,
  });

  factory ReportDataResult.success({
    required List<VehicleReportData> vehicleReports,
    required int totalVehicles,
    required String message,
  }) {
    return ReportDataResult._(
      isSuccess: true,
      vehicleReports: vehicleReports,
      totalVehicles: totalVehicles,
      message: message,
    );
  }

  factory ReportDataResult.failure({
    required String error,
  }) {
    return ReportDataResult._(
      isSuccess: false,
      vehicleReports: [],
      totalVehicles: 0,
      message: 'Error obteniendo datos',
      error: error,
    );
  }
}

class ReportGenerationResult {
  final bool isSuccess;
  final String? filePath;
  final String? fileName;
  final String message;
  final String? error;

  const ReportGenerationResult._({
    required this.isSuccess,
    this.filePath,
    this.fileName,
    required this.message,
    this.error,
  });

  factory ReportGenerationResult.success({
    required String filePath,
    required String fileName,
    required String message,
  }) {
    return ReportGenerationResult._(
      isSuccess: true,
      filePath: filePath,
      fileName: fileName,
      message: message,
    );
  }

  factory ReportGenerationResult.failure({
    required String error,
  }) {
    return ReportGenerationResult._(
      isSuccess: false,
      message: 'Error generando reporte',
      error: error,
    );
  }
}

class VehicleReportData {
  final Vehicle vehicle;
  final List<MaintenanceReportData> maintenances;
  final double totalCost;
  final int totalServices;
  final ReportPeriod reportPeriod;

  const VehicleReportData({
    required this.vehicle,
    required this.maintenances,
    required this.totalCost,
    required this.totalServices,
    required this.reportPeriod,
  });
}

class MaintenanceReportData {
  final Maintenance maintenance;
  final List<MaintenanceDetail> details;

  const MaintenanceReportData({
    required this.maintenance,
    required this.details,
  });
}

class ReportPeriod {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int>? vehicleIds;

  const ReportPeriod({
    this.startDate,
    this.endDate,
    this.vehicleIds,
  });
}