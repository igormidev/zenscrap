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
import '../../entities/scrappable/request_status.dart' as _i2;
import '../../entities/scrappable/scrappable.dart' as _i3;

abstract class ScrappableAnalytics implements _i1.SerializableModel {
  ScrappableAnalytics._({
    this.id,
    required this.requestStatus,
    required this.requestedAt,
    required this.scrappableId,
    this.scrappable,
  });

  factory ScrappableAnalytics({
    int? id,
    required _i2.RequestStatus requestStatus,
    required DateTime requestedAt,
    required _i1.UuidValue scrappableId,
    _i3.Scrappable? scrappable,
  }) = _ScrappableAnalyticsImpl;

  factory ScrappableAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScrappableAnalytics(
      id: jsonSerialization['id'] as int?,
      requestStatus: _i2.RequestStatus.fromJson(
          (jsonSerialization['requestStatus'] as int)),
      requestedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['requestedAt']),
      scrappableId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['scrappableId']),
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i3.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.RequestStatus requestStatus;

  DateTime requestedAt;

  _i1.UuidValue scrappableId;

  _i3.Scrappable? scrappable;

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableAnalytics copyWith({
    int? id,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    _i1.UuidValue? scrappableId,
    _i3.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'requestStatus': requestStatus.toJson(),
      'requestedAt': requestedAt.toJson(),
      'scrappableId': scrappableId.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableAnalyticsImpl extends ScrappableAnalytics {
  _ScrappableAnalyticsImpl({
    int? id,
    required _i2.RequestStatus requestStatus,
    required DateTime requestedAt,
    required _i1.UuidValue scrappableId,
    _i3.Scrappable? scrappable,
  }) : super._(
          id: id,
          requestStatus: requestStatus,
          requestedAt: requestedAt,
          scrappableId: scrappableId,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableAnalytics copyWith({
    Object? id = _Undefined,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    _i1.UuidValue? scrappableId,
    Object? scrappable = _Undefined,
  }) {
    return ScrappableAnalytics(
      id: id is int? ? id : this.id,
      requestStatus: requestStatus ?? this.requestStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      scrappableId: scrappableId ?? this.scrappableId,
      scrappable: scrappable is _i3.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}
