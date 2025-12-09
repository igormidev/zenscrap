/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'create_scrappable_stream_item.dart';

abstract class CreateScrappableResult extends _i1.CreateScrappableStreamItem
    implements _i2.SerializableModel {
  CreateScrappableResult._({
    required this.scrappable,
    this.grounding,
  });

  factory CreateScrappableResult({
    required _i3.Scrappable scrappable,
    _i4.GroundingMetadataInfo? grounding,
  }) = _CreateScrappableResultImpl;

  factory CreateScrappableResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CreateScrappableResult(
      scrappable: _i3.Scrappable.fromJson(
          (jsonSerialization['scrappable'] as Map<String, dynamic>)),
      grounding: jsonSerialization['grounding'] == null
          ? null
          : _i4.GroundingMetadataInfo.fromJson(
              (jsonSerialization['grounding'] as Map<String, dynamic>)),
    );
  }

  _i3.Scrappable scrappable;

  _i4.GroundingMetadataInfo? grounding;

  /// Returns a shallow copy of this [CreateScrappableResult]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  CreateScrappableResult copyWith({
    _i3.Scrappable? scrappable,
    _i4.GroundingMetadataInfo? grounding,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'scrappable': scrappable.toJson(),
      if (grounding != null) 'grounding': grounding?.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _CreateScrappableResultImpl extends CreateScrappableResult {
  _CreateScrappableResultImpl({
    required _i3.Scrappable scrappable,
    _i4.GroundingMetadataInfo? grounding,
  }) : super._(
          scrappable: scrappable,
          grounding: grounding,
        );

  /// Returns a shallow copy of this [CreateScrappableResult]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CreateScrappableResult copyWith({
    _i3.Scrappable? scrappable,
    Object? grounding = _Undefined,
  }) {
    return CreateScrappableResult(
      scrappable: scrappable ?? this.scrappable.copyWith(),
      grounding: grounding is _i4.GroundingMetadataInfo?
          ? grounding
          : this.grounding?.copyWith(),
    );
  }
}
