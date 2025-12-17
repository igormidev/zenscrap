// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_scrappable_analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedScrappableAnalyticsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedScrappableAnalyticsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectedScrappableAnalyticsState()';
}


}

/// @nodoc
class $SelectedScrappableAnalyticsStateCopyWith<$Res>  {
$SelectedScrappableAnalyticsStateCopyWith(SelectedScrappableAnalyticsState _, $Res Function(SelectedScrappableAnalyticsState) __);
}


/// Adds pattern-matching-related methods to [SelectedScrappableAnalyticsState].
extension SelectedScrappableAnalyticsStatePatterns on SelectedScrappableAnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SelectedScrappableAnalyticsStateNone value)?  none,TResult Function( _SelectedScrappableAnalyticsStateLoading value)?  loading,TResult Function( _SelectedScrappableAnalyticsStateLoadingMore value)?  loadingMore,TResult Function( _SelectedScrappableAnalyticsStateWithData value)?  withData,TResult Function( _SelectedScrappableAnalyticsStateWithError value)?  withError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone() when none != null:
return none(_that);case _SelectedScrappableAnalyticsStateLoading() when loading != null:
return loading(_that);case _SelectedScrappableAnalyticsStateLoadingMore() when loadingMore != null:
return loadingMore(_that);case _SelectedScrappableAnalyticsStateWithData() when withData != null:
return withData(_that);case _SelectedScrappableAnalyticsStateWithError() when withError != null:
return withError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SelectedScrappableAnalyticsStateNone value)  none,required TResult Function( _SelectedScrappableAnalyticsStateLoading value)  loading,required TResult Function( _SelectedScrappableAnalyticsStateLoadingMore value)  loadingMore,required TResult Function( _SelectedScrappableAnalyticsStateWithData value)  withData,required TResult Function( _SelectedScrappableAnalyticsStateWithError value)  withError,}){
final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone():
return none(_that);case _SelectedScrappableAnalyticsStateLoading():
return loading(_that);case _SelectedScrappableAnalyticsStateLoadingMore():
return loadingMore(_that);case _SelectedScrappableAnalyticsStateWithData():
return withData(_that);case _SelectedScrappableAnalyticsStateWithError():
return withError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SelectedScrappableAnalyticsStateNone value)?  none,TResult? Function( _SelectedScrappableAnalyticsStateLoading value)?  loading,TResult? Function( _SelectedScrappableAnalyticsStateLoadingMore value)?  loadingMore,TResult? Function( _SelectedScrappableAnalyticsStateWithData value)?  withData,TResult? Function( _SelectedScrappableAnalyticsStateWithError value)?  withError,}){
final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone() when none != null:
return none(_that);case _SelectedScrappableAnalyticsStateLoading() when loading != null:
return loading(_that);case _SelectedScrappableAnalyticsStateLoadingMore() when loadingMore != null:
return loadingMore(_that);case _SelectedScrappableAnalyticsStateWithData() when withData != null:
return withData(_that);case _SelectedScrappableAnalyticsStateWithError() when withError != null:
return withError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function()?  loading,TResult Function( PaginatedScrappableAnalytics currentData)?  loadingMore,TResult Function( PaginatedScrappableAnalytics data)?  withData,TResult Function( ZenScrapException error)?  withError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone() when none != null:
return none();case _SelectedScrappableAnalyticsStateLoading() when loading != null:
return loading();case _SelectedScrappableAnalyticsStateLoadingMore() when loadingMore != null:
return loadingMore(_that.currentData);case _SelectedScrappableAnalyticsStateWithData() when withData != null:
return withData(_that.data);case _SelectedScrappableAnalyticsStateWithError() when withError != null:
return withError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function()  loading,required TResult Function( PaginatedScrappableAnalytics currentData)  loadingMore,required TResult Function( PaginatedScrappableAnalytics data)  withData,required TResult Function( ZenScrapException error)  withError,}) {final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone():
return none();case _SelectedScrappableAnalyticsStateLoading():
return loading();case _SelectedScrappableAnalyticsStateLoadingMore():
return loadingMore(_that.currentData);case _SelectedScrappableAnalyticsStateWithData():
return withData(_that.data);case _SelectedScrappableAnalyticsStateWithError():
return withError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function()?  loading,TResult? Function( PaginatedScrappableAnalytics currentData)?  loadingMore,TResult? Function( PaginatedScrappableAnalytics data)?  withData,TResult? Function( ZenScrapException error)?  withError,}) {final _that = this;
switch (_that) {
case _SelectedScrappableAnalyticsStateNone() when none != null:
return none();case _SelectedScrappableAnalyticsStateLoading() when loading != null:
return loading();case _SelectedScrappableAnalyticsStateLoadingMore() when loadingMore != null:
return loadingMore(_that.currentData);case _SelectedScrappableAnalyticsStateWithData() when withData != null:
return withData(_that.data);case _SelectedScrappableAnalyticsStateWithError() when withError != null:
return withError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedScrappableAnalyticsStateNone implements SelectedScrappableAnalyticsState {
   _SelectedScrappableAnalyticsStateNone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedScrappableAnalyticsStateNone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectedScrappableAnalyticsState.none()';
}


}




/// @nodoc


class _SelectedScrappableAnalyticsStateLoading implements SelectedScrappableAnalyticsState {
   _SelectedScrappableAnalyticsStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedScrappableAnalyticsStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectedScrappableAnalyticsState.loading()';
}


}




/// @nodoc


class _SelectedScrappableAnalyticsStateLoadingMore implements SelectedScrappableAnalyticsState {
   _SelectedScrappableAnalyticsStateLoadingMore({required this.currentData});
  

 final  PaginatedScrappableAnalytics currentData;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedScrappableAnalyticsStateLoadingMoreCopyWith<_SelectedScrappableAnalyticsStateLoadingMore> get copyWith => __$SelectedScrappableAnalyticsStateLoadingMoreCopyWithImpl<_SelectedScrappableAnalyticsStateLoadingMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedScrappableAnalyticsStateLoadingMore&&(identical(other.currentData, currentData) || other.currentData == currentData));
}


@override
int get hashCode => Object.hash(runtimeType,currentData);

@override
String toString() {
  return 'SelectedScrappableAnalyticsState.loadingMore(currentData: $currentData)';
}


}

/// @nodoc
abstract mixin class _$SelectedScrappableAnalyticsStateLoadingMoreCopyWith<$Res> implements $SelectedScrappableAnalyticsStateCopyWith<$Res> {
  factory _$SelectedScrappableAnalyticsStateLoadingMoreCopyWith(_SelectedScrappableAnalyticsStateLoadingMore value, $Res Function(_SelectedScrappableAnalyticsStateLoadingMore) _then) = __$SelectedScrappableAnalyticsStateLoadingMoreCopyWithImpl;
@useResult
$Res call({
 PaginatedScrappableAnalytics currentData
});




}
/// @nodoc
class __$SelectedScrappableAnalyticsStateLoadingMoreCopyWithImpl<$Res>
    implements _$SelectedScrappableAnalyticsStateLoadingMoreCopyWith<$Res> {
  __$SelectedScrappableAnalyticsStateLoadingMoreCopyWithImpl(this._self, this._then);

  final _SelectedScrappableAnalyticsStateLoadingMore _self;
  final $Res Function(_SelectedScrappableAnalyticsStateLoadingMore) _then;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentData = null,}) {
  return _then(_SelectedScrappableAnalyticsStateLoadingMore(
currentData: null == currentData ? _self.currentData : currentData // ignore: cast_nullable_to_non_nullable
as PaginatedScrappableAnalytics,
  ));
}


}

/// @nodoc


class _SelectedScrappableAnalyticsStateWithData implements SelectedScrappableAnalyticsState {
   _SelectedScrappableAnalyticsStateWithData({required this.data});
  

 final  PaginatedScrappableAnalytics data;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedScrappableAnalyticsStateWithDataCopyWith<_SelectedScrappableAnalyticsStateWithData> get copyWith => __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl<_SelectedScrappableAnalyticsStateWithData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedScrappableAnalyticsStateWithData&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SelectedScrappableAnalyticsState.withData(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SelectedScrappableAnalyticsStateWithDataCopyWith<$Res> implements $SelectedScrappableAnalyticsStateCopyWith<$Res> {
  factory _$SelectedScrappableAnalyticsStateWithDataCopyWith(_SelectedScrappableAnalyticsStateWithData value, $Res Function(_SelectedScrappableAnalyticsStateWithData) _then) = __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl;
@useResult
$Res call({
 PaginatedScrappableAnalytics data
});




}
/// @nodoc
class __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl<$Res>
    implements _$SelectedScrappableAnalyticsStateWithDataCopyWith<$Res> {
  __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl(this._self, this._then);

  final _SelectedScrappableAnalyticsStateWithData _self;
  final $Res Function(_SelectedScrappableAnalyticsStateWithData) _then;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_SelectedScrappableAnalyticsStateWithData(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PaginatedScrappableAnalytics,
  ));
}


}

/// @nodoc


class _SelectedScrappableAnalyticsStateWithError implements SelectedScrappableAnalyticsState {
   _SelectedScrappableAnalyticsStateWithError({required this.error});
  

 final  ZenScrapException error;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedScrappableAnalyticsStateWithErrorCopyWith<_SelectedScrappableAnalyticsStateWithError> get copyWith => __$SelectedScrappableAnalyticsStateWithErrorCopyWithImpl<_SelectedScrappableAnalyticsStateWithError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedScrappableAnalyticsStateWithError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'SelectedScrappableAnalyticsState.withError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$SelectedScrappableAnalyticsStateWithErrorCopyWith<$Res> implements $SelectedScrappableAnalyticsStateCopyWith<$Res> {
  factory _$SelectedScrappableAnalyticsStateWithErrorCopyWith(_SelectedScrappableAnalyticsStateWithError value, $Res Function(_SelectedScrappableAnalyticsStateWithError) _then) = __$SelectedScrappableAnalyticsStateWithErrorCopyWithImpl;
@useResult
$Res call({
 ZenScrapException error
});




}
/// @nodoc
class __$SelectedScrappableAnalyticsStateWithErrorCopyWithImpl<$Res>
    implements _$SelectedScrappableAnalyticsStateWithErrorCopyWith<$Res> {
  __$SelectedScrappableAnalyticsStateWithErrorCopyWithImpl(this._self, this._then);

  final _SelectedScrappableAnalyticsStateWithError _self;
  final $Res Function(_SelectedScrappableAnalyticsStateWithError) _then;

/// Create a copy of SelectedScrappableAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_SelectedScrappableAnalyticsStateWithError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ZenScrapException,
  ));
}


}

// dart format on
