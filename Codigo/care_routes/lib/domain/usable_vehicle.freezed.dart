// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 int get idVehicle;// PK vehículo
 String get make; String get model; String get year;
/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsableVehicleCopyWith<UsableVehicle> get copyWith => _$UsableVehicleCopyWithImpl<UsableVehicle>(this as UsableVehicle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsableVehicle&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,make,model,year);

@override
String toString() {
  return 'UsableVehicle(idVehicle: $idVehicle, make: $make, model: $model, year: $year)';
}


}

/// @nodoc
abstract mixin class $UsableVehicleCopyWith<$Res>  {
  factory $UsableVehicleCopyWith(UsableVehicle value, $Res Function(UsableVehicle) _then) = _$UsableVehicleCopyWithImpl;
@useResult
$Res call({
 int idVehicle, String make, String model, String year
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
@pragma('vm:prefer-inline') @override $Res call({Object? idVehicle = null,Object? make = null,Object? model = null,Object? year = null,}) {
  return _then(_self.copyWith(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _UsableVehicle implements UsableVehicle {
  const _UsableVehicle({required this.idVehicle, required this.make, required this.model, required this.year});
  

@override final  int idVehicle;
// PK vehículo
@override final  String make;
@override final  String model;
@override final  String year;

/// Create a copy of UsableVehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsableVehicleCopyWith<_UsableVehicle> get copyWith => __$UsableVehicleCopyWithImpl<_UsableVehicle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsableVehicle&&(identical(other.idVehicle, idVehicle) || other.idVehicle == idVehicle)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year));
}


@override
int get hashCode => Object.hash(runtimeType,idVehicle,make,model,year);

@override
String toString() {
  return 'UsableVehicle(idVehicle: $idVehicle, make: $make, model: $model, year: $year)';
}


}

/// @nodoc
abstract mixin class _$UsableVehicleCopyWith<$Res> implements $UsableVehicleCopyWith<$Res> {
  factory _$UsableVehicleCopyWith(_UsableVehicle value, $Res Function(_UsableVehicle) _then) = __$UsableVehicleCopyWithImpl;
@override @useResult
$Res call({
 int idVehicle, String make, String model, String year
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
@override @pragma('vm:prefer-inline') $Res call({Object? idVehicle = null,Object? make = null,Object? model = null,Object? year = null,}) {
  return _then(_UsableVehicle(
idVehicle: null == idVehicle ? _self.idVehicle : idVehicle // ignore: cast_nullable_to_non_nullable
as int,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
