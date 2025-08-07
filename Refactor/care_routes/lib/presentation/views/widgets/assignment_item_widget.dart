// presentation/views/widgets/assignment_item_widget.dart
import 'package:flutter/material.dart';
import '../../../domain/use_cases/get_routes_with_assignments_usecase.dart';

class AssignmentItemWidget extends StatelessWidget {
  final RouteAssignmentWithVehicle assignment;
  final int index;
  final bool showRouteInfo;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssignmentItemWidget({
    Key? key,
    required this.assignment,
    required this.index,
    this.showRouteInfo = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final assignmentDate = DateTime(
      assignment.assignment.assignedDate.year,
      assignment.assignment.assignedDate.month,
      assignment.assignment.assignedDate.day,
    );

    final isToday = assignmentDate.isAtSameMomentAs(today);
    final isPast = assignmentDate.isBefore(today);
    final isFuture = assignmentDate.isAfter(today);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getAssignmentBorderColor(isToday, isPast, isFuture),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Número de orden
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getAssignmentColor(isToday, isPast, isFuture),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehículo
                  Row(
                    children: [
                      Icon(Icons.directions_bus, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        assignment.vehicle.licensePlate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  // Fecha
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: _getAssignmentColor(isToday, isPast, isFuture),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(assignment.assignment.assignedDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getAssignmentColor(isToday, isPast, isFuture).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getDateLabel(isToday, isPast, isFuture),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getAssignmentColor(isToday, isPast, isFuture),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Acciones
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
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
      ),
    );
  }

  // Métodos de ayuda (mismos que en RouteOverviewItem)
  Color _getAssignmentColor(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return Colors.green;
    if (isPast) return Colors.grey;
    return Colors.blue;
  }

  Color _getAssignmentBorderColor(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return Colors.green.shade300;
    if (isPast) return Colors.grey.shade300;
    return Colors.blue.shade300;
  }

  String _getDateLabel(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return 'Hoy';
    if (isPast) return 'Pasada';
    return 'Próxima';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}