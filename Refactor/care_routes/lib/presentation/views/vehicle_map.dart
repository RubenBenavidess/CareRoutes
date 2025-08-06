// presentation/views/vehicle_map_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../viewmodels/vehicle_location_viewmodel.dart';
import '../../domain/entities/current_vehicle_location.dart';
import '../../domain/entities/vehicle.dart';

class VehicleMapView extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleMapView({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleMapView> createState() => _VehicleMapViewState();
}

class _VehicleMapViewState extends State<VehicleMapView> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleLocationViewModel>().initializeWithVehicle(widget.vehicle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubicación - ${widget.vehicle.licensePlate}',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF0973AD),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0973AD)),
        actions: [
          Consumer<VehicleLocationViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: Icon(
                  viewModel.isAutoUpdateEnabled ? Icons.pause : Icons.play_arrow,
                  color: const Color(0xFF0973AD),
                ),
                onPressed: viewModel.hasGps ? () => viewModel.toggleAutoUpdate() : null,
                tooltip: viewModel.isAutoUpdateEnabled 
                    ? 'Pausar actualizaciones'
                    : 'Reanudar actualizaciones',
              );
            },
          ),
          Consumer<VehicleLocationViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF0973AD)),
                onPressed: viewModel.isLoading ? null : () => viewModel.refreshAll(),
                tooltip: 'Actualizar ubicación',
              );
            },
          ),
        ],
      ),
      body: Consumer<VehicleLocationViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Panel de información del vehículo
              _buildVehicleInfoPanel(viewModel),
              
              // Mapa o estado de carga/error
              Expanded(
                child: _buildMapContent(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVehicleInfoPanel(VehicleLocationViewModel viewModel) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Información del vehículo
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0973AD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: Color(0xFF0973AD),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.vehicleInfo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusRow(viewModel),
                  ],
                ),
              ),
            ],
          ),
          
          // Información de ubicación si está disponible
          if (viewModel.hasLocation) ...[
            const SizedBox(height: 12),
            _buildLocationInfo(viewModel.currentLocation!),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(VehicleLocationViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Obteniendo ubicación...', style: TextStyle(fontSize: 12)),
        ],
      );
    }

    if (!viewModel.hasGps) {
      return Row(
        children: [
          Icon(Icons.gps_off, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 4),
          Text(
            'Sin GPS asignado',
            style: TextStyle(color: Colors.red.shade600, fontSize: 12),
          ),
        ],
      );
    }

    if (!viewModel.isGpsOnline) {
      return Row(
        children: [
          Icon(Icons.signal_wifi_off, color: Colors.orange.shade600, size: 16),
          const SizedBox(width: 4),
          Text(
            'GPS desconectado',
            style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(Icons.gps_fixed, color: Colors.green.shade600, size: 16),
        const SizedBox(width: 4),
        Text(
          'GPS conectado',
          style: TextStyle(color: Colors.green.shade600, fontSize: 12),
        ),
        const SizedBox(width: 12),
        if (viewModel.isAutoUpdateEnabled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Auto-actualización',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationInfo(CurrentVehicleLocation location) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF0973AD), size: 18),
              const SizedBox(width: 8),
              Text(
                'Última ubicación',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              Text(
                _formatTimestamp(location.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(Icons.speed, location.speedText),
              _buildInfoChip(Icons.my_location, location.accuracyText),
              _buildInfoChip(
                location.isRecentLocation ? Icons.update : Icons.schedule,
                location.isRecentLocation ? 'Actualizado' : 'Desactualizado',
                color: location.isRecentLocation ? Colors.green : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.blue),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color ?? Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent(VehicleLocationViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando ubicación del vehículo...'),
          ],
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${viewModel.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.refreshAll(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasGps) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gps_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Este vehículo no tiene un\ndispositivo GPS asignado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasLocation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_searching, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No se pudo obtener la ubicación\ndel vehículo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadCurrentLocation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0973AD),
              ),
              child: const Text('Intentar de nuevo', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    // Mostrar el mapa con la ubicación
    return _buildMap(viewModel.currentLocation!);
  }

  Widget _buildMap(CurrentVehicleLocation location) {
    final vehiclePosition = LatLng(location.latitude, location.longitude);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: vehiclePosition,
        initialZoom: 15.0,
        minZoom: 5.0,
        maxZoom: 18.0,
      ),
      children: [
        // Capa del mapa base (OpenStreetMap)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.care_routes',
        ),
        
        // Marcador del vehículo
        MarkerLayer(
          markers: [
            Marker(
              point: vehiclePosition,
              width: 60,
              height: 60,
              child: GestureDetector(
                onTap: () => _showLocationDetails(location),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0973AD),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Botones de control del mapa
        Positioned(
          right: 16,
          bottom: 80,
          child: Column(
            children: [
              FloatingActionButton(
                mini: true,
                heroTag: "zoom_in",
                backgroundColor: Colors.white,
                onPressed: () => _mapController.move(
                  _mapController.camera.center,
                  _mapController.camera.zoom + 1,
                ),
                child: const Icon(Icons.add, color: Color(0xFF0973AD)),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                heroTag: "zoom_out",
                backgroundColor: Colors.white,
                onPressed: () => _mapController.move(
                  _mapController.camera.center,
                  _mapController.camera.zoom - 1,
                ),
                child: const Icon(Icons.remove, color: Color(0xFF0973AD)),
              ),
            ],
          ),
        ),
        
        // Botón para centrar en el vehículo
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            heroTag: "center_vehicle",
            backgroundColor: const Color(0xFF0973AD),
            onPressed: () => _centerOnVehicle(vehiclePosition),
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _centerOnVehicle(LatLng position) {
    _mapController.move(position, 15.0);
  }

  void _showLocationDetails(CurrentVehicleLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de Ubicación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Vehículo', location.licensePlate),
            _buildDetailRow('Coordenadas', location.coordinates),
            _buildDetailRow('Velocidad', location.speedText),
            _buildDetailRow('Precisión', location.accuracyText),
            _buildDetailRow('Última actualización', _formatTimestamp(location.timestamp)),
            _buildDetailRow('Dispositivo GPS', location.gpsDeviceId),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}