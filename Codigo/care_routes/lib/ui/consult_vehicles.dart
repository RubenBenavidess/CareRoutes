import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/usable_vehicles_controller.dart';

class ConsultVehicles extends ConsumerWidget {
  const ConsultVehicles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el StreamProvider
    final vehiclesAsync = ref.watch(usableVehiclesStreamProvider);

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
      ),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed:
                        () => ref.invalidate(usableVehiclesStreamProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('No hay conductores registrados'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0973AD),
                    child: Text(vehicle.brand[0]),
                  ),
                  title: Text('${vehicle.brand} ${vehicle.brand}'),
                  subtitle: Text('ID: ${vehicle.brand}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
