/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'create_scrappable_stream_item.dart';

abstract class CreateScrappableThinkingChunk
    extends _i1.CreateScrappableStreamItem implements _i2.SerializableModel {
  CreateScrappableThinkingChunk._({required this.thinkingText});

  factory CreateScrappableThinkingChunk({required String thinkingText}) =
      _CreateScrappableThinkingChunkImpl;

  factory CreateScrappableThinkingChunk.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CreateScrappableThinkingChunk(
        thinkingText: jsonSerialization['thinkingText'] as String);
  }

  String thinkingText;

  /// Returns a shallow copy of this [CreateScrappableThinkingChunk]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  CreateScrappableThinkingChunk copyWith({String? thinkingText});
  @override
  Map<String, dynamic> toJson() {
    return {'thinkingText': thinkingText};
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _CreateScrappableThinkingChunkImpl extends CreateScrappableThinkingChunk {
  _CreateScrappableThinkingChunkImpl({required String thinkingText})
      : super._(thinkingText: thinkingText);

  /// Returns a shallow copy of this [CreateScrappableThinkingChunk]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CreateScrappableThinkingChunk copyWith({String? thinkingText}) {
    return CreateScrappableThinkingChunk(
        thinkingText: thinkingText ?? this.thinkingText);
  }
}
