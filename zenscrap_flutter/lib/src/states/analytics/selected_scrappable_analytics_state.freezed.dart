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
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SelectedScrappableAnalyticsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SelectedScrappableAnalyticsState()';
  }
}

/// @nodoc
class $SelectedScrappableAnalyticsStateCopyWith<$Res> {
  $SelectedScrappableAnalyticsStateCopyWith(SelectedScrappableAnalyticsState _,
      $Res Function(SelectedScrappableAnalyticsState) __);
}

/// Adds pattern-matching-related methods to [SelectedScrappableAnalyticsState].
extension SelectedScrappableAnalyticsStatePatterns
    on SelectedScrappableAnalyticsState {
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
    TResult Function(_SelectedScrappableAnalyticsStateNone value)? none,
    TResult Function(_SelectedScrappableAnalyticsStateLoading value)? loading,
    TResult Function(_SelectedScrappableAnalyticsStateWithData value)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone() when none != null:
        return none(_that);
      case _SelectedScrappableAnalyticsStateLoading() when loading != null:
        return loading(_that);
      case _SelectedScrappableAnalyticsStateWithData() when withData != null:
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
    required TResult Function(_SelectedScrappableAnalyticsStateNone value) none,
    required TResult Function(_SelectedScrappableAnalyticsStateLoading value)
        loading,
    required TResult Function(_SelectedScrappableAnalyticsStateWithData value)
        withData,
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone():
        return none(_that);
      case _SelectedScrappableAnalyticsStateLoading():
        return loading(_that);
      case _SelectedScrappableAnalyticsStateWithData():
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
    TResult? Function(_SelectedScrappableAnalyticsStateNone value)? none,
    TResult? Function(_SelectedScrappableAnalyticsStateLoading value)? loading,
    TResult? Function(_SelectedScrappableAnalyticsStateWithData value)?
        withData,
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone() when none != null:
        return none(_that);
      case _SelectedScrappableAnalyticsStateLoading() when loading != null:
        return loading(_that);
      case _SelectedScrappableAnalyticsStateWithData() when withData != null:
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
    TResult Function()? none,
    TResult Function()? loading,
    TResult Function(List<ScrappableAnalytics> result)? withData,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone() when none != null:
        return none();
      case _SelectedScrappableAnalyticsStateLoading() when loading != null:
        return loading();
      case _SelectedScrappableAnalyticsStateWithData() when withData != null:
        return withData(_that.result);
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
    required TResult Function() none,
    required TResult Function() loading,
    required TResult Function(List<ScrappableAnalytics> result) withData,
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone():
        return none();
      case _SelectedScrappableAnalyticsStateLoading():
        return loading();
      case _SelectedScrappableAnalyticsStateWithData():
        return withData(_that.result);
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
    TResult? Function()? none,
    TResult? Function()? loading,
    TResult? Function(List<ScrappableAnalytics> result)? withData,
  }) {
    final _that = this;
    switch (_that) {
      case _SelectedScrappableAnalyticsStateNone() when none != null:
        return none();
      case _SelectedScrappableAnalyticsStateLoading() when loading != null:
        return loading();
      case _SelectedScrappableAnalyticsStateWithData() when withData != null:
        return withData(_that.result);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SelectedScrappableAnalyticsStateNone
    implements SelectedScrappableAnalyticsState {
  _SelectedScrappableAnalyticsStateNone();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectedScrappableAnalyticsStateNone);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SelectedScrappableAnalyticsState.none()';
  }
}

/// @nodoc

class _SelectedScrappableAnalyticsStateLoading
    implements SelectedScrappableAnalyticsState {
  _SelectedScrappableAnalyticsStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectedScrappableAnalyticsStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SelectedScrappableAnalyticsState.loading()';
  }
}

/// @nodoc

class _SelectedScrappableAnalyticsStateWithData
    implements SelectedScrappableAnalyticsState {
  _SelectedScrappableAnalyticsStateWithData(
      {required final List<ScrappableAnalytics> result})
      : _result = result;

  final List<ScrappableAnalytics> _result;
  List<ScrappableAnalytics> get result {
    if (_result is EqualUnmodifiableListView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_result);
  }

  /// Create a copy of SelectedScrappableAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SelectedScrappableAnalyticsStateWithDataCopyWith<
          _SelectedScrappableAnalyticsStateWithData>
      get copyWith => __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl<
          _SelectedScrappableAnalyticsStateWithData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectedScrappableAnalyticsStateWithData &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_result));

  @override
  String toString() {
    return 'SelectedScrappableAnalyticsState.withData(result: $result)';
  }
}

/// @nodoc
abstract mixin class _$SelectedScrappableAnalyticsStateWithDataCopyWith<$Res>
    implements $SelectedScrappableAnalyticsStateCopyWith<$Res> {
  factory _$SelectedScrappableAnalyticsStateWithDataCopyWith(
          _SelectedScrappableAnalyticsStateWithData value,
          $Res Function(_SelectedScrappableAnalyticsStateWithData) _then) =
      __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl;
  @useResult
  $Res call({List<ScrappableAnalytics> result});
}

/// @nodoc
class __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl<$Res>
    implements _$SelectedScrappableAnalyticsStateWithDataCopyWith<$Res> {
  __$SelectedScrappableAnalyticsStateWithDataCopyWithImpl(
      this._self, this._then);

  final _SelectedScrappableAnalyticsStateWithData _self;
  final $Res Function(_SelectedScrappableAnalyticsStateWithData) _then;

  /// Create a copy of SelectedScrappableAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
  }) {
    return _then(_SelectedScrappableAnalyticsStateWithData(
      result: null == result
          ? _self._result
          : result // ignore: cast_nullable_to_non_nullable
              as List<ScrappableAnalytics>,
    ));
  }
}

// dart format on
