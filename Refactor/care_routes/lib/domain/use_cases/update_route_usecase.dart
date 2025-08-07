// domain/use_cases/update_route_usecase.dart
import 'package:care_routes/data/local_repository/mappers.dart';
import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/routes_dao.dart';
import '../../data/local_repository/daos/stops_dao.dart';

class UpdateRouteResult {
  final int routeId;
  final List<int> stopIds;
  final bool success;
  final String? errorMessage;

  UpdateRouteResult({
    required this.routeId,
    required this.stopIds,
    required this.success,
    this.errorMessage,
  });

  factory UpdateRouteResult.success(int routeId, List<int> stopIds) {
    return UpdateRouteResult(
      routeId: routeId,
      stopIds: stopIds,
      success: true,
    );
  }

  factory UpdateRouteResult.failure(String errorMessage) {
    return UpdateRouteResult(
      routeId: -1,
      stopIds: [],
      success: false,
      errorMessage: errorMessage,
    );
  }
}

class UpdateRouteUseCase {
  final RoutesDao _routesDao;
  final StopsDao _stopsDao;

  UpdateRouteUseCase({
    required RoutesDao routesDao,
    required StopsDao stopsDao,
  }) : _routesDao = routesDao,
        _stopsDao = stopsDao;

  Future<UpdateRouteResult> execute({
    required int routeId,
    required String routeName,
    required List<Stop> stops,
  }) async {
    try {
      // Validaciones
      if (routeName.trim().isEmpty) {
        return UpdateRouteResult.failure('El nombre de la ruta es requerido');
      }

      if (stops.length < 2) {
        return UpdateRouteResult.failure('Una ruta debe tener al menos 2 paradas');
      }

      // Verificar que la ruta existe
      final existingRoute = await _routesDao.getRouteById(routeId);
      if (existingRoute == null) {
        return UpdateRouteResult.failure('La ruta no existe');
      }

      // Crear la ruta actualizada
      final updatedRoute = Route(
        id: routeId,
        name: routeName.trim(),
        isActive: true,
      );

      // Ejecutar actualización en transacción para mantener consistencia
      final List<int> newStopIds = [];

      await _routesDao.db.transaction(() async {
        // 1. Actualizar la información de la ruta
        //CAMBIAR EL COMPANION UPDATE AL DATA CLASS DE DRIFT
        
        final updatedRows = await _routesDao.updateRouteE(updatedRoute.toCompanionUpdate());
        
        if (updatedRows == false) {
          throw Exception('No se pudo actualizar la ruta');
        }

        // 2. Eliminar todas las paradas existentes de la ruta
        await _stopsDao.deleteStopsByRouteId(routeId);

        // 3. Insertar las nuevas paradas en el orden correcto
        for (int i = 0; i < stops.length; i++) {
          final stopData = stops[i];
          final newStop = Stop(
            id: 0, // Se autogenera
            routeId: routeId,
            latitude: stopData.latitude,
            longitude: stopData.longitude,
            isActive: true,
          );

          final stopId = await _stopsDao.insertStop(newStop.toCompanionInsert());
          newStopIds.add(stopId);
        }
      });

      return UpdateRouteResult.success(routeId, newStopIds);

    } catch (e) {
      return UpdateRouteResult.failure('Error al actualizar la ruta: ${e.toString()}');
    }
  }

  // Método adicional para actualizar solo el nombre de la ruta (sin tocar paradas)
  Future<UpdateRouteResult> updateRouteNameOnly({
    required int routeId,
    required String routeName,
  }) async {
    try {
      // Validaciones
      if (routeName.trim().isEmpty) {
        return UpdateRouteResult.failure('El nombre de la ruta es requerido');
      }

      // Verificar que la ruta existe
      final existingRoute = await _routesDao.getRouteById(routeId);
      if (existingRoute == null) {
        return UpdateRouteResult.failure('La ruta no existe');
      }

      // Crear la ruta actualizada (mantiene los datos existentes)
      final updatedRoute = Route(
        id: routeId,
        name: routeName.trim(),
        isActive: existingRoute.isActive,
      );

      // Actualizar solo la ruta
      final updatedRows = await _routesDao.updateRouteE(updatedRoute.toCompanionUpdate());
      
      if (updatedRows == false) {
        return UpdateRouteResult.failure('No se pudo actualizar la ruta');
      }

      // Obtener los IDs de las paradas existentes para mantener consistencia en el resultado
      final existingStops = await _stopsDao.getStopsByRouteId(routeId);
      final existingStopIds = existingStops.map((stop) => stop.idStop).toList();

      return UpdateRouteResult.success(routeId, existingStopIds);

    } catch (e) {
      return UpdateRouteResult.failure('Error al actualizar el nombre de la ruta: ${e.toString()}');
    }
  }

  // Método adicional para actualizar el estado activo de una ruta
  Future<UpdateRouteResult> updateRouteActiveStatus({
    required int routeId,
    required bool isActive,
  }) async {
    try {
      // Verificar que la ruta existe
      final existingRouteEntity = await _routesDao.getRouteById(routeId);
      if (existingRouteEntity == null) {
        return UpdateRouteResult.failure('La ruta no existe');
      }

      final existingRoute = existingRouteEntity.toDomain();

      // Crear la ruta actualizada
      final updatedRoute = Route(
        id: routeId,
        name: existingRoute.name,
        isActive: isActive,
      );

      // Actualizar la ruta
      final updatedRows = await _routesDao.updateRouteE(updatedRoute.toCompanionUpdate());
      
      if (updatedRows == false) {
        return UpdateRouteResult.failure('No se pudo actualizar el estado de la ruta');
      }

      // Obtener los IDs de las paradas existentes
      final existingStops = await _stopsDao.getStopsByRouteId(routeId);
      final existingStopIds = existingStops.map((stop) => stop.idStop).toList();

      return UpdateRouteResult.success(routeId, existingStopIds);

    } catch (e) {
      return UpdateRouteResult.failure('Error al actualizar el estado de la ruta: ${e.toString()}');
    }
  }
}