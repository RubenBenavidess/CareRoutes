// screens/assign_custodians.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/enums.dart';
import '../controllers/usable_drivers_controller.dart';
import '../controllers/usable_vehicles_controller.dart';
import '../controllers/vehicle_assignment_controller.dart';
import '../domain/usable_driver.dart';
import '../domain/usable_vehicle.dart';

class AssignCustodians extends ConsumerStatefulWidget {
  const AssignCustodians({super.key});

  @override
  ConsumerState<AssignCustodians> createState() => _AssignCustodiansState();
}

class _AssignCustodiansState extends ConsumerState<AssignCustodians> {
  String _searchQuery = '';
  VehicleStatus? _filterStatus;
  UsableDriver? _selectedDriver;

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(usableDriversStreamProvider);
    final vehiclesAsync = ref.watch(usableVehiclesStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Custodios', 
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: driversAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (drivers) => vehiclesAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (vehicles) => _buildContent(drivers, vehicles),
        ),
      ),
    );
  }
  
  Widget _buildContent(List<UsableDriver> drivers, List<UsableVehicle> vehicles) {
    // Filtrar vehículos
    final filteredVehicles = vehicles.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.licensePlate.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.model.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == null || v.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
    
    // Obtener conductores disponibles
    final assignedDriverIds = vehicles
        .where((v) => v.idDriver != null)
        .map((v) => v.idDriver!)
        .toSet();
    final availableDrivers = drivers
        .where((d) => !assignedDriverIds.contains(d.idDriver))
        .toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
    
    return Column(
      children: [
        // Búsqueda y filtro
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar por placa o marca...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Filtrar por estado:', 
                    style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<VehicleStatus?>(
                      isExpanded: true,
                      value: _filterStatus,
                      items: [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        ...VehicleStatus.values.map((s) =>
                            DropdownMenuItem(
                              value: s, 
                              child: Text(_getStatusText(s))
                            )
                        ),
                      ],
                      onChanged: (s) => setState(() => _filterStatus = s),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Lista de vehículos
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredVehicles.length,
            itemBuilder: (ctx, i) {
              final vehicle = filteredVehicles[i];
              final driver = vehicle.idDriver != null
                  ? drivers.firstWhere(
                      (d) => d.idDriver == vehicle.idDriver,
                      orElse: () => throw StateError('Driver not found'),
                    )
                  : null;
              
              return _buildVehicleCard(vehicle, driver, availableDrivers);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildVehicleCard(
    UsableVehicle vehicle, 
    UsableDriver? driver,
    List<UsableDriver> availableDrivers,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.licensePlate,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${vehicle.brand} (${vehicle.year})'),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(vehicle.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getStatusColor(vehicle.status)),
                        ),
                        child: Text(
                          _getStatusText(vehicle.status),
                          style: TextStyle(
                            color: _getStatusColor(vehicle.status),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (vehicle.status == VehicleStatus.available)
                  ElevatedButton.icon(
                    icon: Icon(Icons.person_add, size: 16),
                    label: Text('Asignar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _showAssignDialog(vehicle, availableDrivers),
                  )
                else if (vehicle.status == VehicleStatus.assigned && driver != null)
                  ElevatedButton.icon(
                    icon: Icon(Icons.person_remove, size: 16),
                    label: Text('Desasignar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () => _unassignDriver(vehicle, driver),
                  ),
              ],
            ),
            
            if (driver != null) ...[
              Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${driver.firstName} ${driver.lastName}',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Cédula: ${driver.idNumber}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showAssignDialog(UsableVehicle vehicle, List<UsableDriver> availableDrivers) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text('Asignar Custodio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vehículo: ${vehicle.licensePlate}'),
              SizedBox(height: 16),
              if (availableDrivers.isEmpty)
                Text('No hay custodios disponibles.')
              else
                ...availableDrivers.map((d) => RadioListTile<UsableDriver>(
                  value: d,
                  groupValue: _selectedDriver,
                  onChanged: (val) => setStateDialog(() => _selectedDriver = val),
                  title: Text('${d.firstName} ${d.lastName}'),
                  subtitle: Text('Cédula: ${d.idNumber}'),
                )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _selectedDriver = null;
                Navigator.pop(ctx);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _selectedDriver == null
                  ? null
                  : () async {
                      final controller = ref.read(vehicleAssignmentControllerProvider);
                      try {
                        await controller.assignDriverToVehicle(
                          vehicle.idVehicle, 
                          _selectedDriver!.idDriver
                        );
                        _selectedDriver = null;
                        Navigator.pop(ctx);
                        _showSuccessDialog();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
              child: Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _unassignDriver(UsableVehicle vehicle, UsableDriver driver) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Desasignar Custodio'),
        content: Text(
          '¿Seguro que quieres desasignar a ${driver.firstName} ${driver.lastName} '
          'del vehículo ${vehicle.licensePlate}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancelar')
          ),
          ElevatedButton(
            onPressed: () async {
              final controller = ref.read(vehicleAssignmentControllerProvider);
              try {
                await controller.unassignDriverFromVehicle(vehicle.idVehicle);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Custodio desasignado exitosamente')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: Text('¡Asignación Exitosa!'),
        content: Text('El custodio ha sido asignado correctamente al vehículo.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Continuar')
          ),
        ],
      ),
    );
  }
  
  String _getStatusText(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return 'Disponible';
      case VehicleStatus.assigned:
        return 'Asignado';
      case VehicleStatus.maintenance:
        return 'En mantenimiento';
      case VehicleStatus.outOfService:
        return 'Fuera de servicio';
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
}

extension on UsableDriver {
  String get fullName => '$firstName $lastName';
}