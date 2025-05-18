import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  List<NavigationRailDestination> destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.upload_file),
      label: Text('Importar'),
    ),
    NavigationRailDestination(icon: Icon(Icons.map), label: Text('Asignar')),
    NavigationRailDestination(
      icon: Icon(Icons.car_repair),
      label: Text('Consultar'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onIndexChanged,
      labelType: NavigationRailLabelType.all,
      destinations: destinations,
    );
  }
}
