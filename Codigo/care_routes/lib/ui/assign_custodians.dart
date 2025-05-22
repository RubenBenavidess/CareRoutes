import 'package:flutter/material.dart';

/// Enum para el estado del vehículo
enum VehicleStatus {
  available,
  assigned,
  maintenance,
  outOfService,
}

/// Modelo mejorado de Vehicle
class Vehicle {
  final int id;
  final String licensePlate;
  final String brand;
  final String model;
  final int mileage;
  final int year;
  int? driverId;
  VehicleStatus status;

  Vehicle({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.mileage,
    required this.year,
    this.driverId,
    this.status = VehicleStatus.available,
  });

  String get statusText {
    switch (status) {
      case VehicleStatus.available:
        return 'Disponible';
      case VehicleStatus.assigned:
        return 'Asignado';
      case VehicleStatus.maintenance:
        return 'En mantenimiento';
      case VehicleStatus.outOfService:
        return 'Fuera de servicio';
    }
  }

  Color get statusColor {
    switch (status) {
      case VehicleStatus.available:
        return Colors.green;
      case VehicleStatus.assigned:
        return Colors.blue;
      case VehicleStatus.maintenance:
        return Colors.orange;
      case VehicleStatus.outOfService:
        return Colors.red;
    }
  }
}

/// Modelo mejorado de Driver
class Driver {
  final int id;
  final String firstName;
  final String lastName;
  final String cedula;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cedula,
  });

  String get fullName => '$firstName $lastName';
}

class AssignCustodians extends StatefulWidget {
  const AssignCustodians({super.key});

  @override
  _AssignCustodiansState createState() => _AssignCustodiansState();
}

class _AssignCustodiansState extends State<AssignCustodians> {
  // Datos de conductores
  final List<Driver> _drivers = [
    Driver(id: 4, firstName: 'Javier', lastName: 'Yuncan', cedula: '1725694836'),
    Driver(id: 5, firstName: 'María', lastName: 'Pérez', cedula: '1104567890'),
    Driver(id: 6, firstName: 'Carlos', lastName: 'Torres', cedula: '921345678'),
    Driver(id: 7, firstName: 'Ana', lastName: 'Morales', cedula: '1809876543'),
    Driver(id: 8, firstName: 'Luis', lastName: 'Espinosa', cedula: '1712345679'),
    Driver(id: 9, firstName: 'Diego', lastName: 'Romero', cedula: '923456781'),
    Driver(id: 10, firstName: 'Sofía', lastName: 'Herrera', cedula: '109876542'),
    Driver(id: 11, firstName: 'Pedro', lastName: 'Castillo', cedula: '1501234987'),
    Driver(id: 12, firstName: 'Gabriela', lastName: 'Flores', cedula: '609871234'),
    Driver(id: 13, firstName: 'Juan', lastName: 'Mendoza', cedula: '1754321098'),
    Driver(id: 14, firstName: 'Daniela', lastName: 'Vega', cedula: '1205432198'),
    Driver(id: 15, firstName: 'Marco', lastName: 'Salazar', cedula: '1009875632'),
    Driver(id: 16, firstName: 'Elena', lastName: 'Ríos', cedula: '1407654321'),
    Driver(id: 17, firstName: 'Ricardo', lastName: 'Paredes', cedula: '1308765432'),
    Driver(id: 18, firstName: 'Valeria', lastName: 'Gallo', cedula: '1906543217'),
    Driver(id: 19, firstName: 'Miguel', lastName: 'Campos', cedula: '1612349875'),
  ];

  // Datos de vehículos
  final List<Vehicle> _vehicles = [
    Vehicle(id: 1, licensePlate: 'PFC-3658', brand: 'Suzuki', model: 'SUV', mileage: 65112, year: 2018, driverId: 4, status: VehicleStatus.available),
    Vehicle(id: 2, licensePlate: 'PBC-2345', brand: 'Toyota', model: 'Sedán', mileage: 4714, year: 2015, driverId: 5, status: VehicleStatus.available),
    Vehicle(id: 3, licensePlate: 'GHA-8765', brand: 'Hyundai', model: 'Hatchback', mileage: 69057, year: 2015, driverId: 6, status: VehicleStatus.available),
    Vehicle(id: 4, licensePlate: 'OBD-4321', brand: 'Nissan', model: 'Pickup', mileage: 74635, year: 2019, driverId: 7, status: VehicleStatus.available),
    Vehicle(id: 5, licensePlate: 'HFT-5678', brand: 'Chevrolet', model: 'SUV', mileage: 30764, year: 2014, driverId: 8, status: VehicleStatus.available),
    Vehicle(id: 6, licensePlate: 'LKU-7890', brand: 'Kia', model: 'Minivan', mileage: 79745, year: 2014, driverId: 9, status: VehicleStatus.available),
    Vehicle(id: 7, licensePlate: 'QWE-6543', brand: 'Ford', model: 'Pickup', mileage: 53950, year: 2011, driverId: 10, status: VehicleStatus.available),
    Vehicle(id: 8, licensePlate: 'XYZ-3210', brand: 'Mazda', model: 'Sedán', mileage: 8297, year: 2011, driverId: 11, status: VehicleStatus.available),
    Vehicle(id: 9, licensePlate: 'JKL-0987', brand: 'Honda', model: 'Crossover', mileage: 87020, year: 2010, driverId: 12, status: VehicleStatus.available),
    Vehicle(id: 10, licensePlate: 'WRN-1357', brand: 'Jeep', model: 'SUV', mileage: 65038, year: 2009, driverId: 13, status: VehicleStatus.available),
    Vehicle(id: 11, licensePlate: 'ZXC-7531', brand: 'Renault', model: 'Hatchback', mileage: 17272, year: 2012, driverId: 14, status: VehicleStatus.available),
    Vehicle(id: 12, licensePlate: 'VBN-2468', brand: 'Mitsubishi', model: 'SUV', mileage: 26503, year: 2009, driverId: 15, status: VehicleStatus.available),
    Vehicle(id: 13, licensePlate: 'RTY-8642', brand: 'Audi', model: 'Sedán', mileage: 90382, year: 2013, driverId: 16, status: VehicleStatus.available),
    Vehicle(id: 14, licensePlate: 'MNB-9753', brand: 'Volkswagen', model: 'Hatchback', mileage: 99692, year: 2009, driverId: 17, status: VehicleStatus.available),
    Vehicle(id: 15, licensePlate: 'ASD-1597', brand: 'BMW', model: 'Sedán', mileage: 24448, year: 2011, driverId: 18, status: VehicleStatus.available),
    Vehicle(id: 16, licensePlate: 'FGH-4862', brand: 'Mercedes-Benz', model: 'SUV', mileage: 34490, year: 2016, driverId: 19, status: VehicleStatus.available),
  ];

  Vehicle? _selectedVehicle;
  Driver? _selectedDriver;
  String _searchQuery = '';
  VehicleStatus? _filterStatus;

  /// Conductores libres
  List<Driver> get _availableDrivers {
    final assignedIds = _vehicles.where((v) => v.driverId != null).map((v) => v.driverId!).toSet();
    return _drivers.where((d) => !assignedIds.contains(d.id)).toList()..sort((a,b) => a.fullName.compareTo(b.fullName));
  }

  /// Vehículos filtrados
  List<Vehicle> get _filteredVehicles {
    return _vehicles.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.licensePlate.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.model.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == null || v.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _assignDriver() {
    if (_selectedVehicle == null || _selectedDriver == null) return;
    setState(() {
      _selectedVehicle!.driverId = _selectedDriver!.id;
      _selectedVehicle!.status = VehicleStatus.assigned;
      _selectedVehicle = null;
      _selectedDriver = null;
    });
    _showSuccessDialog();
  }

  void _unassignDriver(Vehicle vehicle) {
    final driver = _drivers.firstWhere((d) => d.id == vehicle.driverId);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Desasignar Custodio'),
        content: Text('¿Seguro que quieres desasignar a ${driver.fullName} del vehículo ${vehicle.licensePlate}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                vehicle.driverId = null;
                vehicle.status = VehicleStatus.available;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Custodio desasignado exitosamente')),
              );
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: Text('¡Asignación Exitosa!'),
        content: Text('El custodio ha sido asignado correctamente al vehículo.'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Continuar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Custodios', style: TextStyle(
          fontSize: 24,
          color: Color(0xFF0973AD),
          fontWeight: FontWeight.bold,
        )),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Búsqueda y filtro
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por placa o marca...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Filtrar por estado:', style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<VehicleStatus?>(
                        isExpanded: true,
                        value: _filterStatus,
                        items: [
                          DropdownMenuItem(value: null, child: Text('Todos')),
                          ...VehicleStatus.values.map((s) =>
                              DropdownMenuItem(value: s, child: Text(s.toString().split('.').last))
                          ),
                        ],
                        onChanged: (s) => setState(() => _filterStatus = s),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de vehículos
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredVehicles.length,
              itemBuilder: (ctx, i) {
                final vehicle = _filteredVehicles[i];
                final driver = vehicle.driverId != null
                    ? _drivers.firstWhere((d) => d.id == vehicle.driverId)
                    : null;

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: placa + marca/año + acciones
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vehicle.licensePlate,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text('${vehicle.brand} (${vehicle.year})'),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: vehicle.statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: vehicle.statusColor),
                                    ),
                                    child: Text(
                                      vehicle.statusText,
                                      style: TextStyle(
                                        color: vehicle.statusColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (vehicle.status == VehicleStatus.available)
                              ElevatedButton.icon(
                                icon: Icon(Icons.person_add, size: 16),
                                label: Text('Asignar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () => _showAssignDialog(vehicle),
                              )
                            else if (vehicle.status == VehicleStatus.assigned)
                              ElevatedButton.icon(
                                icon: Icon(Icons.person_remove, size: 16),
                                label: Text('Desasignar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () => _unassignDriver(vehicle),
                              ),
                          ],
                        ),

                        // Datos del conductor asignado
                        if (driver != null) ...[
                          Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driver.fullName,
                                        style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('Cédula: ${driver.cedula}',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text('Asignar Custodio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vehículo: ${vehicle.licensePlate}'),
              SizedBox(height: 16),
              if (_availableDrivers.isEmpty)
                Text('No hay custodios disponibles.')
              else
                ..._availableDrivers.map((d) => RadioListTile<Driver>(
                  value: d,
                  groupValue: _selectedDriver,
                  onChanged: (val) => setStateDialog(() => _selectedDriver = val),
                  title: Text(d.fullName),
                  subtitle: Text('Cédula: ${d.cedula}'),
                )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _selectedDriver = null;
                Navigator.pop(ctx);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _selectedDriver == null
                  ? null
                  : () {
                setState(() {
                  vehicle.driverId = _selectedDriver!.id;
                  vehicle.status = VehicleStatus.assigned;
                  _selectedDriver = null;
                });
                Navigator.pop(ctx);
                _showSuccessDialog();
              },
              child: Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }
}
