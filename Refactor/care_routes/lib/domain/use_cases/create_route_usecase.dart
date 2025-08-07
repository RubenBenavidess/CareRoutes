// create_route_usecase.dart
import 'package:care_routes/data/local_repository/mappers.dart';

import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/routes_dao.dart';
import '../../data/local_repository/daos/stops_dao.dart';

class CreateRouteResult {
  final int routeId;
  final List<int> stopIds;
  final bool success;
  final String? errorMessage;

  CreateRouteResult({
    required this.routeId,
    required this.stopIds,
    required this.success,
    this.errorMessage,
  });

  factory CreateRouteResult.success(int routeId, List<int> stopIds) {
    return CreateRouteResult(
      routeId: routeId,
      stopIds: stopIds,
      success: true,
    );
  }

  factory CreateRouteResult.failure(String errorMessage) {
    return CreateRouteResult(
      routeId: -1,
      stopIds: [],
      success: false,
      errorMessage: errorMessage,
    );
  }
}

class CreateRouteUseCase {
  final RoutesDao _routesDao;
  final StopsDao _stopsDao;

  CreateRouteUseCase({
    required RoutesDao routesDao,
    required StopsDao stopsDao,
  }) : _routesDao = routesDao,
  _stopsDao = stopsDao;

  Future<CreateRouteResult> execute({
    required String routeName,
    required List<Stop> stops,
  }) async {
    try {
      // Validaciones
      if (routeName.trim().isEmpty) {
        return CreateRouteResult.failure('El nombre de la ruta es requerido');
      }

      if (stops.length < 2) {
        return CreateRouteResult.failure('Una ruta debe tener al menos 2 paradas');
      }

      final route = Route(
        id: 0,
        name: routeName.trim(),
        isActive: true,
      );

      final routeId = await _routesDao.insertRoute(route.toCompanionInsert());

      final stopIds = <int>[];
      for (int i = 0; i < stops.length; i++) {
        final stopData = stops[i];
        final stop = Stop(
          id: 0,
          routeId: routeId,
          latitude: stopData.latitude,
          longitude: stopData.longitude,
          isActive: true,
        );

        final stopId = await _stopsDao.insertStop(stop.toCompanionInsert());
        stopIds.add(stopId);
      }

      return CreateRouteResult.success(routeId, stopIds);

    } catch (e) {
      return CreateRouteResult.failure('Error al crear la ruta: ${e.toString()}');
    }
  }
}