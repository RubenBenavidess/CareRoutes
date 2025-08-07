// views/consult_vehicles.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/consult_vehicles_viewmodel.dart';
import '../viewmodels/assign_driver_viewmodel.dart'; // <- AGREGAR
import '../views/assign_driver_view.dart'; // <- AGREGAR
import '../../domain/entities/domain_entities.dart';
import '../../domain/enums.dart';
import '../../domain/use_cases/consult_vehicles_usecase.dart';
import '../../domain/use_cases/assign_driver_usecase.dart'; // <- AGREGAR
import '../viewmodels/vehicle_location_viewmodel.dart';
import '../../domain/use_cases/vehicle_location_usecase.dart';
import '../views/vehicle_map.dart';
import 'package:get_it/get_it.dart';

class ConsultVehicles extends StatefulWidget {
  const ConsultVehicles({super.key});

  @override
  State<ConsultVehicles> createState() => _ConsultVehiclesState();
}

class _ConsultVehiclesState extends State<ConsultVehicles> {
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
    final viewModel = context.read<VehicleConsultViewModel>();
    viewModel.loadAllVehicles();
    viewModel.loadVehicleStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consulta de Vehículos',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        actions: [
          Consumer<VehicleConsultViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
                onPressed: viewModel.isLoading ? null : () => viewModel.refresh(),
                tooltip: 'Actualizar',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF0973AD)),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Color(0xFF0973AD)),
            onPressed: () => _showStatsDialog(context),
            tooltip: 'Estadísticas',
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
                      hintText: 'Buscar por placa, ID o aplicar filtros...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<VehicleConsultViewModel>().clearSearch();
                                context.read<VehicleConsultViewModel>().loadAllVehicles();
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
          Consumer<VehicleConsultViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.hasSearchQuery || viewModel.hasActiveFilters) {
                return Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          viewModel.hasSearchQuery
                              ? 'Búsqueda: ${viewModel.searchQuery} (${viewModel.totalFound} resultados)'
                              : 'Filtros aplicados (${viewModel.totalFound} resultados)',
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
                          viewModel.loadAllVehicles();
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

          // Lista de vehículos
          Expanded(
            child: Consumer<VehicleConsultViewModel>(
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
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.isEmpty || !viewModel.hasVehicles) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          viewModel.hasSearchQuery || viewModel.hasActiveFilters
                              ? Icons.search_off
                              : Icons.directions_car_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.hasSearchQuery || viewModel.hasActiveFilters
                              ? 'No se encontraron vehículos con los criterios especificados'
                              : 'No hay vehículos registrados',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = viewModel.vehicles[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _showVehicleDetails(context, vehicle),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Icono del vehículo
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0973AD).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: Color(0xFF0973AD),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Información del vehículo
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
                                              vehicle.licensePlate,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Chip(
                                            label: Text(
                                              _getStatusText(vehicle.status),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: _getStatusColor(vehicle.status),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${vehicle.brand} ${vehicle.model ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (vehicle.year != null || vehicle.mileage > 0)
                                        Text(
                                          '${vehicle.year != null ? 'Año: ${vehicle.year}' : ''}'
                                          '${vehicle.year != null && vehicle.mileage > 0 ? ' • ' : ''}'
                                          '${vehicle.mileage > 0 ? '${vehicle.mileage} km' : ''}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      // NUEVO: Información del conductor
                                      if (vehicle.driverId != null) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.green.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Conductor asignado',
                                              style: TextStyle(
                                                color: Colors.green.shade600,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // NUEVO: Botón de asignar conductor
                                IconButton(
                                  icon: Icon(
                                    vehicle.driverId != null ? Icons.person : Icons.person_add,
                                    color: const Color(0xFF0973AD),
                                  ),
                                  onPressed: () => _navigateToAssignDriver(context, vehicle),
                                  tooltip: vehicle.driverId != null 
                                    ? 'Gestionar conductor'
                                    : 'Asignar conductor',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.location_on, color: Color(0xFF0973AD)),
                                  onPressed: () => _showVehicleLocation(context, vehicle),
                                  tooltip: 'Ver ubicación',
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
    );
  }

  // NUEVO: Método para navegar a la vista de asignar conductor
  void _navigateToAssignDriver(BuildContext context, Vehicle vehicle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => AssignDriverViewModel(
            assignDriverUseCase: GetIt.instance<AssignDriverUseCase>(),
          ),
          child: AssignDriverView(vehicle: vehicle),
        ),
      ),
    );

    // Si se realizó una asignación, actualizar la lista
    if (result == true) {
      context.read<VehicleConsultViewModel>().refresh();
    }
  }

  void _showVehicleLocation(BuildContext context, Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => VehicleLocationViewModel(
            vehicleLocationUseCase: GetIt.instance<VehicleLocationUseCase>(),
          ),
          child: VehicleMapView(vehicle: vehicle),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    final viewModel = context.read<VehicleConsultViewModel>();
    
    // Intentar buscar por ID si es un número
    final id = int.tryParse(query);
    if (id != null) {
      viewModel.searchVehicleById(id);
    } else {
      // Buscar por placa
      viewModel.searchVehicleByPlate(query);
    }
  }

  String _getStatusText(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return 'DISPONIBLE';
      case VehicleStatus.assigned:
        return 'ASIGNADO';
      case VehicleStatus.maintenance:
        return 'MANTENIMIENTO';
      case VehicleStatus.outOfService:
        return 'FUERA DE SERVICIO';
    }
  }

  Color _getStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return Colors.green;
      case VehicleStatus.assigned:
        return Colors.blue;
      case VehicleStatus.maintenance:
        return Colors.orange;
      case VehicleStatus.outOfService:
        return Colors.red;
    }
  }

  void _showVehicleDetails(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vehículo ${vehicle.licensePlate}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('ID', vehicle.id.toString()),
            _detailRow('Placa', vehicle.licensePlate),
            _detailRow('Marca', vehicle.brand),
            if (vehicle.model != null) _detailRow('Modelo', vehicle.model!),
            if (vehicle.year != null) _detailRow('Año', vehicle.year.toString()),
            _detailRow('Kilometraje', '${vehicle.mileage} km'),
            _detailRow('Estado', _getStatusText(vehicle.status)),
            _detailRow('Conductor Asignado', vehicle.driverId != null ? 'Sí (ID: ${vehicle.driverId})' : 'No'),
            
            // NUEVO: Botón para asignar conductor desde el diálogo
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo
                  _navigateToAssignDriver(context, vehicle);
                },
                icon: Icon(
                  vehicle.driverId != null ? Icons.person : Icons.person_add,
                  color: Colors.white,
                ),
                label: Text(
                  vehicle.driverId != null ? 'Gestionar Conductor' : 'Asignar Conductor',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0973AD),
                ),
              ),
            ),
          ],
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FilterDialog(),
    );
  }

  void _showStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _StatsDialog(),
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
}

// Diálogo de filtros
class _FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _minMileageController = TextEditingController();
  final _maxMileageController = TextEditingController();
  VehicleStatus? _selectedStatus;
  bool? _hasDriver;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Vehículos'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                hintText: 'Ej: Toyota, Ford...',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Modelo',
                hintText: 'Ej: Corolla, Focus...',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Año',
                hintText: 'Ej: 2020',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<VehicleStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: VehicleStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusText(status)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<bool?>(
              value: _hasDriver,
              decoration: const InputDecoration(labelText: 'Conductor'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Todos')),
                DropdownMenuItem(value: true, child: Text('Con conductor')),
                DropdownMenuItem(value: false, child: Text('Sin conductor')),
              ],
              onChanged: (value) => setState(() => _hasDriver = value),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minMileageController,
                    decoration: const InputDecoration(
                      labelText: 'KM mínimo',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxMileageController,
                    decoration: const InputDecoration(
                      labelText: 'KM máximo',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
            final filter = VehicleFilter(
              brand: _brandController.text.isNotEmpty ? _brandController.text : null,
              model: _modelController.text.isNotEmpty ? _modelController.text : null,
              year: _yearController.text.isNotEmpty ? int.tryParse(_yearController.text) : null,
              status: _selectedStatus,
              hasDriver: _hasDriver,
              minMileage: _minMileageController.text.isNotEmpty ? int.tryParse(_minMileageController.text) : null,
              maxMileage: _maxMileageController.text.isNotEmpty ? int.tryParse(_maxMileageController.text) : null,
            );

            context.read<VehicleConsultViewModel>().applyFilters(filter);
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

  String _getStatusText(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return 'Disponible';
      case VehicleStatus.assigned:
        return 'Asignado';
      case VehicleStatus.maintenance:
        return 'Mantenimiento';
      case VehicleStatus.outOfService:
        return 'Fuera de servicio';
    }
  }
}

// Diálogo de estadísticas
class _StatsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleConsultViewModel>(
      builder: (context, viewModel, child) {
        final stats = viewModel.vehicleStats;
        if (stats == null) {
          return AlertDialog(
            title: const Text('Estadísticas'),
            content: const Text('Cargando estadísticas...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          );
        }

        return AlertDialog(
          title: const Text('Estadísticas de Vehículos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total de vehículos: ${stats.totalVehicles}'),
              Text('Con conductor: ${stats.vehiclesWithDriver}'),
              Text('Sin conductor: ${stats.vehiclesWithoutDriver}'),
              const SizedBox(height: 16),
              const Text('Por estado:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...stats.statusCounts.entries.map((entry) =>
                Text('${_getStatusText(entry.key)}: ${entry.value}'),
              ),
              const SizedBox(height: 16),
              if (stats.averageYear != null)
                Text('Año promedio: ${stats.averageYear}'),
              Text('Kilometraje promedio: ${stats.averageMileage} km'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String _getStatusText(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return 'Disponible';
      case VehicleStatus.assigned:
        return 'Asignado';
      case VehicleStatus.maintenance:
        return 'Mantenimiento';
      case VehicleStatus.outOfService:
        return 'Fuera de servicio';
    }
  }
}