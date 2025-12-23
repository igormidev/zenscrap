// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranslationState {

/// The original untranslated text
 String get originalText;/// The source language code (e.g., "enUS", "esES")
 String get sourceLanguage;/// The translated text (null if not yet translated or translation failed)
 String? get translatedText;/// Whether the translation is currently loading
 bool get isLoading;/// Whether to show the original text (true) or translated text (false)
 bool get showOriginal;/// Whether translation has been attempted
 bool get translationAttempted;/// Error message if translation failed
 String? get errorMessage;
/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationStateCopyWith<TranslationState> get copyWith => _$TranslationStateCopyWithImpl<TranslationState>(this as TranslationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationState&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showOriginal, showOriginal) || other.showOriginal == showOriginal)&&(identical(other.translationAttempted, translationAttempted) || other.translationAttempted == translationAttempted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,originalText,sourceLanguage,translatedText,isLoading,showOriginal,translationAttempted,errorMessage);

@override
String toString() {
  return 'TranslationState(originalText: $originalText, sourceLanguage: $sourceLanguage, translatedText: $translatedText, isLoading: $isLoading, showOriginal: $showOriginal, translationAttempted: $translationAttempted, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TranslationStateCopyWith<$Res>  {
  factory $TranslationStateCopyWith(TranslationState value, $Res Function(TranslationState) _then) = _$TranslationStateCopyWithImpl;
@useResult
$Res call({
 String originalText, String sourceLanguage, String? translatedText, bool isLoading, bool showOriginal, bool translationAttempted, String? errorMessage
});




}
/// @nodoc
class _$TranslationStateCopyWithImpl<$Res>
    implements $TranslationStateCopyWith<$Res> {
  _$TranslationStateCopyWithImpl(this._self, this._then);

  final TranslationState _self;
  final $Res Function(TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalText = null,Object? sourceLanguage = null,Object? translatedText = freezed,Object? isLoading = null,Object? showOriginal = null,Object? translationAttempted = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,translatedText: freezed == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showOriginal: null == showOriginal ? _self.showOriginal : showOriginal // ignore: cast_nullable_to_non_nullable
as bool,translationAttempted: null == translationAttempted ? _self.translationAttempted : translationAttempted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationState].
extension TranslationStatePatterns on TranslationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationState value)  $default,){
final _that = this;
switch (_that) {
case _TranslationState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationState value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalText,  String sourceLanguage,  String? translatedText,  bool isLoading,  bool showOriginal,  bool translationAttempted,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.originalText,_that.sourceLanguage,_that.translatedText,_that.isLoading,_that.showOriginal,_that.translationAttempted,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalText,  String sourceLanguage,  String? translatedText,  bool isLoading,  bool showOriginal,  bool translationAttempted,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TranslationState():
return $default(_that.originalText,_that.sourceLanguage,_that.translatedText,_that.isLoading,_that.showOriginal,_that.translationAttempted,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalText,  String sourceLanguage,  String? translatedText,  bool isLoading,  bool showOriginal,  bool translationAttempted,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.originalText,_that.sourceLanguage,_that.translatedText,_that.isLoading,_that.showOriginal,_that.translationAttempted,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TranslationState implements TranslationState {
   _TranslationState({required this.originalText, required this.sourceLanguage, this.translatedText, this.isLoading = false, this.showOriginal = false, this.translationAttempted = false, this.errorMessage});
  

/// The original untranslated text
@override final  String originalText;
/// The source language code (e.g., "enUS", "esES")
@override final  String sourceLanguage;
/// The translated text (null if not yet translated or translation failed)
@override final  String? translatedText;
/// Whether the translation is currently loading
@override@JsonKey() final  bool isLoading;
/// Whether to show the original text (true) or translated text (false)
@override@JsonKey() final  bool showOriginal;
/// Whether translation has been attempted
@override@JsonKey() final  bool translationAttempted;
/// Error message if translation failed
@override final  String? errorMessage;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationStateCopyWith<_TranslationState> get copyWith => __$TranslationStateCopyWithImpl<_TranslationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationState&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showOriginal, showOriginal) || other.showOriginal == showOriginal)&&(identical(other.translationAttempted, translationAttempted) || other.translationAttempted == translationAttempted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,originalText,sourceLanguage,translatedText,isLoading,showOriginal,translationAttempted,errorMessage);

@override
String toString() {
  return 'TranslationState(originalText: $originalText, sourceLanguage: $sourceLanguage, translatedText: $translatedText, isLoading: $isLoading, showOriginal: $showOriginal, translationAttempted: $translationAttempted, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TranslationStateCopyWith<$Res> implements $TranslationStateCopyWith<$Res> {
  factory _$TranslationStateCopyWith(_TranslationState value, $Res Function(_TranslationState) _then) = __$TranslationStateCopyWithImpl;
@override @useResult
$Res call({
 String originalText, String sourceLanguage, String? translatedText, bool isLoading, bool showOriginal, bool translationAttempted, String? errorMessage
});




}
/// @nodoc
class __$TranslationStateCopyWithImpl<$Res>
    implements _$TranslationStateCopyWith<$Res> {
  __$TranslationStateCopyWithImpl(this._self, this._then);

  final _TranslationState _self;
  final $Res Function(_TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalText = null,Object? sourceLanguage = null,Object? translatedText = freezed,Object? isLoading = null,Object? showOriginal = null,Object? translationAttempted = null,Object? errorMessage = freezed,}) {
  return _then(_TranslationState(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,translatedText: freezed == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showOriginal: null == showOriginal ? _self.showOriginal : showOriginal // ignore: cast_nullable_to_non_nullable
as bool,translationAttempted: null == translationAttempted ? _self.translationAttempted : translationAttempted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
