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

abstract class AnalyticsRequestDetails implements _i1.SerializableModel {
  AnalyticsRequestDetails._({
    this.id,
    DateTime? timeStamp,
    this.title,
    this.description,
    this.errorObjectAsString,
    this.errorStackTraceAsString,
    required this.stringifiedPayload,
  }) : timeStamp = timeStamp ?? DateTime.now();

  factory AnalyticsRequestDetails({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    required String stringifiedPayload,
  }) = _AnalyticsRequestDetailsImpl;

  factory AnalyticsRequestDetails.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AnalyticsRequestDetails(
      id: jsonSerialization['id'] as int?,
      timeStamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timeStamp']),
      title: jsonSerialization['title'] as String?,
      description: jsonSerialization['description'] as String?,
      errorObjectAsString: jsonSerialization['errorObjectAsString'] as String?,
      errorStackTraceAsString:
          jsonSerialization['errorStackTraceAsString'] as String?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime timeStamp;

  String? title;

  String? description;

  String? errorObjectAsString;

  String? errorStackTraceAsString;

  String stringifiedPayload;

  /// Returns a shallow copy of this [AnalyticsRequestDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnalyticsRequestDetails copyWith({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    String? stringifiedPayload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'timeStamp': timeStamp.toJson(),
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (errorObjectAsString != null)
        'errorObjectAsString': errorObjectAsString,
      if (errorStackTraceAsString != null)
        'errorStackTraceAsString': errorStackTraceAsString,
      'stringifiedPayload': stringifiedPayload,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnalyticsRequestDetailsImpl extends AnalyticsRequestDetails {
  _AnalyticsRequestDetailsImpl({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    required String stringifiedPayload,
  }) : super._(
          id: id,
          timeStamp: timeStamp,
          title: title,
          description: description,
          errorObjectAsString: errorObjectAsString,
          errorStackTraceAsString: errorStackTraceAsString,
          stringifiedPayload: stringifiedPayload,
        );

  /// Returns a shallow copy of this [AnalyticsRequestDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnalyticsRequestDetails copyWith({
    Object? id = _Undefined,
    DateTime? timeStamp,
    Object? title = _Undefined,
    Object? description = _Undefined,
    Object? errorObjectAsString = _Undefined,
    Object? errorStackTraceAsString = _Undefined,
    String? stringifiedPayload,
  }) {
    return AnalyticsRequestDetails(
      id: id is int? ? id : this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      title: title is String? ? title : this.title,
      description: description is String? ? description : this.description,
      errorObjectAsString: errorObjectAsString is String?
          ? errorObjectAsString
          : this.errorObjectAsString,
      errorStackTraceAsString: errorStackTraceAsString is String?
          ? errorStackTraceAsString
          : this.errorStackTraceAsString,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
    );
  }
}
