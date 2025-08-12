// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrap_chat_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScrapChatSessionState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ScrapChatSessionState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ScrapChatSessionState()';
  }
}

/// @nodoc
class $ScrapChatSessionStateCopyWith<$Res> {
  $ScrapChatSessionStateCopyWith(
      ScrapChatSessionState _, $Res Function(ScrapChatSessionState) __);
}

/// Adds pattern-matching-related methods to [ScrapChatSessionState].
extension ScrapChatSessionStatePatterns on ScrapChatSessionState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ScrapChatSessionStateInitial value)? initial,
    TResult Function(_ScrapChatSessionStateLoading value)? loading,
    TResult Function(_ScrapChatSessionStateWithError value)? withError,
    TResult Function(_ScrapChatSessionStateWithData value)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial() when initial != null:
        return initial(_that);
      case _ScrapChatSessionStateLoading() when loading != null:
        return loading(_that);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that);
      case _ScrapChatSessionStateWithData() when withData != null:
        return withData(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ScrapChatSessionStateInitial value) initial,
    required TResult Function(_ScrapChatSessionStateLoading value) loading,
    required TResult Function(_ScrapChatSessionStateWithError value) withError,
    required TResult Function(_ScrapChatSessionStateWithData value) withData,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial():
        return initial(_that);
      case _ScrapChatSessionStateLoading():
        return loading(_that);
      case _ScrapChatSessionStateWithError():
        return withError(_that);
      case _ScrapChatSessionStateWithData():
        return withData(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ScrapChatSessionStateInitial value)? initial,
    TResult? Function(_ScrapChatSessionStateLoading value)? loading,
    TResult? Function(_ScrapChatSessionStateWithError value)? withError,
    TResult? Function(_ScrapChatSessionStateWithData value)? withData,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial() when initial != null:
        return initial(_that);
      case _ScrapChatSessionStateLoading() when loading != null:
        return loading(_that);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that);
      case _ScrapChatSessionStateWithData() when withData != null:
        return withData(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ZenScrapException error)? withError,
    TResult Function(Scrappable data)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial() when initial != null:
        return initial();
      case _ScrapChatSessionStateLoading() when loading != null:
        return loading();
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that.error);
      case _ScrapChatSessionStateWithData() when withData != null:
        return withData(_that.data);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ZenScrapException error) withError,
    required TResult Function(Scrappable data) withData,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial():
        return initial();
      case _ScrapChatSessionStateLoading():
        return loading();
      case _ScrapChatSessionStateWithError():
        return withError(_that.error);
      case _ScrapChatSessionStateWithData():
        return withData(_that.data);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ZenScrapException error)? withError,
    TResult? Function(Scrappable data)? withData,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateInitial() when initial != null:
        return initial();
      case _ScrapChatSessionStateLoading() when loading != null:
        return loading();
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that.error);
      case _ScrapChatSessionStateWithData() when withData != null:
        return withData(_that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScrapChatSessionStateInitial implements ScrapChatSessionState {
  _ScrapChatSessionStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ScrapChatSessionState.initial()';
  }
}

/// @nodoc

class _ScrapChatSessionStateLoading implements ScrapChatSessionState {
  _ScrapChatSessionStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ScrapChatSessionState.loading()';
  }
}

/// @nodoc

class _ScrapChatSessionStateWithError implements ScrapChatSessionState {
  _ScrapChatSessionStateWithError({required this.error});

  final ZenScrapException error;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScrapChatSessionStateWithErrorCopyWith<_ScrapChatSessionStateWithError>
      get copyWith => __$ScrapChatSessionStateWithErrorCopyWithImpl<
          _ScrapChatSessionStateWithError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateWithError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ScrapChatSessionState.withError(error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ScrapChatSessionStateWithErrorCopyWith<$Res>
    implements $ScrapChatSessionStateCopyWith<$Res> {
  factory _$ScrapChatSessionStateWithErrorCopyWith(
          _ScrapChatSessionStateWithError value,
          $Res Function(_ScrapChatSessionStateWithError) _then) =
      __$ScrapChatSessionStateWithErrorCopyWithImpl;
  @useResult
  $Res call({ZenScrapException error});
}

/// @nodoc
class __$ScrapChatSessionStateWithErrorCopyWithImpl<$Res>
    implements _$ScrapChatSessionStateWithErrorCopyWith<$Res> {
  __$ScrapChatSessionStateWithErrorCopyWithImpl(this._self, this._then);

  final _ScrapChatSessionStateWithError _self;
  final $Res Function(_ScrapChatSessionStateWithError) _then;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(_ScrapChatSessionStateWithError(
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ZenScrapException,
    ));
  }
}

/// @nodoc

class _ScrapChatSessionStateWithData implements ScrapChatSessionState {
  _ScrapChatSessionStateWithData({required this.data});

  final Scrappable data;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScrapChatSessionStateWithDataCopyWith<_ScrapChatSessionStateWithData>
      get copyWith => __$ScrapChatSessionStateWithDataCopyWithImpl<
          _ScrapChatSessionStateWithData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateWithData &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @override
  String toString() {
    return 'ScrapChatSessionState.withData(data: $data)';
  }
}

/// @nodoc
abstract mixin class _$ScrapChatSessionStateWithDataCopyWith<$Res>
    implements $ScrapChatSessionStateCopyWith<$Res> {
  factory _$ScrapChatSessionStateWithDataCopyWith(
          _ScrapChatSessionStateWithData value,
          $Res Function(_ScrapChatSessionStateWithData) _then) =
      __$ScrapChatSessionStateWithDataCopyWithImpl;
  @useResult
  $Res call({Scrappable data});
}

/// @nodoc
class __$ScrapChatSessionStateWithDataCopyWithImpl<$Res>
    implements _$ScrapChatSessionStateWithDataCopyWith<$Res> {
  __$ScrapChatSessionStateWithDataCopyWithImpl(this._self, this._then);

  final _ScrapChatSessionStateWithData _self;
  final $Res Function(_ScrapChatSessionStateWithData) _then;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = null,
  }) {
    return _then(_ScrapChatSessionStateWithData(
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Scrappable,
    ));
  }
}

// dart format on
