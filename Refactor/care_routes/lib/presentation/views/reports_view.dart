// lib/presentation/views/reports_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../../domain/entities/domain_entities.dart';
import '../../domain/use_cases/reports_usecase.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsViewModel>().loadAvailableVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generar Reportes',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0973AD)),
        actions: [
          Consumer<ReportsViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
                onPressed: viewModel.isLoadingData ? null : () {
                  viewModel.resetToInitial();
                  viewModel.loadAvailableVehicles();
                },
                tooltip: 'Actualizar',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF0973AD)),
            onPressed: () => _showHelpDialog(),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: Consumer<ReportsViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Panel de filtros
              _buildFiltersPanel(viewModel),
              
              // Estados y mensajes
              _buildStatusMessages(viewModel),
              
              // Contenido principal
              Expanded(
                child: _buildMainContent(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersPanel(ReportsViewModel viewModel) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.filter_list, color: Color(0xFF0973AD), size: 20),
              SizedBox(width: 8),
              Text(
                'Filtros del Reporte',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filtros de fecha
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: viewModel.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      viewModel.setStartDate(date);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha Desde',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      viewModel.startDate != null 
                          ? DateFormat('dd/MM/yyyy').format(viewModel.startDate!) 
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: viewModel.startDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: viewModel.endDate ?? DateTime.now(),
                      firstDate: viewModel.startDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      viewModel.setEndDate(date);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha Hasta',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      viewModel.endDate != null 
                          ? DateFormat('dd/MM/yyyy').format(viewModel.endDate!) 
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: viewModel.endDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Selector de vehículos
          InkWell(
            onTap: () => _showVehicleSelectionDialog(viewModel),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Vehículos',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              child: Text(
                viewModel.hasSelectedVehicles
                    ? '${viewModel.selectedVehicles.length} vehículo(s) seleccionado(s)'
                    : 'Todos los vehículos',
                style: TextStyle(
                  color: viewModel.hasSelectedVehicles ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botones de acción para filtros
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: viewModel.isLoadingData ? null : () => viewModel.loadReportData(),
                  icon: viewModel.isLoadingData 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search, color: Colors.white),
                  label: Text(
                    viewModel.isLoadingData ? 'Cargando...' : 'Generar Vista Previa',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0973AD),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: viewModel.hasFilters ? () => viewModel.clearFilters() : null,
                icon: const Icon(Icons.clear, color: Colors.white),
                label: const Text('Limpiar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
          
          // Chips de filtros activos
          if (viewModel.hasFilters) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (viewModel.startDate != null)
                  Chip(
                    label: Text('Desde: ${DateFormat('dd/MM/yyyy').format(viewModel.startDate!)}'),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => viewModel.setStartDate(null),
                    backgroundColor: Colors.blue.shade100,
                  ),
                if (viewModel.endDate != null)
                  Chip(
                    label: Text('Hasta: ${DateFormat('dd/MM/yyyy').format(viewModel.endDate!)}'),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => viewModel.setEndDate(null),
                    backgroundColor: Colors.blue.shade100,
                  ),
                if (viewModel.hasSelectedVehicles)
                  Chip(
                    label: Text('${viewModel.selectedVehicles.length} vehículo(s)'),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => viewModel.setSelectedVehicles([]),
                    backgroundColor: Colors.green.shade100,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusMessages(ReportsViewModel viewModel) {
    if (viewModel.isGeneratingReport && viewModel.successMessage != null) {
      return Container(
        color: Colors.orange.shade50,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                viewModel.successMessage!,
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.isReportGenerated && viewModel.successMessage != null) {
      return Container(
        color: Colors.green.shade50,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                viewModel.successMessage!,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => viewModel.clearSuccessMessage(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }

    if (viewModel.hasError && viewModel.errorMessage != null) {
      return Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                viewModel.errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => viewModel.resetError(),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMainContent(ReportsViewModel viewModel) {
    if (viewModel.isShowingPreview) {
      return _buildReportPreview(viewModel);
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${viewModel.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.resetError(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (viewModel.hasReportData) {
      return _buildDataSummary(viewModel);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Configura los filtros y genera una vista previa\npara crear tu reporte de mantenimientos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Column(
              children: [
                Icon(Icons.info, color: Color(0xFF0973AD)),
                SizedBox(height: 8),
                Text(
                  '1. Selecciona las fechas y vehículos\n2. Haz clic en "Generar Vista Previa"\n3. Exporta en PDF o Excel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0973AD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSummary(ReportsViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen general
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, color: Color(0xFF0973AD), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Resumen del Reporte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Vehículos',
                        '${viewModel.totalVehiclesInReport}',
                        Icons.directions_car,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Mantenimientos',
                        '${viewModel.totalMaintenancesInReport}',
                        Icons.build,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Costo Total',
                        '\$${viewModel.totalCostInReport.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botones de exportación
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.file_download, color: Color(0xFF0973AD), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Exportar Reporte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: viewModel.canGenerateReport && !viewModel.isGeneratingReport
                            ? () => viewModel.generatePdfReport()
                            : null,
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: const Text('Generar PDF', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: viewModel.canGenerateReport && !viewModel.isGeneratingReport
                            ? () => viewModel.generateExcelReport()
                            : null,
                        icon: const Icon(Icons.table_chart, color: Colors.white),
                        label: const Text('Generar Excel', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => viewModel.showReportPreview(),
                    icon: const Icon(Icons.preview, color: Colors.white),
                    label: const Text('Vista Previa Detallada', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0973AD),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista resumida de vehículos
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.list, color: Color(0xFF0973AD), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Vehículos en el Reporte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...viewModel.reportData.map((vehicleData) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.directions_car, color: Color(0xFF0973AD)),
                      title: Text(
                        '${vehicleData.vehicle.licensePlate} - ${vehicleData.vehicle.brand} ${vehicleData.vehicle.model ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${vehicleData.maintenances.length} mantenimientos • \$${vehicleData.totalCost.toStringAsFixed(2)}',
                      ),
                      trailing: Chip(
                        label: Text('${vehicleData.totalServices} servicios'),
                        backgroundColor: Colors.blue.shade100,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildReportPreview(ReportsViewModel viewModel) {
    return Column(
      children: [
        // Header de vista previa
        Container(
          color: const Color(0xFF0973AD),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.preview, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Vista Previa del Reporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => viewModel.closeReportPreview(),
              ),
            ],
          ),
        ),
        
        // Contenido de vista previa
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información general del reporte
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REPORTE DE MANTENIMIENTOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (viewModel.startDate != null || viewModel.endDate != null) ...[
                        const Text(
                          'Período:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${viewModel.startDate != null ? DateFormat('dd/MM/yyyy').format(viewModel.startDate!) : 'Desde el inicio'} - ${viewModel.endDate != null ? DateFormat('dd/MM/yyyy').format(viewModel.endDate!) : 'Hasta hoy'}',
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Datos por vehículo
                ...viewModel.reportData.map((vehicleData) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header del vehículo
                        Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0973AD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.directions_car,
                                  color: Color(0xFF0973AD),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vehicleData.vehicle.licensePlate,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${vehicleData.vehicle.brand} ${vehicleData.vehicle.model ?? ''}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Información del vehículo
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem('Mantenimientos', '${vehicleData.maintenances.length}'),
                            ),
                            Expanded(
                              child: _buildInfoItem('Servicios', '${vehicleData.totalServices}'),
                            ),
                            Expanded(
                              child: _buildInfoItem('Costo Total', '\$${vehicleData.totalCost.toStringAsFixed(2)}'),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Lista de mantenimientos
                        const Text(
                          'Mantenimientos:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        ...vehicleData.maintenances.map((maintenanceData) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ExpansionTile(
                              leading: const Icon(Icons.build, color: Color(0xFF0973AD)),
                              title: Text(
                                'Mantenimiento #${maintenanceData.maintenance.id}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                '${DateFormat('dd/MM/yyyy').format(maintenanceData.maintenance.maintenanceDate)} • ${maintenanceData.maintenance.vehicleMileage} km',
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (maintenanceData.maintenance.details != null) ...[
                                        const Text(
                                          'Observaciones:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(maintenanceData.maintenance.details!),
                                        const SizedBox(height: 12),
                                      ],
                                      
                                      if (maintenanceData.details.isNotEmpty) ...[
                                        const Text(
                                          'Servicios realizados:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        
                                        // Tabla de servicios
                                        Table(
                                          border: TableBorder.all(color: Colors.grey.shade300),
                                          children: [
                                            // Header
                                            TableRow(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                              ),
                                              children: [
                                                _buildTableCell('Descripción', isHeader: true),
                                                _buildTableCell('Costo', isHeader: true),
                                              ],
                                            ),
                                            
                                            // Datos
                                            ...maintenanceData.details.map((detail) {
                                              return TableRow(
                                                children: [
                                                  _buildTableCell(detail.description),
                                                  _buildTableCell('\$${detail.cost.toStringAsFixed(2)}'),
                                                ],
                                              );
                                            }).toList(),
                                            
                                            // Total
                                            TableRow(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                              ),
                                              children: [
                                                _buildTableCell('TOTAL', isHeader: true),
                                                _buildTableCell(
                                                  '\$${maintenanceData.details.fold(0.0, (sum, detail) => sum + detail.cost).toStringAsFixed(2)}',
                                                  isHeader: true,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        const Text('No se registraron servicios específicos'),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        
        // Botones de exportación en vista previa
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: viewModel.canGenerateReport && !viewModel.isGeneratingReport
                      ? () => viewModel.generatePdfReport()
                      : null,
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text('Exportar PDF', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: viewModel.canGenerateReport && !viewModel.isGeneratingReport
                      ? () => viewModel.generateExcelReport()
                      : null,
                  icon: const Icon(Icons.table_chart, color: Colors.white),
                  label: const Text('Exportar Excel', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showVehicleSelectionDialog(ReportsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => _VehicleSelectionDialog(viewModel: viewModel),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Reportes'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cómo generar reportes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Configura los filtros de fecha y vehículos según tus necesidades'),
              SizedBox(height: 4),
              Text('2. Haz clic en "Generar Vista Previa" para cargar los datos'),
              SizedBox(height: 4),
              Text('3. Revisa el resumen y los datos mostrados'),
              SizedBox(height: 4),
              Text('4. Exporta el reporte en formato PDF o Excel'),
              SizedBox(height: 16),
              Text(
                'Formatos disponibles:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• PDF: Reporte detallado con formato profesional'),
              SizedBox(height: 4),
              Text('• Excel: Datos en tablas para análisis adicional'),
              SizedBox(height: 16),
              Text(
                'Los archivos se guardan en la carpeta de documentos de la aplicación.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// Diálogo de selección de vehículos
class _VehicleSelectionDialog extends StatefulWidget {
  final ReportsViewModel viewModel;

  const _VehicleSelectionDialog({required this.viewModel});

  @override
  _VehicleSelectionDialogState createState() => _VehicleSelectionDialogState();
}

class _VehicleSelectionDialogState extends State<_VehicleSelectionDialog> {
  List<Vehicle> _selectedVehicles = [];
  final TextEditingController _searchController = TextEditingController();
  List<Vehicle> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _selectedVehicles = [...widget.viewModel.selectedVehicles];
    _filteredVehicles = [...widget.viewModel.availableVehicles];
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredVehicles = [...widget.viewModel.availableVehicles];
      } else {
        _filteredVehicles = widget.viewModel.availableVehicles.where((vehicle) {
          final searchTerm = _searchController.text.toLowerCase();
          return vehicle.licensePlate.toLowerCase().contains(searchTerm) ||
                 vehicle.brand.toLowerCase().contains(searchTerm) ||
                 (vehicle.model?.toLowerCase().contains(searchTerm) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Vehículos'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por placa, marca o modelo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botones de selección rápida
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedVehicles = [..._filteredVehicles];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0973AD),
                    ),
                    child: const Text('Todos', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedVehicles.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                    ),
                    child: const Text('Ninguno', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lista de vehículos
            Expanded(
              child: widget.viewModel.vehiclesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredVehicles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(
                                _searchController.text.isNotEmpty
                                    ? 'No se encontraron vehículos'
                                    : 'No hay vehículos disponibles',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = _filteredVehicles[index];
                            final isSelected = _selectedVehicles.any((v) => v.id == vehicle.id);
                            
                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedVehicles.add(vehicle);
                                  } else {
                                    _selectedVehicles.removeWhere((v) => v.id == vehicle.id);
                                  }
                                });
                              },
                              secondary: const Icon(Icons.directions_car, color: Color(0xFF0973AD)),
                              title: Text(
                                '${vehicle.licensePlate} - ${vehicle.brand}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(vehicle.model ?? 'Sin modelo'),
                            );
                          },
                        ),
            ),
            
            // Contador de seleccionados
            if (_selectedVehicles.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_selectedVehicles.length} vehículo(s) seleccionado(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0973AD),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.viewModel.setSelectedVehicles(_selectedVehicles);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0973AD),
          ),
          child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}