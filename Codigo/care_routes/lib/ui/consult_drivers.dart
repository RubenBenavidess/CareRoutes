import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/usable_drivers_controller.dart';

class ConsultDriversWidget extends ConsumerWidget{

  const ConsultDriversWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final usableDriverState = ref.watch(usableDriverNotifierProvider);
    final usableDrivercontroller = ref.read(usableDriverNotifierProvider.notifier);

    usableDrivercontroller.initService(ref);
    usableDrivercontroller.loadUsableDrivers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Conductores', style: TextStyle(
          fontSize: 24,
          color: Color(0xFF0973AD),
          fontWeight: FontWeight.bold,
        )),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Lista de conductores

          if (usableDriverState.isEmpty) ...[
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child:
                Text('No hay conductores registrados.', style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade200,
                    fontWeight: FontWeight.bold,
                )),
            )
          ] else ...[
            Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: usableDriverState.length,
              itemBuilder: (ctx, i) {
                final usableDriver = usableDriverState[i];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Nombre y Apellido
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${usableDriver.firstName} ${usableDriver.lastName}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(usableDriver.idNumber),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Divider(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          ],
        ],
      ),
    );
  }
}
