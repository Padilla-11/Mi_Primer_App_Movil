// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Crop {

 String get id; String get name; String get cropType; CropPeriod get period; CropState get state; String get responsibleId;
/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CropCopyWith<Crop> get copyWith => _$CropCopyWithImpl<Crop>(this as Crop, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Crop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.period, period) || other.period == period)&&(identical(other.state, state) || other.state == state)&&(identical(other.responsibleId, responsibleId) || other.responsibleId == responsibleId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,cropType,period,state,responsibleId);

@override
String toString() {
  return 'Crop(id: $id, name: $name, cropType: $cropType, period: $period, state: $state, responsibleId: $responsibleId)';
}


}

/// @nodoc
abstract mixin class $CropCopyWith<$Res>  {
  factory $CropCopyWith(Crop value, $Res Function(Crop) _then) = _$CropCopyWithImpl;
@useResult
$Res call({
 String id, String name, String cropType, CropPeriod period, CropState state, String responsibleId
});




}
/// @nodoc
class _$CropCopyWithImpl<$Res>
    implements $CropCopyWith<$Res> {
  _$CropCopyWithImpl(this._self, this._then);

  final Crop _self;
  final $Res Function(Crop) _then;

/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? cropType = null,Object? period = null,Object? state = null,Object? responsibleId = null,}) {
  return _then(Crop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as CropPeriod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CropState,responsibleId: null == responsibleId ? _self.responsibleId : responsibleId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Crop].
extension CropPatterns on Crop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Crop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Crop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Crop value)  $default,){
final _that = this;
switch (_that) {
case _Crop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Crop value)?  $default,){
final _that = this;
switch (_that) {
case _Crop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String cropType,  CropPeriod period,  CropState state,  String responsibleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Crop() when $default != null:
return $default(_that.id,_that.name,_that.cropType,_that.period,_that.state,_that.responsibleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String cropType,  CropPeriod period,  CropState state,  String responsibleId)  $default,) {final _that = this;
switch (_that) {
case _Crop():
return $default(_that.id,_that.name,_that.cropType,_that.period,_that.state,_that.responsibleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String cropType,  CropPeriod period,  CropState state,  String responsibleId)?  $default,) {final _that = this;
switch (_that) {
case _Crop() when $default != null:
return $default(_that.id,_that.name,_that.cropType,_that.period,_that.state,_that.responsibleId);case _:
  return null;

}
}

}

/// @nodoc


class _Crop extends Crop {
  const _Crop({required this.id, required this.name, required this.cropType, required this.period, required this.state, required this.responsibleId}): super._();
  

@override final  String id;
@override final  String name;
@override final  String cropType;
@override final  CropPeriod period;
@override final  CropState state;
@override final  String responsibleId;

/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CropCopyWith<_Crop> get copyWith => __$CropCopyWithImpl<_Crop>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Crop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.period, period) || other.period == period)&&(identical(other.state, state) || other.state == state)&&(identical(other.responsibleId, responsibleId) || other.responsibleId == responsibleId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,cropType,period,state,responsibleId);

@override
String toString() {
  return 'Crop(id: $id, name: $name, cropType: $cropType, period: $period, state: $state, responsibleId: $responsibleId)';
}


}

/// @nodoc
abstract mixin class _$CropCopyWith<$Res> implements $CropCopyWith<$Res> {
  factory _$CropCopyWith(_Crop value, $Res Function(_Crop) _then) = __$CropCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String cropType, CropPeriod period, CropState state, String responsibleId
});




}
/// @nodoc
class __$CropCopyWithImpl<$Res>
    implements _$CropCopyWith<$Res> {
  __$CropCopyWithImpl(this._self, this._then);

  final _Crop _self;
  final $Res Function(_Crop) _then;

/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? cropType = null,Object? period = null,Object? state = null,Object? responsibleId = null,}) {
  return _then(_Crop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as CropPeriod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CropState,responsibleId: null == responsibleId ? _self.responsibleId : responsibleId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
