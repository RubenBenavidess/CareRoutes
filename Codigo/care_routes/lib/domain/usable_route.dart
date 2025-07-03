import 'package:freezed_annotation/freezed_annotation.dart';

part 'usable_route.freezed.dart';

@freezed
abstract class UsableRoute with _$UsableRoute {
  const factory UsableRoute({
    required int idRoute,
    required DateTime dateTime,
    required bool isActive
  }) = _UsableRoute;
}
