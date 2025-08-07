// route_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../domain/use_cases/search_route_usecase.dart';
import '../viewmodels/route_management_viewmodel.dart';
import '../../../domain/entities/domain_entities.dart';
import 'widgets/vehicle_selector_widget.dart';
import 'widgets/assignments_list_widget.dart';
import 'widgets/route_search_widget.dart';

class RouteManagementScreen extends StatefulWidget {
  const RouteManagementScreen({super.key});

  @override
  State<RouteManagementScreen> createState() => _RouteManagementScreenState();
}

class _RouteManagementScreenState extends State<RouteManagementScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  LatLng? _currentLocation;
  List<Marker> _markers = [];
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    final viewModel = context.read<RouteManagementViewModel>();
    
    _routeNameController.addListener(() {
      viewModel.updateRouteName(_routeNameController.text);
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isMapReady = true;
        });
        
        // Línea 60 corregida - removido null check innecesario
        _mapController.move(_currentLocation!, 15.0);
      } else {
        // Ubicación por defecto si no hay permisos
        setState(() {
          _currentLocation = LatLng(-0.2295, -78.5249);
          _isMapReady = true;
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = LatLng(-0.2295, -78.5249);
        _isMapReady = true;
      });
    }
  }

  void _updateMarkers() {
    final viewModel = context.read<RouteManagementViewModel>();
    _markers = viewModel.stops.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;
      
      // Líneas 84 y 88 corregidas
      return Marker(
        point: LatLng(stop.latitude, stop.longitude),
        child: GestureDetector(
          onTap: () => _showStopOptions(index),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    final viewModel = context.read<RouteManagementViewModel>();
    final newStop = Stop(
      id: -1,   // ID temporal hasta guardar en BD
      routeId: viewModel.currentRouteId ?? -1, // Arreglado para evitar null
      latitude: point.latitude,
      longitude: point.longitude,
      isActive: true,
    );
    
    viewModel.addStop(newStop);
    setState(() {
      _updateMarkers();
    });
  }

  void _showStopOptions(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parada ${index + 1}'),
        content: const Text('¿Qué deseas hacer con esta parada?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<RouteManagementViewModel>().removeStop(index);
              setState(() {
                _updateMarkers();
              });
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Rutas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<RouteManagementViewModel>(
        builder: (context, viewModel, child) {
          _updateMarkers();
          
          return Column(
            children: [
              // Barra de búsqueda
              RouteSearchWidget(
                controller: _searchController,
                onRouteSelected: (route) {
                  viewModel.loadRoute(route.route.id);
                  _loadRouteOnMap(route);
                },
              ),
              
              // Contenido principal
              Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Importante
                children: [
                  // Mapa
                  Expanded(
                    flex: 2,
                    child: _buildMap(viewModel),
                  ),
                  
                  // Panel lateral con altura completa disponible
                  Container(
                    width: 400, // Aumenté de 400 a 450
                    height: double.infinity, // Usa toda la altura disponible
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: const Border(
                        left: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: _buildSidePanel(viewModel),
                  ),
                ],
              ),
            ),
              
              // Barra de estado y acciones
              _buildBottomBar(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(RouteManagementViewModel viewModel) {
    if (!_isMapReady || _currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        // Líneas 220-221 corregidas
        initialCenter: _currentLocation!,
        initialZoom: 15.0,
        onTap: _onMapTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: _markers),
        if (_currentLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLocation!,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSidePanel(RouteManagementViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Información de la ruta
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de la Ruta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _routeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la ruta',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de paradas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paradas (${viewModel.stopsCount})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (viewModel.stops.isEmpty)
                    const Text('Toca en el mapa para agregar paradas')
                  else
                    ...viewModel.stops.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stop = entry.value;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Parada ${index + 1}'),
                        subtitle: Text(
                          'Lat: ${stop.latitude.toStringAsFixed(6)}\n'
                          'Lng: ${stop.longitude.toStringAsFixed(6)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            viewModel.removeStop(index);
                            setState(() {
                              _updateMarkers();
                            });
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Selector de vehículo
          VehicleSelectorWidget(),
          
          const SizedBox(height: 16),
          
          // Lista de asignaciones
          AssignmentsListWidget(),
          
          const SizedBox(height: 16),
          
          // Botones de acción
          _buildActionButtons(viewModel),
        ],
      ),
    );
  }

  Widget _buildActionButtons(RouteManagementViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: viewModel.canCreateRoute && !viewModel.isLoading
              ? () => viewModel.createRoute()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: viewModel.isCreatingRoute
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('Guardar Ruta'),
        ),
        
        const SizedBox(height: 8),
        
        ElevatedButton(
          onPressed: viewModel.canAssignVehicle && !viewModel.isLoading
              ? () => viewModel.assignVehicleToRoute()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: viewModel.isAssigningVehicle
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('Asignar Vehículo'),
        ),
        
        const SizedBox(height: 8),
        
        OutlinedButton(
          onPressed: () {
            viewModel.clearCurrentRoute();
            _routeNameController.clear();
            setState(() {
              _markers.clear();
            });
          },
          child: const Text('Limpiar Todo'),
        ),
      ],
    );
  }

  Widget _buildBottomBar(RouteManagementViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.grey)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(viewModel.state),
            color: _getStatusColor(viewModel.state),
          ),
          const SizedBox(width: 8),
          Text(
            viewModel.stateDisplayName,
            style: TextStyle(
              color: _getStatusColor(viewModel.state),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (viewModel.hasError) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                viewModel.errorMessage ?? '',
                style: const TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getStatusIcon(RouteManagementState state) {
    switch (state) {
      case RouteManagementState.loading:
      case RouteManagementState.creatingRoute:
      case RouteManagementState.assigningVehicle:
      case RouteManagementState.searching:
        return Icons.hourglass_empty;
      case RouteManagementState.success:
        return Icons.check_circle;
      case RouteManagementState.error:
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(RouteManagementState state) {
    switch (state) {
      case RouteManagementState.success:
        return Colors.green;
      case RouteManagementState.error:
        return Colors.red;
      case RouteManagementState.loading:
      case RouteManagementState.creatingRoute:
      case RouteManagementState.assigningVehicle:
      case RouteManagementState.searching:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _loadRouteOnMap(RouteWithStops route) {
    if (route.stops.isNotEmpty) {
      // Línea 482 corregida - LatLngBounds necesita argumentos
      LatLng southWest = LatLng(
        route.stops.map((s) => s.latitude).reduce((a, b) => a < b ? a : b),
        route.stops.map((s) => s.longitude).reduce((a, b) => a < b ? a : b),
      );
      LatLng northEast = LatLng(
        route.stops.map((s) => s.latitude).reduce((a, b) => a > b ? a : b),
        route.stops.map((s) => s.longitude).reduce((a, b) => a > b ? a : b),
      );
      
      final bounds = LatLngBounds(southWest, northEast);
      
      _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
    }
    
    setState(() {
      _updateMarkers();
    });
    
    // Actualizar los controladores de texto
    _routeNameController.text = route.route.name;
  }

  @override
  void dispose() {
    _routeNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}