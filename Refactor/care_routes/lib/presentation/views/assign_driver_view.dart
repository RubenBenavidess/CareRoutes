// presentation/views/assign_driver_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/assign_driver_viewmodel.dart';
import '../../domain/entities/domain_entities.dart';
import '../../domain/enums.dart';

class AssignDriverView extends StatefulWidget {
  final Vehicle vehicle;

  const AssignDriverView({
    super.key,
    required this.vehicle,
  });

  @override
  State<AssignDriverView> createState() => _AssignDriverViewState();
}

class _AssignDriverViewState extends State<AssignDriverView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignDriverViewModel>().initializeWithVehicle(widget.vehicle);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asignar Conductor',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0973AD)),
        actions: [
          Consumer<AssignDriverViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
                onPressed: viewModel.isLoading ? null : () => viewModel.refreshAll(),
                tooltip: 'Actualizar',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Color(0xFF0973AD)),
            onPressed: () => _showStatsDialog(),
            tooltip: 'Estadísticas',
          ),
        ],
      ),
      body: Consumer<AssignDriverViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Panel de información del vehículo
              _buildVehicleInfoPanel(viewModel),
              
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

  Widget _buildVehicleInfoPanel(AssignDriverViewModel viewModel) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Información del vehículo
          Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.vehicleInfo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildVehicleStatusChip(viewModel.currentVehicle?.status),
                  ],
                ),
              ),
            ],
          ),
          
          // Estado del conductor asignado
          const SizedBox(height: 16),
          _buildDriverStatusPanel(viewModel),
        ],
      ),
    );
  }

  Widget _buildVehicleStatusChip(VehicleStatus? status) {
    if (status == null) return const SizedBox.shrink();

    Color color;
    String text;
    
    switch (status) {
      case VehicleStatus.available:
        color = Colors.green;
        text = 'DISPONIBLE';
        break;
      case VehicleStatus.assigned:
        color = Colors.blue;
        text = 'ASIGNADO';
        break;
      case VehicleStatus.maintenance:
        color = Colors.orange;
        text = 'MANTENIMIENTO';
        break;
      case VehicleStatus.outOfService:
        color = Colors.red;
        text = 'FUERA DE SERVICIO';
        break;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDriverStatusPanel(AssignDriverViewModel viewModel) {
    return Container(
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
              Icon(Icons.person, color: Color(0xFF0973AD), size: 20),
              SizedBox(width: 8),
              Text(
                'Conductor Asignado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (viewModel.isLoading) ...[
            const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Cargando información del conductor...'),
              ],
            ),
          ] else if (viewModel.hasAssignedDriver) ...[
            _buildAssignedDriverInfo(viewModel.assignedDriver!, viewModel),
          ] else ...[
            _buildNoDriverAssigned(viewModel),
          ],
        ],
      ),
    );
  }

  Widget _buildAssignedDriverInfo(Driver driver, AssignDriverViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.person,
                color: Colors.blue.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.getDriverFullName(driver),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Cédula: ${driver.idNumber}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: viewModel.canUnassignDriver 
                ? () => _showUnassignConfirmation(viewModel, driver)
                : null,
            icon: const Icon(Icons.person_remove, color: Colors.white),
            label: const Text('Desasignar Conductor', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoDriverAssigned(AssignDriverViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.person_outline,
                color: Colors.grey.shade500,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sin conductor asignado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Este vehículo está disponible para asignación',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: viewModel.canAssignDriver 
                ? () => _showAssignDriverDialog(viewModel)
                : null,
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text('Asignar Conductor', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0973AD),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(AssignDriverViewModel viewModel) {
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
              onPressed: () => viewModel.refreshAll(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (viewModel.successMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              viewModel.successMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.confirmSuccess(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: const Text('Continuar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Resumen de conductores disponibles
          if (viewModel.hasAvailableDrivers) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFF0973AD)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hay ${viewModel.availableDrivers.length} conductores disponibles para asignación',
                      style: const TextStyle(
                        color: Color(0xFF0973AD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'No hay conductores disponibles para asignación',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAssignDriverDialog(AssignDriverViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => _AssignDriverDialog(viewModel: viewModel),
    );
  }

  void _showUnassignConfirmation(AssignDriverViewModel viewModel, Driver driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Desasignación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Está seguro de que desea desasignar al conductor?'),
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
                    'Conductor: ${viewModel.getDriverFullName(driver)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Cédula: ${driver.idNumber}'),
                  Text('Vehículo: ${viewModel.vehicleInfo}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'El vehículo quedará disponible para asignación a otro conductor.',
              style: TextStyle(color: Colors.grey),
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
              viewModel.unassignDriver();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Desasignar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => _StatsDialog(),
    );
  }
}

// Diálogo para asignar conductor
class _AssignDriverDialog extends StatefulWidget {
  final AssignDriverViewModel viewModel;

  const _AssignDriverDialog({required this.viewModel});

  @override
  _AssignDriverDialogState createState() => _AssignDriverDialogState();
}

class _AssignDriverDialogState extends State<_AssignDriverDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Driver> _filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    _filteredDrivers = widget.viewModel.availableDrivers;
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
      _filteredDrivers = widget.viewModel.filterDriversByName(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Conductor'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o cédula...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista de conductores
            Expanded(
              child: _filteredDrivers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'No se encontraron conductores'
                                : 'No hay conductores disponibles',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = _filteredDrivers[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF0973AD).withOpacity(0.1),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF0973AD),
                              ),
                            ),
                            title: Text(
                              widget.viewModel.getDriverFullName(driver),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('Cédula: ${driver.idNumber}'),
                            onTap: () {
                              Navigator.pop(context);
                              widget.viewModel.assignDriver(driver);
                            },
                          ),
                        );
                      },
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
      ],
    );
  }
}

// Diálogo de estadísticas
class _StatsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AssignDriverViewModel>(
      builder: (context, viewModel, child) {
        final stats = viewModel.stats;
        if (stats == null) {
          return AlertDialog(
            title: const Text('Estadísticas de Asignaciones'),
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
          title: const Text('Estadísticas de Asignaciones'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total de vehículos', '${stats.totalVehicles}'),
              _buildStatRow('Vehículos asignados', '${stats.assignedVehicles}'),
              _buildStatRow('Vehículos disponibles', '${stats.availableVehicles}'),
              const Divider(),
              _buildStatRow('Total de conductores', '${stats.totalDrivers}'),
              _buildStatRow('Conductores asignados', '${stats.assignedDrivers}'),
              _buildStatRow('Conductores disponibles', '${stats.availableDrivers}'),
              const Divider(),
              _buildStatRow('Tasa de asignación', '${stats.assignmentRate.toStringAsFixed(1)}%'),
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}