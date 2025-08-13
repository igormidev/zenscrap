// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scraping_bee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExtractDataByRule {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> result) withData,
    required TResult Function(String errorMessage) erorr,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> result)? withData,
    TResult? Function(String errorMessage)? erorr,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> result)? withData,
    TResult Function(String errorMessage)? erorr,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ExtractDataByRuleWithData value) withData,
    required TResult Function(_ExtractDataByRuleWithError value) erorr,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ExtractDataByRuleWithData value)? withData,
    TResult? Function(_ExtractDataByRuleWithError value)? erorr,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ExtractDataByRuleWithData value)? withData,
    TResult Function(_ExtractDataByRuleWithError value)? erorr,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractDataByRuleCopyWith<$Res> {
  factory $ExtractDataByRuleCopyWith(
          ExtractDataByRule value, $Res Function(ExtractDataByRule) then) =
      _$ExtractDataByRuleCopyWithImpl<$Res, ExtractDataByRule>;
}

/// @nodoc
class _$ExtractDataByRuleCopyWithImpl<$Res, $Val extends ExtractDataByRule>
    implements $ExtractDataByRuleCopyWith<$Res> {
  _$ExtractDataByRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExtractDataByRuleWithDataImplCopyWith<$Res> {
  factory _$$ExtractDataByRuleWithDataImplCopyWith(
          _$ExtractDataByRuleWithDataImpl value,
          $Res Function(_$ExtractDataByRuleWithDataImpl) then) =
      __$$ExtractDataByRuleWithDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> result});
}

/// @nodoc
class __$$ExtractDataByRuleWithDataImplCopyWithImpl<$Res>
    extends _$ExtractDataByRuleCopyWithImpl<$Res,
        _$ExtractDataByRuleWithDataImpl>
    implements _$$ExtractDataByRuleWithDataImplCopyWith<$Res> {
  __$$ExtractDataByRuleWithDataImplCopyWithImpl(
      _$ExtractDataByRuleWithDataImpl _value,
      $Res Function(_$ExtractDataByRuleWithDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$ExtractDataByRuleWithDataImpl(
      result: null == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ExtractDataByRuleWithDataImpl extends _ExtractDataByRuleWithData {
  const _$ExtractDataByRuleWithDataImpl(
      {required final Map<String, dynamic> result})
      : _result = result,
        super._();

  final Map<String, dynamic> _result;
  @override
  Map<String, dynamic> get result {
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_result);
  }

  @override
  String toString() {
    return 'ExtractDataByRule.withData(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractDataByRuleWithDataImpl &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_result));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractDataByRuleWithDataImplCopyWith<_$ExtractDataByRuleWithDataImpl>
      get copyWith => __$$ExtractDataByRuleWithDataImplCopyWithImpl<
          _$ExtractDataByRuleWithDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> result) withData,
    required TResult Function(String errorMessage) erorr,
  }) {
    return withData(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> result)? withData,
    TResult? Function(String errorMessage)? erorr,
  }) {
    return withData?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> result)? withData,
    TResult Function(String errorMessage)? erorr,
    required TResult orElse(),
  }) {
    if (withData != null) {
      return withData(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ExtractDataByRuleWithData value) withData,
    required TResult Function(_ExtractDataByRuleWithError value) erorr,
  }) {
    return withData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ExtractDataByRuleWithData value)? withData,
    TResult? Function(_ExtractDataByRuleWithError value)? erorr,
  }) {
    return withData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ExtractDataByRuleWithData value)? withData,
    TResult Function(_ExtractDataByRuleWithError value)? erorr,
    required TResult orElse(),
  }) {
    if (withData != null) {
      return withData(this);
    }
    return orElse();
  }
}

abstract class _ExtractDataByRuleWithData extends ExtractDataByRule {
  const factory _ExtractDataByRuleWithData(
          {required final Map<String, dynamic> result}) =
      _$ExtractDataByRuleWithDataImpl;
  const _ExtractDataByRuleWithData._() : super._();

  Map<String, dynamic> get result;
  @JsonKey(ignore: true)
  _$$ExtractDataByRuleWithDataImplCopyWith<_$ExtractDataByRuleWithDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExtractDataByRuleWithErrorImplCopyWith<$Res> {
  factory _$$ExtractDataByRuleWithErrorImplCopyWith(
          _$ExtractDataByRuleWithErrorImpl value,
          $Res Function(_$ExtractDataByRuleWithErrorImpl) then) =
      __$$ExtractDataByRuleWithErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$ExtractDataByRuleWithErrorImplCopyWithImpl<$Res>
    extends _$ExtractDataByRuleCopyWithImpl<$Res,
        _$ExtractDataByRuleWithErrorImpl>
    implements _$$ExtractDataByRuleWithErrorImplCopyWith<$Res> {
  __$$ExtractDataByRuleWithErrorImplCopyWithImpl(
      _$ExtractDataByRuleWithErrorImpl _value,
      $Res Function(_$ExtractDataByRuleWithErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$ExtractDataByRuleWithErrorImpl(
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExtractDataByRuleWithErrorImpl extends _ExtractDataByRuleWithError {
  const _$ExtractDataByRuleWithErrorImpl({required this.errorMessage})
      : super._();

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'ExtractDataByRule.erorr(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractDataByRuleWithErrorImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractDataByRuleWithErrorImplCopyWith<_$ExtractDataByRuleWithErrorImpl>
      get copyWith => __$$ExtractDataByRuleWithErrorImplCopyWithImpl<
          _$ExtractDataByRuleWithErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> result) withData,
    required TResult Function(String errorMessage) erorr,
  }) {
    return erorr(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> result)? withData,
    TResult? Function(String errorMessage)? erorr,
  }) {
    return erorr?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> result)? withData,
    TResult Function(String errorMessage)? erorr,
    required TResult orElse(),
  }) {
    if (erorr != null) {
      return erorr(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ExtractDataByRuleWithData value) withData,
    required TResult Function(_ExtractDataByRuleWithError value) erorr,
  }) {
    return erorr(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ExtractDataByRuleWithData value)? withData,
    TResult? Function(_ExtractDataByRuleWithError value)? erorr,
  }) {
    return erorr?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ExtractDataByRuleWithData value)? withData,
    TResult Function(_ExtractDataByRuleWithError value)? erorr,
    required TResult orElse(),
  }) {
    if (erorr != null) {
      return erorr(this);
    }
    return orElse();
  }
}

abstract class _ExtractDataByRuleWithError extends ExtractDataByRule {
  const factory _ExtractDataByRuleWithError(
          {required final String errorMessage}) =
      _$ExtractDataByRuleWithErrorImpl;
  const _ExtractDataByRuleWithError._() : super._();

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$ExtractDataByRuleWithErrorImplCopyWith<_$ExtractDataByRuleWithErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}