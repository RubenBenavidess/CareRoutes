import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reusable_widgets/vehicle_search_select.dart'; 

import '../controllers/assign_routes_controller.dart';        // tu buscador
import '../domain/vehicle_with_driver.dart';

class AssignRoutes extends ConsumerWidget {
  const AssignRoutes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1️⃣  Leemos el estado y el controlador
    final state = ref.watch(assignRoutesControllerProvider);
    final controller = ref.read(assignRoutesControllerProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: VehicleSearchSelect(
              onSelected: controller.toggleVehicle, // ← recibe VehicleWithDriver
            ),
          ),
          // — Buscador reactivo —
          
          const Divider(),

          // — Lista de vehículos elegidos —
          Expanded(
            child: ListView.builder(
              itemCount: state.selected.length,
              itemBuilder: (_, i) {
                final v = state.selected[i];
                return ListTile(
                  title: Text('${v.licensePlate} — ${v.driverName}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.toggleVehicle(v),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

