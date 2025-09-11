// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scraping_bee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractDataByRule {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ExtractDataByRule);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ExtractDataByRule()';
  }
}

/// @nodoc
class $ExtractDataByRuleCopyWith<$Res> {
  $ExtractDataByRuleCopyWith(
      ExtractDataByRule _, $Res Function(ExtractDataByRule) __);
}

/// Adds pattern-matching-related methods to [ExtractDataByRule].
extension ExtractDataByRulePatterns on ExtractDataByRule {
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
    TResult Function(_ExtractDataByRuleWithData value)? withData,
    TResult Function(_ExtractDataByRuleWithError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData() when withData != null:
        return withData(_that);
      case _ExtractDataByRuleWithError() when error != null:
        return error(_that);
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
    required TResult Function(_ExtractDataByRuleWithData value) withData,
    required TResult Function(_ExtractDataByRuleWithError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData():
        return withData(_that);
      case _ExtractDataByRuleWithError():
        return error(_that);
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
    TResult? Function(_ExtractDataByRuleWithData value)? withData,
    TResult? Function(_ExtractDataByRuleWithError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData() when withData != null:
        return withData(_that);
      case _ExtractDataByRuleWithError() when error != null:
        return error(_that);
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
    TResult Function(Map<String, dynamic> result)? withData,
    TResult Function(String errorMessage)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData() when withData != null:
        return withData(_that.result);
      case _ExtractDataByRuleWithError() when error != null:
        return error(_that.errorMessage);
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
    required TResult Function(Map<String, dynamic> result) withData,
    required TResult Function(String errorMessage) error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData():
        return withData(_that.result);
      case _ExtractDataByRuleWithError():
        return error(_that.errorMessage);
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
    TResult? Function(Map<String, dynamic> result)? withData,
    TResult? Function(String errorMessage)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractDataByRuleWithData() when withData != null:
        return withData(_that.result);
      case _ExtractDataByRuleWithError() when error != null:
        return error(_that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExtractDataByRuleWithData extends ExtractDataByRule {
  const _ExtractDataByRuleWithData({required final Map<String, dynamic> result})
      : _result = result,
        super._();

  final Map<String, dynamic> _result;
  Map<String, dynamic> get result {
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_result);
  }

  /// Create a copy of ExtractDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractDataByRuleWithDataCopyWith<_ExtractDataByRuleWithData>
      get copyWith =>
          __$ExtractDataByRuleWithDataCopyWithImpl<_ExtractDataByRuleWithData>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractDataByRuleWithData &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_result));

  @override
  String toString() {
    return 'ExtractDataByRule.withData(result: $result)';
  }
}

/// @nodoc
abstract mixin class _$ExtractDataByRuleWithDataCopyWith<$Res>
    implements $ExtractDataByRuleCopyWith<$Res> {
  factory _$ExtractDataByRuleWithDataCopyWith(_ExtractDataByRuleWithData value,
          $Res Function(_ExtractDataByRuleWithData) _then) =
      __$ExtractDataByRuleWithDataCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> result});
}

/// @nodoc
class __$ExtractDataByRuleWithDataCopyWithImpl<$Res>
    implements _$ExtractDataByRuleWithDataCopyWith<$Res> {
  __$ExtractDataByRuleWithDataCopyWithImpl(this._self, this._then);

  final _ExtractDataByRuleWithData _self;
  final $Res Function(_ExtractDataByRuleWithData) _then;

  /// Create a copy of ExtractDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
  }) {
    return _then(_ExtractDataByRuleWithData(
      result: null == result
          ? _self._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _ExtractDataByRuleWithError extends ExtractDataByRule {
  const _ExtractDataByRuleWithError({required this.errorMessage}) : super._();

  final String errorMessage;

  /// Create a copy of ExtractDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractDataByRuleWithErrorCopyWith<_ExtractDataByRuleWithError>
      get copyWith => __$ExtractDataByRuleWithErrorCopyWithImpl<
          _ExtractDataByRuleWithError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractDataByRuleWithError &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @override
  String toString() {
    return 'ExtractDataByRule.error(errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ExtractDataByRuleWithErrorCopyWith<$Res>
    implements $ExtractDataByRuleCopyWith<$Res> {
  factory _$ExtractDataByRuleWithErrorCopyWith(
          _ExtractDataByRuleWithError value,
          $Res Function(_ExtractDataByRuleWithError) _then) =
      __$ExtractDataByRuleWithErrorCopyWithImpl;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$ExtractDataByRuleWithErrorCopyWithImpl<$Res>
    implements _$ExtractDataByRuleWithErrorCopyWith<$Res> {
  __$ExtractDataByRuleWithErrorCopyWithImpl(this._self, this._then);

  final _ExtractDataByRuleWithError _self;
  final $Res Function(_ExtractDataByRuleWithError) _then;

  /// Create a copy of ExtractDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_ExtractDataByRuleWithError(
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ExtractFullDataByRule {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ExtractFullDataByRule);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ExtractFullDataByRule()';
  }
}

/// @nodoc
class $ExtractFullDataByRuleCopyWith<$Res> {
  $ExtractFullDataByRuleCopyWith(
      ExtractFullDataByRule _, $Res Function(ExtractFullDataByRule) __);
}

/// Adds pattern-matching-related methods to [ExtractFullDataByRule].
extension ExtractFullDataByRulePatterns on ExtractFullDataByRule {
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
    TResult Function(_ExtractFullDataByRuleWithData value)? withData,
    TResult Function(_ExtractFullDataByRuleWithError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData() when withData != null:
        return withData(_that);
      case _ExtractFullDataByRuleWithError() when error != null:
        return error(_that);
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
    required TResult Function(_ExtractFullDataByRuleWithData value) withData,
    required TResult Function(_ExtractFullDataByRuleWithError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData():
        return withData(_that);
      case _ExtractFullDataByRuleWithError():
        return error(_that);
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
    TResult? Function(_ExtractFullDataByRuleWithData value)? withData,
    TResult? Function(_ExtractFullDataByRuleWithError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData() when withData != null:
        return withData(_that);
      case _ExtractFullDataByRuleWithError() when error != null:
        return error(_that);
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
    TResult Function(
            Map<String, dynamic> result, String html, Uint8List screenshot)?
        withData,
    TResult Function(String errorMessage)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData() when withData != null:
        return withData(_that.result, _that.html, _that.screenshot);
      case _ExtractFullDataByRuleWithError() when error != null:
        return error(_that.errorMessage);
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
    required TResult Function(
            Map<String, dynamic> result, String html, Uint8List screenshot)
        withData,
    required TResult Function(String errorMessage) error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData():
        return withData(_that.result, _that.html, _that.screenshot);
      case _ExtractFullDataByRuleWithError():
        return error(_that.errorMessage);
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
    TResult? Function(
            Map<String, dynamic> result, String html, Uint8List screenshot)?
        withData,
    TResult? Function(String errorMessage)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractFullDataByRuleWithData() when withData != null:
        return withData(_that.result, _that.html, _that.screenshot);
      case _ExtractFullDataByRuleWithError() when error != null:
        return error(_that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExtractFullDataByRuleWithData extends ExtractFullDataByRule {
  const _ExtractFullDataByRuleWithData(
      {required final Map<String, dynamic> result,
      required this.html,
      required this.screenshot})
      : _result = result,
        super._();

  final Map<String, dynamic> _result;
  Map<String, dynamic> get result {
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_result);
  }

  final String html;
  final Uint8List screenshot;

  /// Create a copy of ExtractFullDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractFullDataByRuleWithDataCopyWith<_ExtractFullDataByRuleWithData>
      get copyWith => __$ExtractFullDataByRuleWithDataCopyWithImpl<
          _ExtractFullDataByRuleWithData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractFullDataByRuleWithData &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.html, html) || other.html == html) &&
            const DeepCollectionEquality()
                .equals(other.screenshot, screenshot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_result),
      html,
      const DeepCollectionEquality().hash(screenshot));

  @override
  String toString() {
    return 'ExtractFullDataByRule.withData(result: $result, html: $html, screenshot: $screenshot)';
  }
}

/// @nodoc
abstract mixin class _$ExtractFullDataByRuleWithDataCopyWith<$Res>
    implements $ExtractFullDataByRuleCopyWith<$Res> {
  factory _$ExtractFullDataByRuleWithDataCopyWith(
          _ExtractFullDataByRuleWithData value,
          $Res Function(_ExtractFullDataByRuleWithData) _then) =
      __$ExtractFullDataByRuleWithDataCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> result, String html, Uint8List screenshot});
}

/// @nodoc
class __$ExtractFullDataByRuleWithDataCopyWithImpl<$Res>
    implements _$ExtractFullDataByRuleWithDataCopyWith<$Res> {
  __$ExtractFullDataByRuleWithDataCopyWithImpl(this._self, this._then);

  final _ExtractFullDataByRuleWithData _self;
  final $Res Function(_ExtractFullDataByRuleWithData) _then;

  /// Create a copy of ExtractFullDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
    Object? html = null,
    Object? screenshot = null,
  }) {
    return _then(_ExtractFullDataByRuleWithData(
      result: null == result
          ? _self._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      html: null == html
          ? _self.html
          : html // ignore: cast_nullable_to_non_nullable
              as String,
      screenshot: null == screenshot
          ? _self.screenshot
          : screenshot // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _ExtractFullDataByRuleWithError extends ExtractFullDataByRule {
  const _ExtractFullDataByRuleWithError({required this.errorMessage})
      : super._();

  final String errorMessage;

  /// Create a copy of ExtractFullDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractFullDataByRuleWithErrorCopyWith<_ExtractFullDataByRuleWithError>
      get copyWith => __$ExtractFullDataByRuleWithErrorCopyWithImpl<
          _ExtractFullDataByRuleWithError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractFullDataByRuleWithError &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @override
  String toString() {
    return 'ExtractFullDataByRule.error(errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ExtractFullDataByRuleWithErrorCopyWith<$Res>
    implements $ExtractFullDataByRuleCopyWith<$Res> {
  factory _$ExtractFullDataByRuleWithErrorCopyWith(
          _ExtractFullDataByRuleWithError value,
          $Res Function(_ExtractFullDataByRuleWithError) _then) =
      __$ExtractFullDataByRuleWithErrorCopyWithImpl;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$ExtractFullDataByRuleWithErrorCopyWithImpl<$Res>
    implements _$ExtractFullDataByRuleWithErrorCopyWith<$Res> {
  __$ExtractFullDataByRuleWithErrorCopyWithImpl(this._self, this._then);

  final _ExtractFullDataByRuleWithError _self;
  final $Res Function(_ExtractFullDataByRuleWithError) _then;

  /// Create a copy of ExtractFullDataByRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_ExtractFullDataByRuleWithError(
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
