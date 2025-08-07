import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:care_routes/presentation/themes/main_theme.dart';

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Error al inicializar CareRoutes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles del error:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(error),
                      const SizedBox(height: 16),
                      if (!kIsWeb) ...[
                        const Text(
                          'Soluciones para desktop:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text('1. sudo dnf install sqlite sqlite-devel'),
                        const Text('2. flutter clean && flutter pub get'),
                      ],
                      if (kIsWeb) ...[
                        const Text(
                          'Soluciones para web:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text('1. Verificar que sqlite3.wasm esté disponible'),
                        const Text('2. Ejecutar con flutter run -d chrome'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Recargar página en web
                    if (kIsWeb) {
                      // En web, recargar la página
                      // window.location.reload(); // No disponible directamente
                    }
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}