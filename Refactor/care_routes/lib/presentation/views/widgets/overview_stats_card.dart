// presentation/views/widgets/overview_stats_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/route_management_viewmodel.dart';

class OverviewStatsCard extends StatelessWidget {
  const OverviewStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteManagementViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasRoutesWithAssignments) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              _buildStatItem(
                icon: Icons.route,
                label: 'Rutas',
                value: viewModel.totalRoutesWithAssignments.toString(),
                color: Colors.blue,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.today,
                label: 'Hoy',
                value: viewModel.getTodayAssignmentsCount().toString(),
                color: Colors.green,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.schedule,
                label: 'Próximas',
                value: viewModel.getUpcomingAssignmentsCount().toString(),
                color: Colors.orange,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.history,
                label: 'Pasadas',
                value: viewModel.getPastAssignmentsCount().toString(),
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}