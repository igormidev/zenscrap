/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../entities/scrappable/scrappable.dart' as _i2;

abstract class ScrappableTargetRequestStructure
    implements _i1.SerializableModel {
  ScrappableTargetRequestStructure._({
    this.id,
    required this.url,
    required this.queryParams,
    required this.pathParams,
    this.scrappable,
  });

  factory ScrappableTargetRequestStructure({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) = _ScrappableTargetRequestStructureImpl;

  factory ScrappableTargetRequestStructure.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableTargetRequestStructure(
      id: jsonSerialization['id'] as int?,
      url: jsonSerialization['url'] as String,
      queryParams:
          (jsonSerialization['queryParams'] as Map).map((k, v) => MapEntry(
                k as String,
                v as String?,
              )),
      pathParams: (jsonSerialization['pathParams'] as List)
          .map((e) => e as String)
          .toList(),
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i2.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String url;

  Map<String, String?> queryParams;

  List<String> pathParams;

  _i2.Scrappable? scrappable;

  /// Returns a shallow copy of this [ScrappableTargetRequestStructure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableTargetRequestStructure copyWith({
    int? id,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    _i2.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      'queryParams': queryParams.toJson(),
      'pathParams': pathParams.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableTargetRequestStructureImpl
    extends ScrappableTargetRequestStructure {
  _ScrappableTargetRequestStructureImpl({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) : super._(
          id: id,
          url: url,
          queryParams: queryParams,
          pathParams: pathParams,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ScrappableTargetRequestStructure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableTargetRequestStructure copyWith({
    Object? id = _Undefined,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    Object? scrappable = _Undefined,
  }) {
    return ScrappableTargetRequestStructure(
      id: id is int? ? id : this.id,
      url: url ?? this.url,
      queryParams: queryParams ??
          this.queryParams.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      pathParams: pathParams ?? this.pathParams.map((e0) => e0).toList(),
      scrappable: scrappable is _i2.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}
