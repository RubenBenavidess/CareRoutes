// widgets/assignments_list_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/use_cases/manage_route_assginments_usecase.dart';
import '../../viewmodels/route_management_viewmodel.dart';

class AssignmentsListWidget extends StatelessWidget {
  const AssignmentsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteManagementViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Asignaciones Actuales',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (viewModel.assignments.isEmpty)
                  _buildEmptyState()
                else
                  _buildAssignmentsList(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No hay asignaciones',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las asignaciones de vehículos aparecerán aquí',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsList(RouteManagementViewModel viewModel) {
    return Column(
      children: [
        // Header de la lista
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text('Vehículo', style: _headerStyle())),
              Expanded(flex: 2, child: Text('Fecha', style: _headerStyle())),
              Expanded(flex: 1, child: Text('Estado', style: _headerStyle())),
              const SizedBox(width: 80), // Espacio para acciones
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Lista de asignaciones
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.assignments.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final assignment = viewModel.assignments[index];
            return _buildAssignmentItem(context, assignment, viewModel);
          },
        ),
        
        const SizedBox(height: 12),
        
        // Información de resumen
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Total de asignaciones: ${viewModel.assignments.length}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentItem(
    BuildContext context, 
    RouteAssignmentWithDetails assignment, 
    RouteManagementViewModel viewModel,
  ) {
    final isUpcoming = assignment.assignment.assignedDate.isAfter(DateTime.now());
    final isPast = assignment.assignment.assignedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isUpcoming ? Colors.green.shade200 : 
                  isPast ? Colors.grey.shade300 : Colors.orange.shade200,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isUpcoming ? Colors.green.shade50 : 
                isPast ? Colors.grey.shade50 : Colors.orange.shade50,
      ),
      child: Row(
        children: [
          // Información del vehículo
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.vehicle.licensePlate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  assignment.vehicle.licensePlate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Fecha
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => _showDatePicker(context, assignment, viewModel),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(assignment.assignment.assignedDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Estado
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(assignment.assignment.assignedDate),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(assignment.assignment.assignedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Acciones
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showDatePicker(context, assignment, viewModel);
                  break;
                case 'delete':
                  _showDeleteConfirmation(context, assignment, viewModel);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16),
                    SizedBox(width: 8),
                    Text('Cambiar fecha'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.black87,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _getStatusColor(DateTime scheduledDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    
    if (scheduleDay.isAfter(today)) {
      return Colors.green;
    } else if (scheduleDay.isBefore(today)) {
      return Colors.grey;
    } else {
      return Colors.orange;
    }
  }

  String _getStatusText(DateTime scheduledDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    
    if (scheduleDay.isAfter(today)) {
      return 'Próximo';
    } else if (scheduleDay.isBefore(today)) {
      return 'Pasado';
    } else {
      return 'Hoy';
    }
  }

  void _showDatePicker(
    BuildContext context, 
    RouteAssignmentWithDetails assignment, 
    RouteManagementViewModel viewModel,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: assignment.assignment.assignedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
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

    if (newDate != null && newDate != assignment.assignment.assignedDate) {
      await viewModel.updateAssignmentDate(assignment.assignment.id, newDate);
    }
  }

  void _showDeleteConfirmation(
    BuildContext context, 
    RouteAssignmentWithDetails assignment, 
    RouteManagementViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar la asignación del vehículo '
          '${assignment.vehicle.licensePlate} programada para el '
          '${_formatDate(assignment.assignment.assignedDate)}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteAssignment(assignment.assignment.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}