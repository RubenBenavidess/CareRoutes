// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usable_driver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsableDriver {

 int get idDriver;// PK conductor
 String get firstName; String get lastName; String get idNumber;
/// Create a copy of UsableDriver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsableDriverCopyWith<UsableDriver> get copyWith => _$UsableDriverCopyWithImpl<UsableDriver>(this as UsableDriver, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsableDriver&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber));
}


@override
int get hashCode => Object.hash(runtimeType,idDriver,firstName,lastName,idNumber);

@override
String toString() {
  return 'UsableDriver(idDriver: $idDriver, firstName: $firstName, lastName: $lastName, idNumber: $idNumber)';
}


}

/// @nodoc
abstract mixin class $UsableDriverCopyWith<$Res>  {
  factory $UsableDriverCopyWith(UsableDriver value, $Res Function(UsableDriver) _then) = _$UsableDriverCopyWithImpl;
@useResult
$Res call({
 int idDriver, String firstName, String lastName, String idNumber
});




}
/// @nodoc
class _$UsableDriverCopyWithImpl<$Res>
    implements $UsableDriverCopyWith<$Res> {
  _$UsableDriverCopyWithImpl(this._self, this._then);

  final UsableDriver _self;
  final $Res Function(UsableDriver) _then;

/// Create a copy of UsableDriver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idDriver = null,Object? firstName = null,Object? lastName = null,Object? idNumber = null,}) {
  return _then(_self.copyWith(
idDriver: null == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _UsableDriver implements UsableDriver {
  const _UsableDriver({required this.idDriver, required this.firstName, required this.lastName, required this.idNumber});
  

@override final  int idDriver;
// PK conductor
@override final  String firstName;
@override final  String lastName;
@override final  String idNumber;

/// Create a copy of UsableDriver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsableDriverCopyWith<_UsableDriver> get copyWith => __$UsableDriverCopyWithImpl<_UsableDriver>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsableDriver&&(identical(other.idDriver, idDriver) || other.idDriver == idDriver)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber));
}


@override
int get hashCode => Object.hash(runtimeType,idDriver,firstName,lastName,idNumber);

@override
String toString() {
  return 'UsableDriver(idDriver: $idDriver, firstName: $firstName, lastName: $lastName, idNumber: $idNumber)';
}


}

/// @nodoc
abstract mixin class _$UsableDriverCopyWith<$Res> implements $UsableDriverCopyWith<$Res> {
  factory _$UsableDriverCopyWith(_UsableDriver value, $Res Function(_UsableDriver) _then) = __$UsableDriverCopyWithImpl;
@override @useResult
$Res call({
 int idDriver, String firstName, String lastName, String idNumber
});




}
/// @nodoc
class __$UsableDriverCopyWithImpl<$Res>
    implements _$UsableDriverCopyWith<$Res> {
  __$UsableDriverCopyWithImpl(this._self, this._then);

  final _UsableDriver _self;
  final $Res Function(_UsableDriver) _then;

/// Create a copy of UsableDriver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idDriver = null,Object? firstName = null,Object? lastName = null,Object? idNumber = null,}) {
  return _then(_UsableDriver(
idDriver: null == idDriver ? _self.idDriver : idDriver // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
