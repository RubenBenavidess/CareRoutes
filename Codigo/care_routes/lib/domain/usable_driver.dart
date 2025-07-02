import 'package:freezed_annotation/freezed_annotation.dart';

part 'usable_driver.freezed.dart';

@freezed
abstract class UsableDriver with _$UsableDriver {
  const factory UsableDriver({
    required int idDriver, // PK conductor
    required String firstName,
    required String lastName,
    required String idNumber,
  }) = _UsableDriver;
}
