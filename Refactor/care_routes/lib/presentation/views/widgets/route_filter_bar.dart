// presentation/views/widgets/route_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/use_cases/get_assigned_vehicles_usecase.dart';
import '../../viewmodels/route_management_viewmodel.dart';

class RouteFilterBar extends StatelessWidget {
  const RouteFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteManagementViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Fila principal de filtros
              Row(
                children: [
                  // Filtro por vehículo
                  Expanded(
                    flex: 2,
                    child: _buildVehicleFilter(viewModel),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Control de ordenamiento de fechas
                  Expanded(
                    flex: 1,
                    child: _buildDateSortControl(viewModel),
                  ),
                ],
              ),
              
              // Información de estado del filtro
              if (viewModel.hasVehicleFilter || viewModel.isRefreshingOverview) ...[
                const SizedBox(height: 12),
                _buildFilterStatus(viewModel),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleFilter(RouteManagementViewModel viewModel) {
    return DropdownButtonFormField<VehicleWithAssignmentCount>(
      value: viewModel.selectedVehicleFilter,
      decoration: const InputDecoration(
        labelText: 'Filtrar por vehículo',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.directions_car, size: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      isExpanded: true,
      items: [
        const DropdownMenuItem<VehicleWithAssignmentCount>(
          value: null,
          child: Text('-- Todos los vehículos --'),
        ),
        ...viewModel.availableVehicles.map((vehicle) {
          return DropdownMenuItem<VehicleWithAssignmentCount>(
            value: vehicle,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    vehicle.vehicle.licensePlate,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${vehicle.assignmentCount}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      onChanged: viewModel.isRefreshingOverview ? null : (vehicle) {
        viewModel.setVehicleFilter(vehicle);
      },
    );
  }

  Widget _buildDateSortControl(RouteManagementViewModel viewModel) {
    return InkWell(
      onTap: viewModel.isRefreshingOverview ? null : () {
        viewModel.toggleDateSortOrder();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              viewModel.isDateSortAscending 
                  ? Icons.arrow_upward 
                  : Icons.arrow_downward,
              size: 20,
              color: viewModel.isRefreshingOverview ? Colors.grey : Colors.blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fechas',
                    style: TextStyle(
                      fontSize: 12,
                      color: viewModel.isRefreshingOverview ? Colors.grey : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    viewModel.isDateSortAscending ? 'Antiguas primero' : 'Recientes primero',
                    style: TextStyle(
                      fontSize: 10,
                      color: viewModel.isRefreshingOverview ? Colors.grey : Colors.grey[600],
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

  Widget _buildFilterStatus(RouteManagementViewModel viewModel) {
    if (viewModel.isRefreshingOverview) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Actualizando filtros...',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.filterStatusText,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (viewModel.hasVehicleFilter)
            InkWell(
              onTap: () => viewModel.clearVehicleFilter(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}