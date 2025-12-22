// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState()';
}


}

/// @nodoc
class $AccountStateCopyWith<$Res>  {
$AccountStateCopyWith(AccountState _, $Res Function(AccountState) __);
}


/// Adds pattern-matching-related methods to [AccountState].
extension AccountStatePatterns on AccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AccountStateWithInitial value)?  initial,TResult Function( _AccountStateLoading value)?  loading,TResult Function( _AccountStateWithError value)?  withError,TResult Function( AccountStateWithData value)?  withData,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountStateWithInitial() when initial != null:
return initial(_that);case _AccountStateLoading() when loading != null:
return loading(_that);case _AccountStateWithError() when withError != null:
return withError(_that);case AccountStateWithData() when withData != null:
return withData(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AccountStateWithInitial value)  initial,required TResult Function( _AccountStateLoading value)  loading,required TResult Function( _AccountStateWithError value)  withError,required TResult Function( AccountStateWithData value)  withData,}){
final _that = this;
switch (_that) {
case _AccountStateWithInitial():
return initial(_that);case _AccountStateLoading():
return loading(_that);case _AccountStateWithError():
return withError(_that);case AccountStateWithData():
return withData(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AccountStateWithInitial value)?  initial,TResult? Function( _AccountStateLoading value)?  loading,TResult? Function( _AccountStateWithError value)?  withError,TResult? Function( AccountStateWithData value)?  withData,}){
final _that = this;
switch (_that) {
case _AccountStateWithInitial() when initial != null:
return initial(_that);case _AccountStateLoading() when loading != null:
return loading(_that);case _AccountStateWithError() when withError != null:
return withError(_that);case AccountStateWithData() when withData != null:
return withData(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ZenScrapException exception)?  withError,TResult Function( AccountInfo accountInfo)?  withData,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountStateWithInitial() when initial != null:
return initial();case _AccountStateLoading() when loading != null:
return loading();case _AccountStateWithError() when withError != null:
return withError(_that.exception);case AccountStateWithData() when withData != null:
return withData(_that.accountInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ZenScrapException exception)  withError,required TResult Function( AccountInfo accountInfo)  withData,}) {final _that = this;
switch (_that) {
case _AccountStateWithInitial():
return initial();case _AccountStateLoading():
return loading();case _AccountStateWithError():
return withError(_that.exception);case AccountStateWithData():
return withData(_that.accountInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ZenScrapException exception)?  withError,TResult? Function( AccountInfo accountInfo)?  withData,}) {final _that = this;
switch (_that) {
case _AccountStateWithInitial() when initial != null:
return initial();case _AccountStateLoading() when loading != null:
return loading();case _AccountStateWithError() when withError != null:
return withError(_that.exception);case AccountStateWithData() when withData != null:
return withData(_that.accountInfo);case _:
  return null;

}
}

}

/// @nodoc


class _AccountStateWithInitial implements AccountState {
   _AccountStateWithInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountStateWithInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.initial()';
}


}




/// @nodoc


class _AccountStateLoading implements AccountState {
   _AccountStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.loading()';
}


}




/// @nodoc


class _AccountStateWithError implements AccountState {
   _AccountStateWithError({required this.exception});
  

 final  ZenScrapException exception;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStateWithErrorCopyWith<_AccountStateWithError> get copyWith => __$AccountStateWithErrorCopyWithImpl<_AccountStateWithError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountStateWithError&&(identical(other.exception, exception) || other.exception == exception));
}


@override
int get hashCode => Object.hash(runtimeType,exception);

@override
String toString() {
  return 'AccountState.withError(exception: $exception)';
}


}

/// @nodoc
abstract mixin class _$AccountStateWithErrorCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory _$AccountStateWithErrorCopyWith(_AccountStateWithError value, $Res Function(_AccountStateWithError) _then) = __$AccountStateWithErrorCopyWithImpl;
@useResult
$Res call({
 ZenScrapException exception
});




}
/// @nodoc
class __$AccountStateWithErrorCopyWithImpl<$Res>
    implements _$AccountStateWithErrorCopyWith<$Res> {
  __$AccountStateWithErrorCopyWithImpl(this._self, this._then);

  final _AccountStateWithError _self;
  final $Res Function(_AccountStateWithError) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exception = null,}) {
  return _then(_AccountStateWithError(
exception: null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as ZenScrapException,
  ));
}


}

/// @nodoc


class AccountStateWithData implements AccountState {
   AccountStateWithData({required this.accountInfo});
  

 final  AccountInfo accountInfo;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStateWithDataCopyWith<AccountStateWithData> get copyWith => _$AccountStateWithDataCopyWithImpl<AccountStateWithData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountStateWithData&&(identical(other.accountInfo, accountInfo) || other.accountInfo == accountInfo));
}


@override
int get hashCode => Object.hash(runtimeType,accountInfo);

@override
String toString() {
  return 'AccountState.withData(accountInfo: $accountInfo)';
}


}

/// @nodoc
abstract mixin class $AccountStateWithDataCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountStateWithDataCopyWith(AccountStateWithData value, $Res Function(AccountStateWithData) _then) = _$AccountStateWithDataCopyWithImpl;
@useResult
$Res call({
 AccountInfo accountInfo
});




}
/// @nodoc
class _$AccountStateWithDataCopyWithImpl<$Res>
    implements $AccountStateWithDataCopyWith<$Res> {
  _$AccountStateWithDataCopyWithImpl(this._self, this._then);

  final AccountStateWithData _self;
  final $Res Function(AccountStateWithData) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountInfo = null,}) {
  return _then(AccountStateWithData(
accountInfo: null == accountInfo ? _self.accountInfo : accountInfo // ignore: cast_nullable_to_non_nullable
as AccountInfo,
  ));
}


}

// dart format on
