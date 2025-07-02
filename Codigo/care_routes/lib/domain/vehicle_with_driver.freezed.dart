// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_with_driver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleWithDriver {

 int get idVehicle;// PK vehículo
 String get licensePlate; String get model; int get idDriver; String get driverName; String get idNumber;
/// Create a copy of VehicleWithDriver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleWithDriverCopyWith<VehicleWithDriver> get copyWith => _$VehicleWithDriverCopyWithImpl<VehicleWithDriver>(this as VehicleWithDriver, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleWithDriver&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.model, model) || other.model == model)&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,licensePlate,model,idDriver,driverName,idNumber);

@override
String toString() {
  return 'VehicleWithDriver(idVehicle: $idVehicle, licensePlate: $licensePlate, model: $model, idDriver: $idDriver, driverName: $driverName, idNumber: $idNumber)';
}


}

/// @nodoc
abstract mixin class $VehicleWithDriverCopyWith<$Res>  {
  factory $VehicleWithDriverCopyWith(VehicleWithDriver value, $Res Function(VehicleWithDriver) _then) = _$VehicleWithDriverCopyWithImpl;
@useResult
$Res call({
 int idVehicle, String licensePlate, String model, int idDriver, String driverName, String idNumber
});




}
/// @nodoc
class _$VehicleWithDriverCopyWithImpl<$Res>
    implements $VehicleWithDriverCopyWith<$Res> {
  _$VehicleWithDriverCopyWithImpl(this._self, this._then);

  final VehicleWithDriver _self;
  final $Res Function(VehicleWithDriver) _then;

/// Create a copy of VehicleWithDriver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idVehicle = null,Object? licensePlate = null,Object? model = null,Object? idDriver = null,Object? driverName = null,Object? idNumber = null,}) {
  return _then(_self.copyWith(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,idDriver: null == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleWithDriver].
extension VehicleWithDriverPatterns on VehicleWithDriver {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleWithDriver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleWithDriver() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleWithDriver value)  $default,){
final _that = this;
switch (_that) {
case _VehicleWithDriver():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleWithDriver value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleWithDriver() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idVehicle,  String licensePlate,  String model,  int idDriver,  String driverName,  String idNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleWithDriver() when $default != null:
return $default(_that.idVehicle,_that.licensePlate,_that.model,_that.idDriver,_that.driverName,_that.idNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idVehicle,  String licensePlate,  String model,  int idDriver,  String driverName,  String idNumber)  $default,) {final _that = this;
switch (_that) {
case _VehicleWithDriver():
return $default(_that.idVehicle,_that.licensePlate,_that.model,_that.idDriver,_that.driverName,_that.idNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idVehicle,  String licensePlate,  String model,  int idDriver,  String driverName,  String idNumber)?  $default,) {final _that = this;
switch (_that) {
case _VehicleWithDriver() when $default != null:
return $default(_that.idVehicle,_that.licensePlate,_that.model,_that.idDriver,_that.driverName,_that.idNumber);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleWithDriver implements VehicleWithDriver {
  const _VehicleWithDriver({required this.idVehicle, required this.licensePlate, required this.model, required this.idDriver, required this.driverName, required this.idNumber});
  

@override final  int idVehicle;
// PK vehículo
@override final  String licensePlate;
@override final  String model;
@override final  int idDriver;
@override final  String driverName;
@override final  String idNumber;

/// Create a copy of VehicleWithDriver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleWithDriverCopyWith<_VehicleWithDriver> get copyWith => __$VehicleWithDriverCopyWithImpl<_VehicleWithDriver>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleWithDriver&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.model, model) || other.model == model)&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,licensePlate,model,idDriver,driverName,idNumber);

@override
String toString() {
  return 'VehicleWithDriver(idVehicle: $idVehicle, licensePlate: $licensePlate, model: $model, idDriver: $idDriver, driverName: $driverName, idNumber: $idNumber)';
}


}

/// @nodoc
abstract mixin class _$VehicleWithDriverCopyWith<$Res> implements $VehicleWithDriverCopyWith<$Res> {
  factory _$VehicleWithDriverCopyWith(_VehicleWithDriver value, $Res Function(_VehicleWithDriver) _then) = __$VehicleWithDriverCopyWithImpl;
@override @useResult
$Res call({
 int idVehicle, String licensePlate, String model, int idDriver, String driverName, String idNumber
});




}
/// @nodoc
class __$VehicleWithDriverCopyWithImpl<$Res>
    implements _$VehicleWithDriverCopyWith<$Res> {
  __$VehicleWithDriverCopyWithImpl(this._self, this._then);

  final _VehicleWithDriver _self;
  final $Res Function(_VehicleWithDriver) _then;

/// Create a copy of VehicleWithDriver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idVehicle = null,Object? licensePlate = null,Object? model = null,Object? idDriver = null,Object? driverName = null,Object? idNumber = null,}) {
  return _then(_VehicleWithDriver(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,idDriver: null == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
