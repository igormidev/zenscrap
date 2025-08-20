// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_scrappables_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserScrappablesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserScrappablesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserScrappablesState()';
  }
}

/// @nodoc
class $UserScrappablesStateCopyWith<$Res> {
  $UserScrappablesStateCopyWith(
      UserScrappablesState _, $Res Function(UserScrappablesState) __);
}

/// Adds pattern-matching-related methods to [UserScrappablesState].
extension UserScrappablesStatePatterns on UserScrappablesState {
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
    TResult Function(_UserScrappablesListageInitial value)? initial,
    TResult Function(_UserScrappablesListageLoading value)? loading,
    TResult Function(_UserScrappablesListageWithError value)? withError,
    TResult Function(_UserScrappablesListageWithData value)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial() when initial != null:
        return initial(_that);
      case _UserScrappablesListageLoading() when loading != null:
        return loading(_that);
      case _UserScrappablesListageWithError() when withError != null:
        return withError(_that);
      case _UserScrappablesListageWithData() when withData != null:
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
    required TResult Function(_UserScrappablesListageInitial value) initial,
    required TResult Function(_UserScrappablesListageLoading value) loading,
    required TResult Function(_UserScrappablesListageWithError value) withError,
    required TResult Function(_UserScrappablesListageWithData value) withData,
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial():
        return initial(_that);
      case _UserScrappablesListageLoading():
        return loading(_that);
      case _UserScrappablesListageWithError():
        return withError(_that);
      case _UserScrappablesListageWithData():
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
    TResult? Function(_UserScrappablesListageInitial value)? initial,
    TResult? Function(_UserScrappablesListageLoading value)? loading,
    TResult? Function(_UserScrappablesListageWithError value)? withError,
    TResult? Function(_UserScrappablesListageWithData value)? withData,
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial() when initial != null:
        return initial(_that);
      case _UserScrappablesListageLoading() when loading != null:
        return loading(_that);
      case _UserScrappablesListageWithError() when withError != null:
        return withError(_that);
      case _UserScrappablesListageWithData() when withData != null:
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
    TResult Function(List<Scrappable> scrappables)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial() when initial != null:
        return initial();
      case _UserScrappablesListageLoading() when loading != null:
        return loading();
      case _UserScrappablesListageWithError() when withError != null:
        return withError(_that.error);
      case _UserScrappablesListageWithData() when withData != null:
        return withData(_that.scrappables);
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
    required TResult Function(List<Scrappable> scrappables) withData,
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial():
        return initial();
      case _UserScrappablesListageLoading():
        return loading();
      case _UserScrappablesListageWithError():
        return withError(_that.error);
      case _UserScrappablesListageWithData():
        return withData(_that.scrappables);
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
    TResult? Function(List<Scrappable> scrappables)? withData,
  }) {
    final _that = this;
    switch (_that) {
      case _UserScrappablesListageInitial() when initial != null:
        return initial();
      case _UserScrappablesListageLoading() when loading != null:
        return loading();
      case _UserScrappablesListageWithError() when withError != null:
        return withError(_that.error);
      case _UserScrappablesListageWithData() when withData != null:
        return withData(_that.scrappables);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UserScrappablesListageInitial implements UserScrappablesState {
  _UserScrappablesListageInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserScrappablesListageInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserScrappablesState.initial()';
  }
}

/// @nodoc

class _UserScrappablesListageLoading implements UserScrappablesState {
  _UserScrappablesListageLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserScrappablesListageLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserScrappablesState.loading()';
  }
}

/// @nodoc

class _UserScrappablesListageWithError implements UserScrappablesState {
  _UserScrappablesListageWithError({required this.error});

  final ZenScrapException error;

  /// Create a copy of UserScrappablesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserScrappablesListageWithErrorCopyWith<_UserScrappablesListageWithError>
      get copyWith => __$UserScrappablesListageWithErrorCopyWithImpl<
          _UserScrappablesListageWithError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserScrappablesListageWithError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'UserScrappablesState.withError(error: $error)';
  }
}

/// @nodoc
abstract mixin class _$UserScrappablesListageWithErrorCopyWith<$Res>
    implements $UserScrappablesStateCopyWith<$Res> {
  factory _$UserScrappablesListageWithErrorCopyWith(
          _UserScrappablesListageWithError value,
          $Res Function(_UserScrappablesListageWithError) _then) =
      __$UserScrappablesListageWithErrorCopyWithImpl;
  @useResult
  $Res call({ZenScrapException error});
}

/// @nodoc
class __$UserScrappablesListageWithErrorCopyWithImpl<$Res>
    implements _$UserScrappablesListageWithErrorCopyWith<$Res> {
  __$UserScrappablesListageWithErrorCopyWithImpl(this._self, this._then);

  final _UserScrappablesListageWithError _self;
  final $Res Function(_UserScrappablesListageWithError) _then;

  /// Create a copy of UserScrappablesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(_UserScrappablesListageWithError(
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ZenScrapException,
    ));
  }
}

/// @nodoc

class _UserScrappablesListageWithData implements UserScrappablesState {
  _UserScrappablesListageWithData({required final List<Scrappable> scrappables})
      : _scrappables = scrappables;

  final List<Scrappable> _scrappables;
  List<Scrappable> get scrappables {
    if (_scrappables is EqualUnmodifiableListView) return _scrappables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scrappables);
  }

  /// Create a copy of UserScrappablesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserScrappablesListageWithDataCopyWith<_UserScrappablesListageWithData>
      get copyWith => __$UserScrappablesListageWithDataCopyWithImpl<
          _UserScrappablesListageWithData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserScrappablesListageWithData &&
            const DeepCollectionEquality()
                .equals(other._scrappables, _scrappables));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_scrappables));

  @override
  String toString() {
    return 'UserScrappablesState.withData(scrappables: $scrappables)';
  }
}

/// @nodoc
abstract mixin class _$UserScrappablesListageWithDataCopyWith<$Res>
    implements $UserScrappablesStateCopyWith<$Res> {
  factory _$UserScrappablesListageWithDataCopyWith(
          _UserScrappablesListageWithData value,
          $Res Function(_UserScrappablesListageWithData) _then) =
      __$UserScrappablesListageWithDataCopyWithImpl;
  @useResult
  $Res call({List<Scrappable> scrappables});
}

/// @nodoc
class __$UserScrappablesListageWithDataCopyWithImpl<$Res>
    implements _$UserScrappablesListageWithDataCopyWith<$Res> {
  __$UserScrappablesListageWithDataCopyWithImpl(this._self, this._then);

  final _UserScrappablesListageWithData _self;
  final $Res Function(_UserScrappablesListageWithData) _then;

  /// Create a copy of UserScrappablesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scrappables = null,
  }) {
    return _then(_UserScrappablesListageWithData(
      scrappables: null == scrappables
          ? _self._scrappables
          : scrappables // ignore: cast_nullable_to_non_nullable
              as List<Scrappable>,
    ));
  }
}

// dart format on
