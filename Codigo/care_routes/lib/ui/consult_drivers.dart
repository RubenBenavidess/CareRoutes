import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/usable_drivers_controller.dart';

class ConsultDriversWidget extends ConsumerWidget {
  const ConsultDriversWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el StreamProvider
    final driversAsync = ref.watch(usableDriversStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consulta de Conductores',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: driversAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed:
                        () => ref.invalidate(usableDriversStreamProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (drivers) {
          if (drivers.isEmpty) {
            return const Center(child: Text('No hay conductores registrados'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0973AD),
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  title: Text('${driver.firstName} ${driver.lastName}'),
                  subtitle: Text('ID: ${driver.idNumber}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
