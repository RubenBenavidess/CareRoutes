import 'package:care_routes/domain/vehicle_with_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';  // Importante para detectar clic derecho
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'reusable_widgets/vehicle_search_select.dart';
import '../controllers/assign_routes_controller.dart';

// Proveedor para el estado del mapa
final routeMapControllerProvider = StateNotifierProvider<RouteMapController, RouteMapState>((ref) {
  return RouteMapController();
});

// Estado del mapa
class RouteMapState {
  final List<Marker> markers;
  final List<LatLng> routePoints;
  final LatLng center;
  final double zoom;
  
  RouteMapState({
    List<Marker>? markers,
    List<LatLng>? routePoints,
    LatLng? center,
    double? zoom,
  }) : 
    markers = markers ?? [],
    routePoints = routePoints ?? [],
    center = center ?? const LatLng(-0.238799, -78.530115),
    zoom = zoom ?? 12.0;
    
  RouteMapState copyWith({
    List<Marker>? markers,
    List<LatLng>? routePoints,
    LatLng? center,
    double? zoom,
  }) {
    return RouteMapState(
      markers: markers ?? this.markers,
      routePoints: routePoints ?? this.routePoints,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }
}

// Controlador del mapa
class RouteMapController extends StateNotifier<RouteMapState> {
  final MapController mapController = MapController();
  
  RouteMapController() : super(RouteMapState());
  
  Future<void> getCurrentLocation() async {
    try {
      // Solicitar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ));
      
      final newCenter = LatLng(position.latitude, position.longitude);
      
      mapController.move(newCenter, 14.0);
      state = state.copyWith(center: newCenter, zoom: 14.0);
    } catch (e) {
      debugPrint("Error al obtener ubicación: $e");
    }
  }
  
  void addMarker(LatLng position) {
    final markerId = state.markers.length.toString();
    
    final marker = Marker(
      width: 40.0,
      height: 40.0,
      point: position,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            // Detectar clic derecho (botón secundario)
            if (event.buttons == kSecondaryMouseButton) {
              removeMarker(markerId);
            }
          },
          child: GestureDetector(
            onLongPress: () => removeMarker(markerId), // Mantener para móvil
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 10,
                    child: Text(
                      (state.markers.length + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    final newMarkers = List<Marker>.from(state.markers);
    newMarkers.add(marker);
    
    final newRoutePoints = List<LatLng>.from(state.routePoints);
    newRoutePoints.add(position);
    
    state = state.copyWith(
      markers: newMarkers,
      routePoints: newRoutePoints,
    );
  }
  
  void removeMarker(String id) {
    final index = int.parse(id);
    if (index < state.markers.length) {
      final newMarkers = List<Marker>.from(state.markers);
      newMarkers.removeAt(index);
      
      final newRoutePoints = List<LatLng>.from(state.routePoints);
      newRoutePoints.removeAt(index);
      
      // Actualiza los IDs de los marcadores
      final updatedMarkers = newMarkers.asMap().entries.map((entry) {
        final i = entry.key;
        final marker = entry.value;
        return Marker(
          width: marker.width,
          height: marker.height,
          point: marker.point,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Listener(
              onPointerDown: (PointerDownEvent event) {
                if (event.buttons == kSecondaryMouseButton) {
                  removeMarker(i.toString());
                }
              },
              child: GestureDetector(
                onLongPress: () => removeMarker(i.toString()),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 10,
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList();
      
      state = state.copyWith(
        markers: updatedMarkers,
        routePoints: newRoutePoints,
      );
    }
  }
  
  void clearRoute() {
    state = RouteMapState(center: state.center, zoom: state.zoom);
  }
  
  // Método para obtener los datos de la ruta para guardar en la base de datos
  Map<String, dynamic> getRouteData() {
    return {
      'date': DateTime.now(),
      'stops': state.routePoints.map((point) => {
        'latitude': point.latitude,
        'longitude': point.longitude,
      }).toList(),
    };
  }
}

class AssignRoutes extends ConsumerWidget {
  const AssignRoutes({super.key});
  // Método para mostrar el selector de fecha
  Future<void> _pickDateForVehicle(
    BuildContext context,
    WidgetRef ref,
    VehicleWithDriver v,
    ) async {
    final controller = ref.read(assignRoutesControllerProvider.notifier);
    final initial  = ref.read(assignRoutesControllerProvider)
                  .dates[v.idVehicle] ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate : DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) controller.setDate(v, picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double _kPanelMinWidth = 360;

    final state = ref.watch(assignRoutesControllerProvider);
    final controller = ref.read(assignRoutesControllerProvider.notifier);
    
    final mapState = ref.watch(routeMapControllerProvider);
    final mapController = ref.read(routeMapControllerProvider.notifier);

    // Botón de guardar con el color e icono especificados
    final saveButton = ElevatedButton.icon(
      icon: const Icon(Icons.save, color: Colors.white),
      label: const Text(
        'Asignar', 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0973AD),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        final routeData = mapController.getRouteData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ruta guardada con ${mapState.markers.length} paradas')),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Rutas', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF0973ad))),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => mapController.getCurrentLocation(),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => mapController.clearRoute(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          
          // Widget del mapa con bordes redondeados y padding - sin líneas de polyline
          final mapWidget = Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SizedBox(
                height: isDesktop ? double.infinity : 300,
                child: FlutterMap(
                  mapController: mapController.mapController,
                  options: MapOptions(
                    initialCenter: mapState.center,
                    initialZoom: mapState.zoom,
                    onTap: (tapPosition, point) => mapController.addMarker(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: mapState.markers),
                    // Se eliminó PolylineLayer ya que no podemos mostrar rutas de carreteras
                  ],
                ),
              ),
            ),
          );
          
          // Widget con el panel de control (scrolleable)
          final controlPanelWidget = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fila con instrucciones y número de paradas (mitad de ancho cada uno)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instrucciones para usar el mapa (mitad del ancho)
                      Expanded(
                        flex: 3,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Cómo crear una ruta:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text('1. Toca el mapa para añadir paradas'),
                                Text('2. Clic derecho para eliminar (desktop)'),
                                Text('3. Mantén presionado para eliminar (móvil)'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Resumen de paradas (mitad del ancho)
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Paradas en la ruta:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.place, color: Colors.blue, size: 28),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${mapState.markers.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // VehicleSearchSelect
                  const Text(
                    'Asignar vehículos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  VehicleSearchSelect(
                    onSelected: controller.toggleVehicle,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de vehículos asignados
                  if (state.selected.isNotEmpty) ...[
                    const Text(
                      'Vehículos asignados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...state.selected.map((v) {
                      final date = state.dates[v.idVehicle];
                      final dateLabel = date == null
                          ? 'Sin fecha'
                          : '${date.day}/${date.month}/${date.year}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.directions_car, color: Colors.blue),
                          title: Text(v.licensePlate),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Conductor: ${v.driverName}'),
                              Text('Fecha asignada: $dateLabel'),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                tooltip: 'Elegir fecha',
                                onPressed: () =>
                                    _pickDateForVehicle(context, ref, v),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    controller.toggleVehicle(v),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Botón de guardar
                  saveButton,
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
          
          // Layout responsivo
          if (isDesktop) {
            // Ancho que le tocaría al panel según el ratio 1:2 (panel : mapa)
            final double proposedPanelWidth = constraints.maxWidth / 3; //  1 / (1+2)
            final double panelWidth =
                proposedPanelWidth < _kPanelMinWidth ? _kPanelMinWidth : proposedPanelWidth;

            return Row(
              children: [
                // Panel de control (ancho fijo -pero mínimo-)
                SizedBox(
                  width: panelWidth,
                  child: controlPanelWidget,
                ),

                // El mapa ocupa todo lo que queda
                Expanded(child: mapWidget),
              ],
            );
          } else {
            return Column(
              children: [
                mapWidget,
                Expanded(child: controlPanelWidget),
              ],
            );
          }
        },
      ),
    );
  }
}