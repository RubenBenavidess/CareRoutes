// presentation/views/routes_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/route_management_viewmodel.dart';
import '../../domain/use_cases/get_routes_with_assignments_usecase.dart';
import 'widgets/route_filter_bar.dart';
import 'widgets/route_overview_item.dart';
import 'widgets/overview_stats_card.dart';

class RoutesOverviewScreen extends StatefulWidget {
  final Function(int)? onEditRoute; // Callback para navegar al editor

  const RoutesOverviewScreen({
    Key? key,
    this.onEditRoute,
  }) : super(key: key);

  @override
  State<RoutesOverviewScreen> createState() => _RoutesOverviewScreenState();
}

class _RoutesOverviewScreenState extends State<RoutesOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteManagementViewModel>().loadRoutesOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas y Asignaciones'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          Consumer<RouteManagementViewModel>(
            builder: (context, viewModel, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón expandir/colapsar todo
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'expand_all':
                          viewModel.expandAllRoutes();
                          break;
                        case 'collapse_all':
                          viewModel.collapseAllRoutes();
                          break;
                        case 'refresh':
                          viewModel.refreshRoutesOverview();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'expand_all',
                        child: Row(
                          children: [
                            Icon(Icons.expand_more, size: 18),
                            SizedBox(width: 8),
                            Text('Expandir todo'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'collapse_all',
                        child: Row(
                          children: [
                            Icon(Icons.expand_less, size: 18),
                            SizedBox(width: 8),
                            Text('Colapsar todo'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'refresh',
                        child: Row(
                          children: [
                            Icon(Icons.refresh, size: 18),
                            SizedBox(width: 8),
                            Text('Actualizar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<RouteManagementViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Barra de filtros
              RouteFilterBar(),
              
              // Tarjeta de estadísticas
              OverviewStatsCard(),
              
              // Lista de rutas
              Expanded(
                child: _buildContent(viewModel),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.onEditRoute != null) {
            // Limpiar el estado actual y crear nueva ruta
            context.read<RouteManagementViewModel>().startNewRoute();
            widget.onEditRoute!(-1); // -1 indica nueva ruta
          }
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(RouteManagementViewModel viewModel) {
    if (viewModel.isLoadingOverview) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando rutas...'),
          ],
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar rutas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.refreshRoutesOverview(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasRoutesWithAssignments) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay rutas disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.hasVehicleFilter 
                  ? 'No se encontraron rutas para el vehículo seleccionado'
                  : 'Crea tu primera ruta para comenzar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            if (!viewModel.hasVehicleFilter)
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.onEditRoute != null) {
                    context.read<RouteManagementViewModel>().startNewRoute();
                    widget.onEditRoute!(-1);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Crear Nueva Ruta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshRoutesOverview(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.routesWithAssignments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final route = viewModel.routesWithAssignments[index];
          return RouteOverviewItem(
            route: route,
            isExpanded: viewModel.isRouteExpanded(route.route.id),
            onToggleExpansion: () => viewModel.toggleRouteExpansion(route.route.id),
            onEditRoute: widget.onEditRoute,
          );
        },
      ),
    );
  }
}