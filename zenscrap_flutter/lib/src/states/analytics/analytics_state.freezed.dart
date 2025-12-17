// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState()';
}


}

/// @nodoc
class $AnalyticsStateCopyWith<$Res>  {
$AnalyticsStateCopyWith(AnalyticsState _, $Res Function(AnalyticsState) __);
}


/// Adds pattern-matching-related methods to [AnalyticsState].
extension AnalyticsStatePatterns on AnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _LoadingMore value)?  loadingMore,TResult Function( _EmptyData value)?  emptyData,TResult Function( _Loaded value)?  withData,TResult Function( _Error value)?  withError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _EmptyData() when emptyData != null:
return emptyData(_that);case _Loaded() when withData != null:
return withData(_that);case _Error() when withError != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _LoadingMore value)  loadingMore,required TResult Function( _EmptyData value)  emptyData,required TResult Function( _Loaded value)  withData,required TResult Function( _Error value)  withError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _LoadingMore():
return loadingMore(_that);case _EmptyData():
return emptyData(_that);case _Loaded():
return withData(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _LoadingMore value)?  loadingMore,TResult? Function( _EmptyData value)?  emptyData,TResult? Function( _Loaded value)?  withData,TResult? Function( _Error value)?  withError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _EmptyData() when emptyData != null:
return emptyData(_that);case _Loaded() when withData != null:
return withData(_that);case _Error() when withError != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PaginatedScrappableRequestsAnalytics currentData)?  loadingMore,TResult Function()?  emptyData,TResult Function( PaginatedScrappableRequestsAnalytics data,  bool loadMoreFailed)?  withData,TResult Function( ZenScrapException error)?  withError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _LoadingMore() when loadingMore != null:
return loadingMore(_that.currentData);case _EmptyData() when emptyData != null:
return emptyData();case _Loaded() when withData != null:
return withData(_that.data,_that.loadMoreFailed);case _Error() when withError != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PaginatedScrappableRequestsAnalytics currentData)  loadingMore,required TResult Function()  emptyData,required TResult Function( PaginatedScrappableRequestsAnalytics data,  bool loadMoreFailed)  withData,required TResult Function( ZenScrapException error)  withError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _LoadingMore():
return loadingMore(_that.currentData);case _EmptyData():
return emptyData();case _Loaded():
return withData(_that.data,_that.loadMoreFailed);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PaginatedScrappableRequestsAnalytics currentData)?  loadingMore,TResult? Function()?  emptyData,TResult? Function( PaginatedScrappableRequestsAnalytics data,  bool loadMoreFailed)?  withData,TResult? Function( ZenScrapException error)?  withError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _LoadingMore() when loadingMore != null:
return loadingMore(_that.currentData);case _EmptyData() when emptyData != null:
return emptyData();case _Loaded() when withData != null:
return withData(_that.data,_that.loadMoreFailed);case _Error() when withError != null:
return withError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AnalyticsState {
   _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState.initial()';
}


}




/// @nodoc


class _Loading implements AnalyticsState {
   _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState.loading()';
}


}




/// @nodoc


class _LoadingMore implements AnalyticsState {
   _LoadingMore({required this.currentData});
  

 final  PaginatedScrappableRequestsAnalytics currentData;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingMoreCopyWith<_LoadingMore> get copyWith => __$LoadingMoreCopyWithImpl<_LoadingMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingMore&&(identical(other.currentData, currentData) || other.currentData == currentData));
}


@override
int get hashCode => Object.hash(runtimeType,currentData);

@override
String toString() {
  return 'AnalyticsState.loadingMore(currentData: $currentData)';
}


}

/// @nodoc
abstract mixin class _$LoadingMoreCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$LoadingMoreCopyWith(_LoadingMore value, $Res Function(_LoadingMore) _then) = __$LoadingMoreCopyWithImpl;
@useResult
$Res call({
 PaginatedScrappableRequestsAnalytics currentData
});




}
/// @nodoc
class __$LoadingMoreCopyWithImpl<$Res>
    implements _$LoadingMoreCopyWith<$Res> {
  __$LoadingMoreCopyWithImpl(this._self, this._then);

  final _LoadingMore _self;
  final $Res Function(_LoadingMore) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentData = null,}) {
  return _then(_LoadingMore(
currentData: null == currentData ? _self.currentData : currentData // ignore: cast_nullable_to_non_nullable
as PaginatedScrappableRequestsAnalytics,
  ));
}


}

/// @nodoc


class _EmptyData implements AnalyticsState {
   _EmptyData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState.emptyData()';
}


}




/// @nodoc


class _Loaded implements AnalyticsState {
   _Loaded(this.data, {this.loadMoreFailed = false});
  

 final  PaginatedScrappableRequestsAnalytics data;
@JsonKey() final  bool loadMoreFailed;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.data, data) || other.data == data)&&(identical(other.loadMoreFailed, loadMoreFailed) || other.loadMoreFailed == loadMoreFailed));
}


@override
int get hashCode => Object.hash(runtimeType,data,loadMoreFailed);

@override
String toString() {
  return 'AnalyticsState.withData(data: $data, loadMoreFailed: $loadMoreFailed)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 PaginatedScrappableRequestsAnalytics data, bool loadMoreFailed
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? loadMoreFailed = null,}) {
  return _then(_Loaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PaginatedScrappableRequestsAnalytics,loadMoreFailed: null == loadMoreFailed ? _self.loadMoreFailed : loadMoreFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error implements AnalyticsState {
   _Error({required this.error});
  

 final  ZenScrapException error;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'AnalyticsState.withError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 ZenScrapException error
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ZenScrapException,
  ));
}


}

// dart format on
