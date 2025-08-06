import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateToImportData() => setSelectedIndex(0);
  void navigateToAssignCustodians() => setSelectedIndex(1);
  void navigateToConsultVehicles() => setSelectedIndex(2);
  void navigateToAssignRoutes() => setSelectedIndex(3);
  void navigateToConsultRoutes() => setSelectedIndex(4);
  void navigateToConsultDrivers() => setSelectedIndex(5);
  void navigateToRegisterMaintenance() => setSelectedIndex(6);
  void navigateToConsultMaintenance() => setSelectedIndex(7);
  void navigateToGenerateReports() => setSelectedIndex(8);
  void navigateToSettings() => setSelectedIndex(9);

  String get currentPageName {
    switch (_selectedIndex) {
      case 0: return 'Importar Datos';
      case 1: return 'Asignar Custodios';
      case 2: return 'Consultar Vehículos';
      case 3: return 'Asignar Rutas';
      case 4: return 'Ver Rutas';
      case 5: return 'Consultar Conductores';
      case 6: return 'Registrar Mantenimientos';
      case 7: return 'Ver Mantenimientos';
      case 8: return 'Generar Reportes';
      case 9: return 'Configuración';
      default: return 'Desconocido';
    }
  }
}