// lib/presentation/views/maintenance_crud_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/maintenance_viewmodel.dart';
import '../../domain/entities/domain_entities.dart';
import '../../domain/use_cases/maintenance_usecase.dart';
import 'package:intl/intl.dart';

class MaintenanceCrudView extends StatefulWidget {
  const MaintenanceCrudView({super.key});

  @override
  State<MaintenanceCrudView> createState() => _MaintenanceCrudViewState();
}

class _MaintenanceCrudViewState extends State<MaintenanceCrudView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final viewModel = context.read<MaintenanceViewModel>();
    viewModel.loadAllMaintenances();
    viewModel.loadAvailableVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Mantenimientos',
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
          Consumer<MaintenanceViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
                onPressed: viewModel.isLoading ? null : () => viewModel.refresh(),
                tooltip: 'Actualizar',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF0973AD)),
            onPressed: () => _showCreateMaintenanceDialog(),
            tooltip: 'Nuevo Mantenimiento',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Buscar por placa de vehículo o ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<MaintenanceViewModel>().clearSearch();
                                context.read<MaintenanceViewModel>().loadAllMaintenances();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                    onSubmitted: (value) => _performSearch(value.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _performSearch(_searchController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0973AD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Buscar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // Información de resultados y filtros activos
          Consumer<MaintenanceViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.hasSearchQuery) {
                return Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Búsqueda: ${viewModel.searchQuery} (${viewModel.totalFound} resultados)',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          viewModel.clearResults();
                          viewModel.loadAllMaintenances();
                        },
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Estados de operaciones
          Consumer<MaintenanceViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isOperating) {
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
                          _getOperationMessage(viewModel.operationState),
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

              if (viewModel.operationState == MaintenanceOperationState.success && 
                  viewModel.operationMessage != null) {
                return Container(
                  color: Colors.green.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          viewModel.operationMessage!,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => viewModel.resetOperationState(),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.operationState == MaintenanceOperationState.error && 
                  viewModel.operationError != null) {
                return Container(
                  color: Colors.red.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          viewModel.operationError!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => viewModel.resetOperationState(),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          // Lista de mantenimientos
          Expanded(
            child: Consumer<MaintenanceViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${viewModel.errorMessage}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.resetErrorState(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0973AD),
                          ),
                          child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.isEmpty || !viewModel.hasMaintenances) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          viewModel.hasSearchQuery
                              ? Icons.search_off
                              : Icons.build_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.hasSearchQuery
                              ? 'No se encontraron mantenimientos con los criterios especificados'
                              : 'No hay mantenimientos registrados',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showCreateMaintenanceDialog(),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Crear Primer Mantenimiento', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0973AD),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.maintenances.length,
                    itemBuilder: (context, index) {
                      final maintenance = viewModel.maintenances[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _showMaintenanceDetails(maintenance),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Icono del mantenimiento
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0973AD).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.build,
                                    color: Color(0xFF0973AD),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Información del mantenimiento
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              maintenance.vehicleLicensePlate,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'ID: ${maintenance.maintenance.id}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${maintenance.vehicleBrand} ${maintenance.vehicleModel}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(maintenance.maintenance.maintenanceDate),
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.speed, size: 16, color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${maintenance.maintenance.vehicleMileage} km',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (maintenance.maintenance.details != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          maintenance.maintenance.details!.length > 50
                                              ? '${maintenance.maintenance.details!.substring(0, 50)}...'
                                              : maintenance.maintenance.details!,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Botones de acción
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF0973AD)),
                                      onPressed: () => _showEditMaintenanceDialog(maintenance.maintenance),
                                      tooltip: 'Editar',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _showDeleteConfirmation(maintenance.maintenance),
                                      tooltip: 'Eliminar',
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateMaintenanceDialog(),
        backgroundColor: const Color(0xFF0973AD),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Nuevo Mantenimiento',
      ),
    );
  }

  String _getOperationMessage(MaintenanceOperationState state) {
    switch (state) {
      case MaintenanceOperationState.creating:
        return 'Creando mantenimiento...';
      case MaintenanceOperationState.updating:
        return 'Actualizando mantenimiento...';
      case MaintenanceOperationState.deleting:
        return 'Eliminando mantenimiento...';
      default:
        return 'Procesando...';
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    final viewModel = context.read<MaintenanceViewModel>();
    
    // Intentar buscar por ID si es un número
    final id = int.tryParse(query);
    if (id != null) {
      viewModel.searchMaintenanceById(id);
    } else {
      // Buscar por placa
      viewModel.searchMaintenancesByPlate(query);
    }
  }

  void _showMaintenanceDetails(MaintenanceWithVehicle maintenance) {
    // Cargar los detalles antes de mostrar el diálogo
    final viewModel = context.read<MaintenanceViewModel>();
    viewModel.selectMaintenance(maintenance); // Esto carga los detalles automáticamente
    
    showDialog(
      context: context,
      builder: (context) => _MaintenanceDetailsDialog(maintenance: maintenance),
    );
  }

  void _showCreateMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (context) => const _MaintenanceFormDialog(),
    );
  }

  void _showEditMaintenanceDialog(Maintenance maintenance) {
    final viewModel = context.read<MaintenanceViewModel>();
    viewModel.startEditingMaintenance(maintenance);
    
    showDialog(
      context: context,
      builder: (context) => _MaintenanceFormDialog(maintenance: maintenance),
    );
  }

  void _showDeleteConfirmation(Maintenance maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Está seguro de que desea eliminar este mantenimiento?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${maintenance.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                                    Text('Fecha: ${DateFormat('dd/MM/yyyy').format(maintenance.maintenanceDate)}'),
                  Text('Kilometraje: ${maintenance.vehicleMileage} km'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Esta acción también eliminará todos los detalles asociados.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MaintenanceViewModel>().deleteMaintenance(maintenance.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Diálogo de detalles del mantenimiento
class _MaintenanceDetailsDialog extends StatelessWidget {
  final MaintenanceWithVehicle maintenance;

  const _MaintenanceDetailsDialog({required this.maintenance});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF0973AD),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.build, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mantenimiento - ${maintenance.vehicleLicensePlate}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del vehículo
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
                          const Row(
                            children: [
                              Icon(Icons.directions_car, color: Color(0xFF0973AD), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Información del Vehículo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _detailRow('Placa', maintenance.vehicleLicensePlate),
                          _detailRow('Marca', maintenance.vehicleBrand),
                          _detailRow('Modelo', maintenance.vehicleModel),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Información del mantenimiento
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
                              Icon(Icons.build, color: Color(0xFF0973AD), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Detalles del Mantenimiento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _detailRow('ID', maintenance.maintenance.id.toString()),
                          _detailRow('Fecha', DateFormat('dd/MM/yyyy').format(maintenance.maintenance.maintenanceDate)),
                          _detailRow('Kilometraje', '${maintenance.maintenance.vehicleMileage} km'),
                          if (maintenance.maintenance.details != null)
                            _detailRow('Observaciones', maintenance.maintenance.details!),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Detalles de mantenimiento
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
                          Row(
                            children: [
                              const Icon(Icons.list, color: Color(0xFF0973AD), size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Detalles de Servicios',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showAddDetailDialog(context, maintenance.maintenance.id),
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                label: const Text('Agregar', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0973AD),
                                  minimumSize: const Size(80, 32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Consumer<MaintenanceViewModel>(
                            builder: (context, viewModel, child) {
                              if (viewModel.detailsLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (viewModel.detailsError != null) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Error: ${viewModel.detailsError}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              if (!viewModel.hasMaintenanceDetails) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('No hay detalles de servicios registrados'),
                                  ),
                                );
                              }

                              return Column(
                                children: viewModel.currentMaintenanceDetails.map((detail) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const Icon(Icons.build_circle, color: Color(0xFF0973AD)),
                                      title: Text(detail.description),
                                      subtitle: Text('\$${detail.cost.toStringAsFixed(2)}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 18),
                                            onPressed: () => _showEditDetailDialog(context, detail),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                            onPressed: () => _showDeleteDetailConfirmation(context, detail),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Botones de acción
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
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<MaintenanceViewModel>().startEditingMaintenance(maintenance.maintenance);
                        showDialog(
                          context: context,
                          builder: (context) => _MaintenanceFormDialog(maintenance: maintenance.maintenance),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Editar', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0973AD),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmationFromDialog(context, maintenance.maintenance);
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddDetailDialog(BuildContext context, int maintenanceId) {
    showDialog(
      context: context,
      builder: (context) => _MaintenanceDetailFormDialog(maintenanceId: maintenanceId),
    );
  }

  void _showEditDetailDialog(BuildContext context, MaintenanceDetail detail) {
    showDialog(
      context: context,
      builder: (context) => _MaintenanceDetailFormDialog(
        maintenanceId: detail.maintenanceId,
        detail: detail,
      ),
    );
  }

  void _showDeleteDetailConfirmation(BuildContext context, MaintenanceDetail detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro de que desea eliminar este detalle?\n\n"${detail.description}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MaintenanceViewModel>().deleteMaintenanceDetail(detail.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationFromDialog(BuildContext context, Maintenance maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Está seguro de que desea eliminar este mantenimiento?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${maintenance.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Fecha: ${DateFormat('dd/MM/yyyy').format(maintenance.maintenanceDate)}'),
                  Text('Kilometraje: ${maintenance.vehicleMileage} km'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MaintenanceViewModel>().deleteMaintenance(maintenance.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Diálogo de formulario para crear/editar mantenimientos
class _MaintenanceFormDialog extends StatefulWidget {
  final Maintenance? maintenance;

  const _MaintenanceFormDialog({this.maintenance});

  @override
  _MaintenanceFormDialogState createState() => _MaintenanceFormDialogState();
}

class _MaintenanceFormDialogState extends State<_MaintenanceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _mileageController = TextEditingController();
  
  Vehicle? _selectedVehicle;
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.maintenance != null;
    
    if (_isEditing) {
      _selectedDate = widget.maintenance!.maintenanceDate;
      _mileageController.text = widget.maintenance!.vehicleMileage.toString();
      _detailsController.text = widget.maintenance!.details ?? '';
      
      // Buscar el vehículo correspondiente
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final viewModel = context.read<MaintenanceViewModel>();
        final vehicle = viewModel.availableVehicles.firstWhere(
          (v) => v.id == widget.maintenance!.vehicleId,
          orElse: () => viewModel.availableVehicles.first,
        );
        setState(() {
          _selectedVehicle = vehicle;
        });
      });
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Mantenimiento' : 'Nuevo Mantenimiento'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selector de vehículo
                Consumer<MaintenanceViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.vehiclesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.availableVehicles.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('No hay vehículos disponibles'),
                      );
                    }

                    return DropdownButtonFormField<Vehicle>(
                      value: _selectedVehicle,
                      decoration: const InputDecoration(
                        labelText: 'Vehículo',
                        border: OutlineInputBorder(),
                      ),
                      items: viewModel.availableVehicles.map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle,
                          child: Text('${vehicle.licensePlate} - ${vehicle.brand} ${vehicle.model ?? ''}'),
                        );
                      }).toList(),
                      onChanged: _isEditing ? null : (value) {
                        setState(() {
                          _selectedVehicle = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Debe seleccionar un vehículo';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Selector de fecha
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Mantenimiento',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo de kilometraje
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(
                    labelText: 'Kilometraje del Vehículo',
                    border: OutlineInputBorder(),
                    suffixText: 'km',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe ingresar el kilometraje';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Debe ser un número válido';
                    }
                    if (int.parse(value) < 0) {
                      return 'El kilometraje no puede ser negativo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de detalles
                TextFormField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones (Opcional)',
                    border: OutlineInputBorder(),
                    hintText: 'Describa los trabajos realizados...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_isEditing) {
              context.read<MaintenanceViewModel>().cancelEditingMaintenance();
            }
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        Consumer<MaintenanceViewModel>(
          builder: (context, viewModel, child) {
            return ElevatedButton(
              onPressed: viewModel.isOperating ? null : () => _saveMaintenanceMaintenance(viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: Text(
                _isEditing ? 'Actualizar' : 'Crear',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveMaintenanceMaintenance(MaintenanceViewModel viewModel) async {
    if (!_formKey.currentState!.validate() || _selectedVehicle == null) {
      return;
    }

    final maintenance = Maintenance(
      id: _isEditing ? widget.maintenance!.id : 0,
      vehicleId: _selectedVehicle!.id,
      maintenanceDate: _selectedDate,
      vehicleMileage: int.parse(_mileageController.text),
      details: _detailsController.text.isNotEmpty ? _detailsController.text : null,
      isActive: true,
    );

    bool success;
    if (_isEditing) {
      success = await viewModel.updateMaintenance(maintenance);
    } else {
      success = await viewModel.createMaintenance(maintenance);
    }

    if (success) {
      Navigator.pop(context);
    }
  }
}

// Diálogo de formulario para crear/editar detalles de mantenimiento
class _MaintenanceDetailFormDialog extends StatefulWidget {
  final int maintenanceId;
  final MaintenanceDetail? detail;

  const _MaintenanceDetailFormDialog({
    required this.maintenanceId,
    this.detail,
  });

  @override
  _MaintenanceDetailFormDialogState createState() => _MaintenanceDetailFormDialogState();
}

class _MaintenanceDetailFormDialogState extends State<_MaintenanceDetailFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.detail != null;
    
    if (_isEditing) {
      _descriptionController.text = widget.detail!.description;
      _costController.text = widget.detail!.cost.toString();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Detalle' : 'Nuevo Detalle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción del Servicio',
                border: OutlineInputBorder(),
                hintText: 'Ej: Cambio de aceite, revisión de frenos...',
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Debe ingresar una descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Costo',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debe ingresar el costo';
                }
                if (double.tryParse(value) == null) {
                  return 'Debe ser un número válido';
                }
                if (double.parse(value) < 0) {
                  return 'El costo no puede ser negativo';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_isEditing) {
              context.read<MaintenanceViewModel>().cancelEditingDetail();
            }
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        Consumer<MaintenanceViewModel>(
          builder: (context, viewModel, child) {
            return ElevatedButton(
              onPressed: viewModel.isOperating ? null : () => _saveDetail(viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: Text(
                _isEditing ? 'Actualizar' : 'Agregar',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveDetail(MaintenanceViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final detail = MaintenanceDetail(
      id: _isEditing ? widget.detail!.id : 0,
      maintenanceId: widget.maintenanceId,
      description: _descriptionController.text.trim(),
      cost: double.parse(_costController.text),
      isActive: true,
    );

    bool success;
    if (_isEditing) {
      success = await viewModel.updateMaintenanceDetail(detail);
    } else {
      success = await viewModel.createMaintenanceDetail(detail);
    }

    if (success) {
      Navigator.pop(context);
    }
  }
}