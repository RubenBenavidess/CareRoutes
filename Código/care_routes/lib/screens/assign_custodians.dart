import 'package:flutter/material.dart';

class AssignCustodians extends StatelessWidget {
  const AssignCustodians({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Asignar Custodios",
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
              "Seleccione el vehículo y el custodio",
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w600,
                fontFamily: 'Wix Madefor Text',
              ),
            ),
            SizedBox(height: 20),
            // Add your vehicle and custodian selection widgets here
          ],
        ),
      ),
    );
  }
}