import '../entities/domain_entities.dart';
import '../../data/local_repository/daos/routes_dao.dart';
import '../../data/local_repository/daos/stops_dao.dart';
import '../../data/local_repository/mappers.dart';

class RouteWithStops {
  final Route route;
  final List<Stop> stops;

  RouteWithStops({
    required this.route,
    required this.stops,
  });
}

class SearchRoutesUseCase {
  final RoutesDao _routesDao;
  final StopsDao _stopsDao;

  SearchRoutesUseCase({
    required RoutesDao routesDao,
    required StopsDao stopsDao,
  }) : _routesDao = routesDao,
        _stopsDao = stopsDao;

  Future<List<RouteWithStops>> execute({String? searchTerm}) async {
    try {
      List<Route> routes;
      
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        routes = await _routesDao.searchRoutes(searchTerm.trim()).then((list) => list.map((e) => e.toDomain()).toList());
      } else {
        routes = await _routesDao.getAllActiveRoutes().then((list) => list.map((e) => e.toDomain()).toList());
      }

      final routesWithStops = <RouteWithStops>[];

      for (final route in routes) {
        final stops = await _stopsDao.getStopsByRoute(route.id).then((list) => list.map((e) => e.toDomain()).toList());
        routesWithStops.add(RouteWithStops(
          route: route,
          stops: stops,
        ));
      }

      return routesWithStops;

    } catch (e) {
      throw Exception('Error al buscar rutas: ${e.toString()}');
    }
  }

  Future<RouteWithStops?> getRouteById(int routeId) async {
    try {
      final route = await _routesDao.getRouteById(routeId).then((e) => e?.toDomain());
      if (route == null) return null;

      final stops = await _stopsDao.getStopsByRoute(routeId).then((list) => list.map((e) => e.toDomain()).toList());
      return RouteWithStops(route: route, stops: stops);

    } catch (e) {
      throw Exception('Error al obtener ruta: ${e.toString()}');
    }
  }
}