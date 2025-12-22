// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState()';
}


}

/// @nodoc
class $SessionStateCopyWith<$Res>  {
$SessionStateCopyWith(SessionState _, $Res Function(SessionState) __);
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SessionStateLoading value)?  loading,TResult Function( _SessionStateNotSignedIn value)?  notSignedIn,TResult Function( _SessionStateLogged value)?  logged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionStateLoading() when loading != null:
return loading(_that);case _SessionStateNotSignedIn() when notSignedIn != null:
return notSignedIn(_that);case _SessionStateLogged() when logged != null:
return logged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SessionStateLoading value)  loading,required TResult Function( _SessionStateNotSignedIn value)  notSignedIn,required TResult Function( _SessionStateLogged value)  logged,}){
final _that = this;
switch (_that) {
case _SessionStateLoading():
return loading(_that);case _SessionStateNotSignedIn():
return notSignedIn(_that);case _SessionStateLogged():
return logged(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SessionStateLoading value)?  loading,TResult? Function( _SessionStateNotSignedIn value)?  notSignedIn,TResult? Function( _SessionStateLogged value)?  logged,}){
final _that = this;
switch (_that) {
case _SessionStateLoading() when loading != null:
return loading(_that);case _SessionStateNotSignedIn() when notSignedIn != null:
return notSignedIn(_that);case _SessionStateLogged() when logged != null:
return logged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  notSignedIn,TResult Function( UserModel user)?  logged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionStateLoading() when loading != null:
return loading();case _SessionStateNotSignedIn() when notSignedIn != null:
return notSignedIn();case _SessionStateLogged() when logged != null:
return logged(_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  notSignedIn,required TResult Function( UserModel user)  logged,}) {final _that = this;
switch (_that) {
case _SessionStateLoading():
return loading();case _SessionStateNotSignedIn():
return notSignedIn();case _SessionStateLogged():
return logged(_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  notSignedIn,TResult? Function( UserModel user)?  logged,}) {final _that = this;
switch (_that) {
case _SessionStateLoading() when loading != null:
return loading();case _SessionStateNotSignedIn() when notSignedIn != null:
return notSignedIn();case _SessionStateLogged() when logged != null:
return logged(_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _SessionStateLoading implements SessionState {
   _SessionStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.loading()';
}


}




/// @nodoc


class _SessionStateNotSignedIn implements SessionState {
   _SessionStateNotSignedIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStateNotSignedIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.notSignedIn()';
}


}




/// @nodoc


class _SessionStateLogged implements SessionState {
   _SessionStateLogged({required this.user});
  

 final  UserModel user;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStateLoggedCopyWith<_SessionStateLogged> get copyWith => __$SessionStateLoggedCopyWithImpl<_SessionStateLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStateLogged&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'SessionState.logged(user: $user)';
}


}

/// @nodoc
abstract mixin class _$SessionStateLoggedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateLoggedCopyWith(_SessionStateLogged value, $Res Function(_SessionStateLogged) _then) = __$SessionStateLoggedCopyWithImpl;
@useResult
$Res call({
 UserModel user
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$SessionStateLoggedCopyWithImpl<$Res>
    implements _$SessionStateLoggedCopyWith<$Res> {
  __$SessionStateLoggedCopyWithImpl(this._self, this._then);

  final _SessionStateLogged _self;
  final $Res Function(_SessionStateLogged) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_SessionStateLogged(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
