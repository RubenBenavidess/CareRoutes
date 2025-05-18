import 'package:flutter/material.dart';
import '../themes/buttom_style.dart';

class Importvehicles extends StatelessWidget {
  const Importvehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Importar Datos",
          style: TextStyle(
            fontSize: 40,
            color: const Color(0x000973ad),
            fontWeight: FontWeight.bold,
            fontFamily: 'Wix Madefor Text',
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Cargue los archivos CSV (Excel)",
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w600,
                fontFamily: 'Wix Madefor Text',
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 120,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF000000), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.drive_folder_upload),
                    Text("Arrastre y suelte el archivo aquí"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ConfirmButtonStyle.elevated,
                    onPressed: () {},
                    child: Text('Cargar'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: CancelButtonStyle.elevated,
                    onPressed: () {},
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
