/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'create_scrappable_stream_item.dart';

abstract class CreateScrappableResult extends _i1.CreateScrappableStreamItem
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  CreateScrappableResult._({
    required this.scrappable,
    this.grounding,
  });

  factory CreateScrappableResult({
    required _i3.Scrappable scrappable,
    _i4.GroundingMetadataInfo? grounding,
  }) = _CreateScrappableResultImpl;

  factory CreateScrappableResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CreateScrappableResult(
      scrappable: _i5.Protocol().deserialize<_i3.Scrappable>(
        jsonSerialization['scrappable'],
      ),
      grounding: jsonSerialization['grounding'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.GroundingMetadataInfo>(
              jsonSerialization['grounding'],
            ),
    );
  }

  _i3.Scrappable scrappable;

  _i4.GroundingMetadataInfo? grounding;

  /// Returns a shallow copy of this [CreateScrappableResult]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  CreateScrappableResult copyWith({
    _i3.Scrappable? scrappable,
    _i4.GroundingMetadataInfo? grounding,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateScrappableResult',
      'scrappable': scrappable.toJson(),
      if (grounding != null) 'grounding': grounding?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreateScrappableResult',
      'scrappable': scrappable.toJsonForProtocol(),
      if (grounding != null) 'grounding': grounding?.toJsonForProtocol(),
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
