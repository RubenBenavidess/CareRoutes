// presentation/views/widgets/route_overview_item.dart
import 'package:flutter/material.dart';
import '../../../domain/use_cases/get_routes_with_assignments_usecase.dart';

class RouteOverviewItem extends StatelessWidget {
  final RouteWithAssignments route;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final Function(int)? onEditRoute;

  const RouteOverviewItem({
    Key? key,
    required this.route,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.onEditRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header de la ruta
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icono de expansión
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.chevron_right, size: 24),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Información de la ruta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                route.route.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildRouteStatus(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${route.stops.length} paradas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.assignment, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${route.assignments.length} asignaciones',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón editar
                  IconButton(
                    onPressed: onEditRoute != null ? () => onEditRoute!(route.route.id) : null,
                    icon: const Icon(Icons.edit),
                    tooltip: 'Editar ruta',
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Lista expandible de asignaciones
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildAssignmentsList(context),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStatus() {
    if (route.assignments.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Sin asignaciones',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final now = DateTime.now();
    final activeAssignments = route.assignments.where((a) {
      return a.assignment.assignedDate.isAfter(now.subtract(const Duration(days: 1)));
    }).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: activeAssignments > 0 ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        activeAssignments > 0 ? 'Activa' : 'Inactiva',
        style: TextStyle(
          fontSize: 10,
          color: activeAssignments > 0 ? Colors.green.shade700 : Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(BuildContext context) {
    if (route.assignments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay asignaciones',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Esta ruta no tiene vehículos asignados',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de asignaciones
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.assignment, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Asignaciones (${route.assignments.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'Fechas pasadas al final',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de asignaciones
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            itemCount: route.assignments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final assignment = route.assignments[index];
              return _buildAssignmentItem(context, assignment, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem(BuildContext context, RouteAssignmentWithVehicle assignment, int index) {
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

    return Container(
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
          // Número de orden visual
          Container(
            width: 24,
            height: 24,
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
          
          // Información del vehículo
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (assignment.vehicle.brand != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    assignment.vehicle.brand!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Fecha de asignación
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: _getAssignmentColor(isToday, isPast, isFuture),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(assignment.assignment.assignedDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _getAssignmentColor(isToday, isPast, isFuture),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _getDateLabel(isToday, isPast, isFuture),
                  style: TextStyle(
                    fontSize: 11,
                    color: _getAssignmentColor(isToday, isPast, isFuture),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Estado visual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getAssignmentColor(isToday, isPast, isFuture).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getAssignmentColor(isToday, isPast, isFuture).withOpacity(0.3),
              ),
            ),
            child: Text(
              _getStatusText(isToday, isPast, isFuture),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _getAssignmentColor(isToday, isPast, isFuture),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos de ayuda para colores y estados
  Color _getAssignmentColor(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return Colors.green;
    if (isPast) return Colors.grey;
    return Colors.blue; // isFuture
  }

  Color _getAssignmentBorderColor(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return Colors.green.shade300;
    if (isPast) return Colors.grey.shade300;
    return Colors.blue.shade300; // isFuture
  }

  String _getDateLabel(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return 'Hoy';
    if (isPast) return 'Pasada';
    return 'Próxima'; // isFuture
  }

  String _getStatusText(bool isToday, bool isPast, bool isFuture) {
    if (isToday) return 'HOY';
    if (isPast) return 'PASADA';
    return 'PRÓXIMA'; // isFuture
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}