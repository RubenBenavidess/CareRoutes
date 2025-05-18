import 'package:flutter/material.dart';

class CreateRoutes extends StatelessWidget {
  const CreateRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crear Rutas",
          style: TextStyle(
            fontSize: 40,
            color: const Color(0xFF0973ad),
            fontWeight: FontWeight.bold,
            fontFamily: 'Wix Madefor Text',
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Seleccione el vehículo y la ruta",
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w600,
                fontFamily: 'Wix Madefor Text',
              ),
            ),
            SizedBox(height: 20),
            // Add your vehicle and route selection widgets here
          ],
        ),
      ),
    );
  }
}