// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usable_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsableRoute {

 int get idRoute; DateTime get dateTime; bool get isActive;
/// Create a copy of UsableRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsableRouteCopyWith<UsableRoute> get copyWith => _$UsableRouteCopyWithImpl<UsableRoute>(this as UsableRoute, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsableRoute&&(identical(other.idRoute, idRoute) || other.idRoute == idRoute)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,idRoute,dateTime,isActive);

@override
String toString() {
  return 'UsableRoute(idRoute: $idRoute, dateTime: $dateTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UsableRouteCopyWith<$Res>  {
  factory $UsableRouteCopyWith(UsableRoute value, $Res Function(UsableRoute) _then) = _$UsableRouteCopyWithImpl;
@useResult
$Res call({
 int idRoute, DateTime dateTime, bool isActive
});




}
/// @nodoc
class _$UsableRouteCopyWithImpl<$Res>
    implements $UsableRouteCopyWith<$Res> {
  _$UsableRouteCopyWithImpl(this._self, this._then);

  final UsableRoute _self;
  final $Res Function(UsableRoute) _then;

/// Create a copy of UsableRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idRoute = null,Object? dateTime = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
idRoute: null == idRoute ? _self.idRoute : idRoute // ignore: cast_nullable_to_non_nullable
as int,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UsableRoute].
extension UsableRoutePatterns on UsableRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsableRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsableRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsableRoute value)  $default,){
final _that = this;
switch (_that) {
case _UsableRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsableRoute value)?  $default,){
final _that = this;
switch (_that) {
case _UsableRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idRoute,  DateTime dateTime,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsableRoute() when $default != null:
return $default(_that.idRoute,_that.dateTime,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idRoute,  DateTime dateTime,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UsableRoute():
return $default(_that.idRoute,_that.dateTime,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idRoute,  DateTime dateTime,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UsableRoute() when $default != null:
return $default(_that.idRoute,_that.dateTime,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _UsableRoute implements UsableRoute {
  const _UsableRoute({required this.idRoute, required this.dateTime, required this.isActive});
  

@override final  int idRoute;
@override final  DateTime dateTime;
@override final  bool isActive;

/// Create a copy of UsableRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsableRouteCopyWith<_UsableRoute> get copyWith => __$UsableRouteCopyWithImpl<_UsableRoute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsableRoute&&(identical(other.idRoute, idRoute) || other.idRoute == idRoute)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,idRoute,dateTime,isActive);

@override
String toString() {
  return 'UsableRoute(idRoute: $idRoute, dateTime: $dateTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UsableRouteCopyWith<$Res> implements $UsableRouteCopyWith<$Res> {
  factory _$UsableRouteCopyWith(_UsableRoute value, $Res Function(_UsableRoute) _then) = __$UsableRouteCopyWithImpl;
@override @useResult
$Res call({
 int idRoute, DateTime dateTime, bool isActive
});




}
/// @nodoc
class __$UsableRouteCopyWithImpl<$Res>
    implements _$UsableRouteCopyWith<$Res> {
  __$UsableRouteCopyWithImpl(this._self, this._then);

  final _UsableRoute _self;
  final $Res Function(_UsableRoute) _then;

/// Create a copy of UsableRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idRoute = null,Object? dateTime = null,Object? isActive = null,}) {
  return _then(_UsableRoute(
idRoute: null == idRoute ? _self.idRoute : idRoute // ignore: cast_nullable_to_non_nullable
as int,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
