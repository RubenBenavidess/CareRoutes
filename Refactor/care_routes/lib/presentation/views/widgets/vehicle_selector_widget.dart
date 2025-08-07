// widgets/vehicle_selector_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/route_management_viewmodel.dart';
import '../../viewmodels/consult_vehicles_viewmodel.dart';

class VehicleSelectorWidget extends StatefulWidget {
  const VehicleSelectorWidget({super.key});

  @override
  State<VehicleSelectorWidget> createState() => _VehicleSelectorWidgetState();
}

class _VehicleSelectorWidgetState extends State<VehicleSelectorWidget> {
  @override
  void initState() {
    super.initState();
    // Cargar vehículos al inicializar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicleViewModel = context.read<VehicleConsultViewModel>();
      if (vehicleViewModel.vehicles.isEmpty && !vehicleViewModel.isLoading) {
        vehicleViewModel.loadAllVehicles();
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return Consumer2<RouteManagementViewModel, VehicleConsultViewModel>(
    builder: (context, routeViewModel, vehicleViewModel, child) {
      return IntrinsicHeight(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24), // Aumentado de 16 a 24
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con más espacio
                Row(
                  children: [
                    Icon(Icons.directions_bus, color: Colors.blue, size: 24), // Ícono más grande
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Asignación de Vehículo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Texto más grande
                      ),
                    ),
                    if (vehicleViewModel.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 24), // Más espacio
                
                // Error message con más altura
                if (vehicleViewModel.hasError)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16), // Más padding
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Error al cargar vehículos',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        IconButton(
                          onPressed: () => vehicleViewModel.loadAllVehicles(),
                          icon: Icon(Icons.refresh, color: Colors.red.shade700, size: 20),
                        ),
                      ],
                    ),
                  ),
                
                // Dropdown con más altura
                DropdownButtonFormField<int>(
                  value: routeViewModel.selectedVehicleId,
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar vehículo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_bus, size: 24),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Más padding
                  ),
                  isExpanded: true,
                  isDense: false, // No comprimir
                  menuMaxHeight: 400, // Aumentar altura máxima del menú
                  items: _buildVehicleDropdownItems(vehicleViewModel),
                  onChanged: vehicleViewModel.isLoading ? null : (vehicleId) {
                    if (vehicleId != null) {
                      routeViewModel.setSelectedVehicle(vehicleId);
                    } else {
                      routeViewModel.clearSelection();
                    }
                  },
                ),
                
                const SizedBox(height: 24), // Más espacio
                
                // Selector de fecha con más altura
                InkWell(
                  onTap: vehicleViewModel.isLoading ? null : () => _selectDate(context, routeViewModel),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Más padding
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 24,
                          color: vehicleViewModel.isLoading ? Colors.grey : Colors.grey[600],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            routeViewModel.selectedDate?.toLocal().toString().split(' ')[0] ?? 
                            'Fecha de asignación',
                            style: TextStyle(
                              color: vehicleViewModel.isLoading 
                                  ? Colors.grey
                                  : routeViewModel.selectedDate != null 
                                      ? Colors.black 
                                      : Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Spacer para empujar el contenido hacia abajo si hay espacio
                const Spacer(),
                
                // Información de selección
                if (routeViewModel.selectedVehicleId != null && routeViewModel.selectedDate != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Vehículo ${_getVehicleName(vehicleViewModel, routeViewModel.selectedVehicleId!)} '
                            'programado para ${_formatDate(routeViewModel.selectedDate!)}',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Botón limpiar selección
                if (routeViewModel.selectedVehicleId != null || routeViewModel.selectedDate != null) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => routeViewModel.clearSelection(),
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text('Limpiar selección', style: TextStyle(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16), // Botón más alto
                      ),
                    ),
                  ),
                ],
                
                // Status info
                if (vehicleViewModel.vehicles.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            '${vehicleViewModel.vehicles.length} vehículos disponibles',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 16), // Espacio final
              ],
            ),
          ),
        ),
      );
    },
  );
}

  List<DropdownMenuItem<int>> _buildVehicleDropdownItems(VehicleConsultViewModel vehicleViewModel) {
    if (vehicleViewModel.isLoading) {
      return [
        DropdownMenuItem<int>(
          value: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              const Text('Cargando...', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ];
    }

    if (vehicleViewModel.hasError || vehicleViewModel.vehicles.isEmpty) {
      return [
        const DropdownMenuItem<int>(
          value: null,
          child: Text(
            '-- No hay vehículos disponibles --',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ];
    }

    return [
      const DropdownMenuItem<int>(
        value: null,
        child: Text(
          '-- Seleccionar vehículo --',
          style: TextStyle(fontSize: 14),
        ),
      ),
      ...vehicleViewModel.vehicles.map((vehicle) {
        return DropdownMenuItem<int>(
          value: vehicle.id,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300), // Evita overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vehicle.brand, // Corregido: no duplicado
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (vehicle.licensePlate.isNotEmpty)
                  Text(
                    'Placa: ${vehicle.licensePlate}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        );
      }),
    ];
  }

  Future<void> _selectDate(BuildContext context, RouteManagementViewModel routeViewModel) async {
    final date = await showDatePicker(
      context: context,
      initialDate: routeViewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (date != null) {
      routeViewModel.setSelectedDate(date);
    }
  }

  String _getVehicleName(VehicleConsultViewModel vehicleViewModel, int vehicleId) {
    try {
      final vehicle = vehicleViewModel.vehicles.firstWhere((v) => v.id == vehicleId);
      return vehicle.licensePlate.isNotEmpty ? vehicle.licensePlate : 'Vehículo #$vehicleId';
    } catch (e) {
      return 'Vehículo #$vehicleId';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}';
  }
}