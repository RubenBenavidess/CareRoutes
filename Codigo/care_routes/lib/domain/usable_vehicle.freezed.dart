// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usable_vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsableVehicle {

 int get idVehicle; String get licensePlate; String get brand; String get model; int get mileage; int get year; int? get idDriver; VehicleStatus get status;
/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsableVehicleCopyWith<UsableVehicle> get copyWith => _$UsableVehicleCopyWithImpl<UsableVehicle>(this as UsableVehicle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsableVehicle&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.mileage, mileage) || other.mileage == mileage)&&(identical(other.year, year) || other.year == year)&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,licensePlate,brand,model,mileage,year,idDriver,status);

@override
String toString() {
  return 'UsableVehicle(idVehicle: $idVehicle, licensePlate: $licensePlate, brand: $brand, model: $model, mileage: $mileage, year: $year, idDriver: $idDriver, status: $status)';
}


}

/// @nodoc
abstract mixin class $UsableVehicleCopyWith<$Res>  {
  factory $UsableVehicleCopyWith(UsableVehicle value, $Res Function(UsableVehicle) _then) = _$UsableVehicleCopyWithImpl;
@useResult
$Res call({
 int idVehicle, String licensePlate, String brand, String model, int mileage, int year, int? idDriver, VehicleStatus status
});




}
/// @nodoc
class _$UsableVehicleCopyWithImpl<$Res>
    implements $UsableVehicleCopyWith<$Res> {
  _$UsableVehicleCopyWithImpl(this._self, this._then);

  final UsableVehicle _self;
  final $Res Function(UsableVehicle) _then;

/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idVehicle = null,Object? licensePlate = null,Object? brand = null,Object? model = null,Object? mileage = null,Object? year = null,Object? idDriver = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,mileage: null == mileage ? _self.mileage : mileage // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,idDriver: freezed == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VehicleStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UsableVehicle].
extension UsableVehiclePatterns on UsableVehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsableVehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsableVehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsableVehicle value)  $default,){
final _that = this;
switch (_that) {
case _UsableVehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsableVehicle value)?  $default,){
final _that = this;
switch (_that) {
case _UsableVehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idVehicle,  String licensePlate,  String brand,  String model,  int mileage,  int year,  int? idDriver,  VehicleStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsableVehicle() when $default != null:
return $default(_that.idVehicle,_that.licensePlate,_that.brand,_that.model,_that.mileage,_that.year,_that.idDriver,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idVehicle,  String licensePlate,  String brand,  String model,  int mileage,  int year,  int? idDriver,  VehicleStatus status)  $default,) {final _that = this;
switch (_that) {
case _UsableVehicle():
return $default(_that.idVehicle,_that.licensePlate,_that.brand,_that.model,_that.mileage,_that.year,_that.idDriver,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idVehicle,  String licensePlate,  String brand,  String model,  int mileage,  int year,  int? idDriver,  VehicleStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UsableVehicle() when $default != null:
return $default(_that.idVehicle,_that.licensePlate,_that.brand,_that.model,_that.mileage,_that.year,_that.idDriver,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _UsableVehicle implements UsableVehicle {
  const _UsableVehicle({required this.idVehicle, required this.licensePlate, required this.brand, required this.model, required this.mileage, required this.year, this.idDriver, required this.status});
  

@override final  int idVehicle;
@override final  String licensePlate;
@override final  String brand;
@override final  String model;
@override final  int mileage;
@override final  int year;
@override final  int? idDriver;
@override final  VehicleStatus status;

/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsableVehicleCopyWith<_UsableVehicle> get copyWith => __$UsableVehicleCopyWithImpl<_UsableVehicle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsableVehicle&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.mileage, mileage) || other.mileage == mileage)&&(identical(other.year, year) || other.year == year)&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,licensePlate,brand,model,mileage,year,idDriver,status);

@override
String toString() {
  return 'UsableVehicle(idVehicle: $idVehicle, licensePlate: $licensePlate, brand: $brand, model: $model, mileage: $mileage, year: $year, idDriver: $idDriver, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UsableVehicleCopyWith<$Res> implements $UsableVehicleCopyWith<$Res> {
  factory _$UsableVehicleCopyWith(_UsableVehicle value, $Res Function(_UsableVehicle) _then) = __$UsableVehicleCopyWithImpl;
@override @useResult
$Res call({
 int idVehicle, String licensePlate, String brand, String model, int mileage, int year, int? idDriver, VehicleStatus status
});




}
/// @nodoc
class __$UsableVehicleCopyWithImpl<$Res>
    implements _$UsableVehicleCopyWith<$Res> {
  __$UsableVehicleCopyWithImpl(this._self, this._then);

  final _UsableVehicle _self;
  final $Res Function(_UsableVehicle) _then;

/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idVehicle = null,Object? licensePlate = null,Object? brand = null,Object? model = null,Object? mileage = null,Object? year = null,Object? idDriver = freezed,Object? status = null,}) {
  return _then(_UsableVehicle(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,mileage: null == mileage ? _self.mileage : mileage // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,idDriver: freezed == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VehicleStatus,
  ));
}


}

// dart format on
