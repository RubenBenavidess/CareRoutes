// ui/consult_vehicles.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/usable_vehicles_controller.dart';

class ConsultVehicles extends ConsumerStatefulWidget {
  const ConsultVehicles({super.key});

  @override
  ConsumerState<ConsultVehicles> createState() => _ConsultVehiclesState();
}

class _ConsultVehiclesState extends ConsumerState<ConsultVehicles> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(filteredVehiclesProvider);

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
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
            onPressed: () {
              ref.invalidate(usableVehiclesStreamProvider);
            },
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
                      hintText: 'Buscar por placa, marca o modelo...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(vehicleSearchQueryProvider.notifier)
                                      .state = '';
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
                    onChanged: (value) {
                      ref.read(vehicleSearchQueryProvider.notifier).state =
                          value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          // Lista de vehículos
          Expanded(
            child: vehiclesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () =>
                                  ref.invalidate(usableVehiclesStreamProvider),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isNotEmpty
                              ? Icons.search_off
                              : Icons.directions_car_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No se encontraron vehículos con "${_searchController.text}"'
                              : 'No hay vehículos registrados',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(usableVehiclesStreamProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
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
                                    color: const Color(
                                      0xFF0973AD,
                                    ).withOpacity(0.1),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                              vehicle.status.name.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            backgroundColor: _getStatusColor(
                                              vehicle.status.name,
                                            ),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${vehicle.brand} ${vehicle.model}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (vehicle.year != 0)
                                        Text(
                                          'Año: ${vehicle.year} • ${vehicle.mileage} km',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green.shade100;
      case 'assigned':
        return const Color.fromARGB(255, 178, 214, 255);
      case 'maintenance':
        return const Color.fromARGB(255, 255, 250, 205);
      case 'outOfService':
        return const Color.fromARGB(255, 255, 182, 193);
      default:
        return Colors.grey.shade100;
    }
  }

  void _showVehicleDetails(BuildContext context, dynamic vehicle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Vehículo ${vehicle.licensePlate}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Marca', vehicle.brand),
                _detailRow('Modelo', vehicle.model),
                _detailRow('Año', vehicle.year.toString()),
                _detailRow('Kilometraje', '${vehicle.mileage} km'),
                _detailRow('Estado', vehicle.status),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
