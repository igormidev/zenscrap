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
    TResult Function(_ScrapChatSessionStateBlank value)? blank,
    TResult Function(_ScrapChatSessionStateCreatingSessionState value)?
        creatingSessionState,
    TResult Function(_ScrapChatSessionStateStandard value)? standard,
    TResult Function(_ScrapChatSessionStateWithError value)? withError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank() when blank != null:
        return blank(_that);
      case _ScrapChatSessionStateCreatingSessionState()
          when creatingSessionState != null:
        return creatingSessionState(_that);
      case _ScrapChatSessionStateStandard() when standard != null:
        return standard(_that);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that);
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
    required TResult Function(_ScrapChatSessionStateBlank value) blank,
    required TResult Function(_ScrapChatSessionStateCreatingSessionState value)
        creatingSessionState,
    required TResult Function(_ScrapChatSessionStateStandard value) standard,
    required TResult Function(_ScrapChatSessionStateWithError value) withError,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank():
        return blank(_that);
      case _ScrapChatSessionStateCreatingSessionState():
        return creatingSessionState(_that);
      case _ScrapChatSessionStateStandard():
        return standard(_that);
      case _ScrapChatSessionStateWithError():
        return withError(_that);
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
    TResult? Function(_ScrapChatSessionStateBlank value)? blank,
    TResult? Function(_ScrapChatSessionStateCreatingSessionState value)?
        creatingSessionState,
    TResult? Function(_ScrapChatSessionStateStandard value)? standard,
    TResult? Function(_ScrapChatSessionStateWithError value)? withError,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank() when blank != null:
        return blank(_that);
      case _ScrapChatSessionStateCreatingSessionState()
          when creatingSessionState != null:
        return creatingSessionState(_that);
      case _ScrapChatSessionStateStandard() when standard != null:
        return standard(_that);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that);
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
    TResult Function()? blank,
    TResult Function()? creatingSessionState,
    TResult Function(
            Scrappable data, DateTime testExpirationDate, String sessionUuid)?
        standard,
    TResult Function(ZenScrapException error)? withError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank() when blank != null:
        return blank();
      case _ScrapChatSessionStateCreatingSessionState()
          when creatingSessionState != null:
        return creatingSessionState();
      case _ScrapChatSessionStateStandard() when standard != null:
        return standard(
            _that.data, _that.testExpirationDate, _that.sessionUuid);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that.error);
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
    required TResult Function() blank,
    required TResult Function() creatingSessionState,
    required TResult Function(
            Scrappable data, DateTime testExpirationDate, String sessionUuid)
        standard,
    required TResult Function(ZenScrapException error) withError,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank():
        return blank();
      case _ScrapChatSessionStateCreatingSessionState():
        return creatingSessionState();
      case _ScrapChatSessionStateStandard():
        return standard(
            _that.data, _that.testExpirationDate, _that.sessionUuid);
      case _ScrapChatSessionStateWithError():
        return withError(_that.error);
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
    TResult? Function()? blank,
    TResult? Function()? creatingSessionState,
    TResult? Function(
            Scrappable data, DateTime testExpirationDate, String sessionUuid)?
        standard,
    TResult? Function(ZenScrapException error)? withError,
  }) {
    final _that = this;
    switch (_that) {
      case _ScrapChatSessionStateBlank() when blank != null:
        return blank();
      case _ScrapChatSessionStateCreatingSessionState()
          when creatingSessionState != null:
        return creatingSessionState();
      case _ScrapChatSessionStateStandard() when standard != null:
        return standard(
            _that.data, _that.testExpirationDate, _that.sessionUuid);
      case _ScrapChatSessionStateWithError() when withError != null:
        return withError(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScrapChatSessionStateBlank implements ScrapChatSessionState {
  _ScrapChatSessionStateBlank();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateBlank);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ScrapChatSessionState.blank()';
  }
}

/// @nodoc

class _ScrapChatSessionStateCreatingSessionState
    implements ScrapChatSessionState {
  _ScrapChatSessionStateCreatingSessionState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateCreatingSessionState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ScrapChatSessionState.creatingSessionState()';
  }
}

/// @nodoc

class _ScrapChatSessionStateStandard implements ScrapChatSessionState {
  _ScrapChatSessionStateStandard(
      {required this.data,
      required this.testExpirationDate,
      required this.sessionUuid});

  final Scrappable data;
  final DateTime testExpirationDate;
  final String sessionUuid;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScrapChatSessionStateStandardCopyWith<_ScrapChatSessionStateStandard>
      get copyWith => __$ScrapChatSessionStateStandardCopyWithImpl<
          _ScrapChatSessionStateStandard>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrapChatSessionStateStandard &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.testExpirationDate, testExpirationDate) ||
                other.testExpirationDate == testExpirationDate) &&
            (identical(other.sessionUuid, sessionUuid) ||
                other.sessionUuid == sessionUuid));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, data, testExpirationDate, sessionUuid);

  @override
  String toString() {
    return 'ScrapChatSessionState.standard(data: $data, testExpirationDate: $testExpirationDate, sessionUuid: $sessionUuid)';
  }
}

/// @nodoc
abstract mixin class _$ScrapChatSessionStateStandardCopyWith<$Res>
    implements $ScrapChatSessionStateCopyWith<$Res> {
  factory _$ScrapChatSessionStateStandardCopyWith(
          _ScrapChatSessionStateStandard value,
          $Res Function(_ScrapChatSessionStateStandard) _then) =
      __$ScrapChatSessionStateStandardCopyWithImpl;
  @useResult
  $Res call({Scrappable data, DateTime testExpirationDate, String sessionUuid});
}

/// @nodoc
class __$ScrapChatSessionStateStandardCopyWithImpl<$Res>
    implements _$ScrapChatSessionStateStandardCopyWith<$Res> {
  __$ScrapChatSessionStateStandardCopyWithImpl(this._self, this._then);

  final _ScrapChatSessionStateStandard _self;
  final $Res Function(_ScrapChatSessionStateStandard) _then;

  /// Create a copy of ScrapChatSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = null,
    Object? testExpirationDate = null,
    Object? sessionUuid = null,
  }) {
    return _then(_ScrapChatSessionStateStandard(
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Scrappable,
      testExpirationDate: null == testExpirationDate
          ? _self.testExpirationDate
          : testExpirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sessionUuid: null == sessionUuid
          ? _self.sessionUuid
          : sessionUuid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
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

// dart format on
