import 'dart:async';
import 'package:care_routes/data/daos/daos.dart';
import 'package:care_routes/data/database.dart';
import 'package:care_routes/domain/usable_route.dart';
import 'package:care_routes/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsableRoutesNotifier extends StateNotifier<List<UsableRoute>> {
  final RoutesDao _routesDao;
  StreamSubscription<List<Route>>? _routesSubscription;

  UsableRoutesNotifier(this._routesDao) : super([]) {
    _startWatchingRoutes();
  }

  void _startWatchingRoutes() {

    _routesSubscription?.cancel();
    _routesSubscription = _routesDao.watchAllActiveRoutes().listen((routes) {

      final usableRoutes = routes.map(
        (r) => UsableRoute(
          idRoute: r.idRoute,
          dateTime: r.date,
          isActive: r.isActive,
        ),
      ).toList();
      state = usableRoutes;
    });
  }

  Future<void> addRoute(RoutesCompanion routeCompanion) async {
    await _routesDao.insertRoute(routeCompanion);
  }

  Future<void> updateRoute(Route route) async {
    await _routesDao.updateRoute(route);
  }

  Future<void> softDeleteRoute(int id) async {
    await _routesDao.softDeleteRoute(id);
  }

  Future<UsableRoute?> getUsableRouteById(int id) async {
    final route = await _routesDao.getRouteById(id);
    if (route != null) {
      return UsableRoute(
        idRoute: route.idRoute,
        dateTime: route.date,
        isActive: route.isActive,
      );
    }
    return null;
  }

  @override
  void dispose() {
    _routesSubscription?.cancel();
    super.dispose();
  }
}

final usableRoutesNotifierProvider = StateNotifierProvider<UsableRoutesNotifier, List<UsableRoute>>(
  (ref) {
    final routesDao = ref.watch(routesDaoProvider);
    return UsableRoutesNotifier(routesDao);
  },
);
