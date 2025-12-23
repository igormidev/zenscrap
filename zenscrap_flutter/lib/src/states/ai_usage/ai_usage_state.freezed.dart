// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_usage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AIUsageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIUsageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AIUsageState()';
}


}

/// @nodoc
class $AIUsageStateCopyWith<$Res>  {
$AIUsageStateCopyWith(AIUsageState _, $Res Function(AIUsageState) __);
}


/// Adds pattern-matching-related methods to [AIUsageState].
extension AIUsageStatePatterns on AIUsageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _WithError value)?  withError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _WithError() when withError != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _WithError value)  withError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _WithError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _WithError value)?  withError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _WithError() when withError != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AccountAIUsage aiUsage)?  loaded,TResult Function( ZenScrapException error)?  withError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.aiUsage);case _WithError() when withError != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AccountAIUsage aiUsage)  loaded,required TResult Function( ZenScrapException error)  withError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.aiUsage);case _WithError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AccountAIUsage aiUsage)?  loaded,TResult? Function( ZenScrapException error)?  withError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.aiUsage);case _WithError() when withError != null:
return withError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AIUsageState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AIUsageState.initial()';
}


}




/// @nodoc


class _Loading implements AIUsageState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AIUsageState.loading()';
}


}




/// @nodoc


class _Loaded implements AIUsageState {
  const _Loaded({required this.aiUsage});
  

 final  AccountAIUsage aiUsage;

/// Create a copy of AIUsageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.aiUsage, aiUsage) || other.aiUsage == aiUsage));
}


@override
int get hashCode => Object.hash(runtimeType,aiUsage);

@override
String toString() {
  return 'AIUsageState.loaded(aiUsage: $aiUsage)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AIUsageStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 AccountAIUsage aiUsage
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AIUsageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? aiUsage = null,}) {
  return _then(_Loaded(
aiUsage: null == aiUsage ? _self.aiUsage : aiUsage // ignore: cast_nullable_to_non_nullable
as AccountAIUsage,
  ));
}


}

/// @nodoc


class _WithError implements AIUsageState {
  const _WithError(this.error);
  

 final  ZenScrapException error;

/// Create a copy of AIUsageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WithErrorCopyWith<_WithError> get copyWith => __$WithErrorCopyWithImpl<_WithError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WithError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'AIUsageState.withError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$WithErrorCopyWith<$Res> implements $AIUsageStateCopyWith<$Res> {
  factory _$WithErrorCopyWith(_WithError value, $Res Function(_WithError) _then) = __$WithErrorCopyWithImpl;
@useResult
$Res call({
 ZenScrapException error
});




}
/// @nodoc
class __$WithErrorCopyWithImpl<$Res>
    implements _$WithErrorCopyWith<$Res> {
  __$WithErrorCopyWithImpl(this._self, this._then);

  final _WithError _self;
  final $Res Function(_WithError) _then;

/// Create a copy of AIUsageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_WithError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ZenScrapException,
  ));
}


}

// dart format on
