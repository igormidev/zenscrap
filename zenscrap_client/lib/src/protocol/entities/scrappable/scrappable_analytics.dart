/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../entities/scrappable/request_status.dart' as _i2;
import '../../entities/scrappable/scrappable.dart' as _i3;
import '../../entities/analytics/analytics_request_details.dart' as _i4;
import '../../entities/account/account_api_key.dart' as _i5;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i6;

abstract class ScrappableAnalytics implements _i1.SerializableModel {
  ScrappableAnalytics._({
    this.id,
    required this.requestStatus,
    required this.requestedAt,
    required this.attachedNanoId,
    required this.attachedApiKey,
    required this.scrappableId,
    this.scrappable,
    this.detailsId,
    this.details,
    this.apiKeyId,
    this.apiKey,
  });

  factory ScrappableAnalytics({
    int? id,
    required _i2.RequestStatus requestStatus,
    required DateTime requestedAt,
    required String attachedNanoId,
    required String attachedApiKey,
    required int scrappableId,
    _i3.Scrappable? scrappable,
    int? detailsId,
    _i4.AnalyticsRequestDetails? details,
    int? apiKeyId,
    _i5.AccountApiKey? apiKey,
  }) = _ScrappableAnalyticsImpl;

  factory ScrappableAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScrappableAnalytics(
      id: jsonSerialization['id'] as int?,
      requestStatus: _i2.RequestStatus.fromJson(
        (jsonSerialization['requestStatus'] as String),
      ),
      requestedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['requestedAt'],
      ),
      attachedNanoId: jsonSerialization['attachedNanoId'] as String,
      attachedApiKey: jsonSerialization['attachedApiKey'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.Scrappable>(
              jsonSerialization['scrappable'],
            ),
      detailsId: jsonSerialization['detailsId'] as int?,
      details: jsonSerialization['details'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.AnalyticsRequestDetails>(
              jsonSerialization['details'],
            ),
      apiKeyId: jsonSerialization['apiKeyId'] as int?,
      apiKey: jsonSerialization['apiKey'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.AccountApiKey>(
              jsonSerialization['apiKey'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.RequestStatus requestStatus;

  DateTime requestedAt;

  String attachedNanoId;

  String attachedApiKey;

  int scrappableId;

  _i3.Scrappable? scrappable;

  int? detailsId;

  _i4.AnalyticsRequestDetails? details;

  int? apiKeyId;

  _i5.AccountApiKey? apiKey;

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableAnalytics copyWith({
    int? id,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    String? attachedNanoId,
    String? attachedApiKey,
    int? scrappableId,
    _i3.Scrappable? scrappable,
    int? detailsId,
    _i4.AnalyticsRequestDetails? details,
    int? apiKeyId,
    _i5.AccountApiKey? apiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrappableAnalytics',
      if (id != null) 'id': id,
      'requestStatus': requestStatus.toJson(),
      'requestedAt': requestedAt.toJson(),
      'attachedNanoId': attachedNanoId,
      'attachedApiKey': attachedApiKey,
      'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
      if (detailsId != null) 'detailsId': detailsId,
      if (details != null) 'details': details?.toJson(),
      if (apiKeyId != null) 'apiKeyId': apiKeyId,
      if (apiKey != null) 'apiKey': apiKey?.toJson(),
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
    required String attachedNanoId,
    required String attachedApiKey,
    required int scrappableId,
    _i3.Scrappable? scrappable,
    int? detailsId,
    _i4.AnalyticsRequestDetails? details,
    int? apiKeyId,
    _i5.AccountApiKey? apiKey,
  }) : super._(
         id: id,
         requestStatus: requestStatus,
         requestedAt: requestedAt,
         attachedNanoId: attachedNanoId,
         attachedApiKey: attachedApiKey,
         scrappableId: scrappableId,
         scrappable: scrappable,
         detailsId: detailsId,
         details: details,
         apiKeyId: apiKeyId,
         apiKey: apiKey,
       );

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableAnalytics copyWith({
    Object? id = _Undefined,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    String? attachedNanoId,
    String? attachedApiKey,
    int? scrappableId,
    Object? scrappable = _Undefined,
    Object? detailsId = _Undefined,
    Object? details = _Undefined,
    Object? apiKeyId = _Undefined,
    Object? apiKey = _Undefined,
  }) {
    return ScrappableAnalytics(
      id: id is int? ? id : this.id,
      requestStatus: requestStatus ?? this.requestStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      attachedNanoId: attachedNanoId ?? this.attachedNanoId,
      attachedApiKey: attachedApiKey ?? this.attachedApiKey,
      scrappableId: scrappableId ?? this.scrappableId,
      scrappable: scrappable is _i3.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
      detailsId: detailsId is int? ? detailsId : this.detailsId,
      details: details is _i4.AnalyticsRequestDetails?
          ? details
          : this.details?.copyWith(),
      apiKeyId: apiKeyId is int? ? apiKeyId : this.apiKeyId,
      apiKey: apiKey is _i5.AccountApiKey? ? apiKey : this.apiKey?.copyWith(),
    );
  }
}
