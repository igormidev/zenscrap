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

abstract class ScrappingBeeExtractLogic implements _i1.SerializableModel {
  ScrappingBeeExtractLogic._({
    this.id,
    this.scrappableId,
    this.scrappable,
    required this.extractRules,
    this.jsScenario,
    required this.renderJs,
    this.wait,
    this.waitFor,
    this.waitBrowser,
    required this.premiumProxy,
    this.countryCode,
    this.sessionId,
    this.customGoogle,
  });

  factory ScrappingBeeExtractLogic({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    required String extractRules,
    String? jsScenario,
    required bool renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    required bool premiumProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  }) = _ScrappingBeeExtractLogicImpl;

  factory ScrappingBeeExtractLogic.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappingBeeExtractLogic(
      id: jsonSerialization['id'] as int?,
      scrappableId: jsonSerialization['scrappableId'] as int?,
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i2.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
      extractRules: jsonSerialization['extractRules'] as String,
      jsScenario: jsonSerialization['jsScenario'] as String?,
      renderJs: jsonSerialization['renderJs'] as bool,
      wait: jsonSerialization['wait'] as int?,
      waitFor: jsonSerialization['waitFor'] as String?,
      waitBrowser: jsonSerialization['waitBrowser'] as String?,
      premiumProxy: jsonSerialization['premiumProxy'] as bool,
      countryCode: jsonSerialization['countryCode'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
      customGoogle: jsonSerialization['customGoogle'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? scrappableId;

  _i2.Scrappable? scrappable;

  String extractRules;

  String? jsScenario;

  bool renderJs;

  int? wait;

  String? waitFor;

  String? waitBrowser;

  bool premiumProxy;

  String? countryCode;

  String? sessionId;

  bool? customGoogle;

  /// Returns a shallow copy of this [ScrappingBeeExtractLogic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappingBeeExtractLogic copyWith({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    String? extractRules,
    String? jsScenario,
    bool? renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    bool? premiumProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (scrappableId != null) 'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
      'extractRules': extractRules,
      if (jsScenario != null) 'jsScenario': jsScenario,
      'renderJs': renderJs,
      if (wait != null) 'wait': wait,
      if (waitFor != null) 'waitFor': waitFor,
      if (waitBrowser != null) 'waitBrowser': waitBrowser,
      'premiumProxy': premiumProxy,
      if (countryCode != null) 'countryCode': countryCode,
      if (sessionId != null) 'sessionId': sessionId,
      if (customGoogle != null) 'customGoogle': customGoogle,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappingBeeExtractLogicImpl extends ScrappingBeeExtractLogic {
  _ScrappingBeeExtractLogicImpl({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    required String extractRules,
    String? jsScenario,
    required bool renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    required bool premiumProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  }) : super._(
          id: id,
          scrappableId: scrappableId,
          scrappable: scrappable,
          extractRules: extractRules,
          jsScenario: jsScenario,
          renderJs: renderJs,
          wait: wait,
          waitFor: waitFor,
          waitBrowser: waitBrowser,
          premiumProxy: premiumProxy,
          countryCode: countryCode,
          sessionId: sessionId,
          customGoogle: customGoogle,
        );

  /// Returns a shallow copy of this [ScrappingBeeExtractLogic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappingBeeExtractLogic copyWith({
    Object? id = _Undefined,
    Object? scrappableId = _Undefined,
    Object? scrappable = _Undefined,
    String? extractRules,
    Object? jsScenario = _Undefined,
    bool? renderJs,
    Object? wait = _Undefined,
    Object? waitFor = _Undefined,
    Object? waitBrowser = _Undefined,
    bool? premiumProxy,
    Object? countryCode = _Undefined,
    Object? sessionId = _Undefined,
    Object? customGoogle = _Undefined,
  }) {
    return ScrappingBeeExtractLogic(
      id: id is int? ? id : this.id,
      scrappableId: scrappableId is int? ? scrappableId : this.scrappableId,
      scrappable: scrappable is _i2.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
      extractRules: extractRules ?? this.extractRules,
      jsScenario: jsScenario is String? ? jsScenario : this.jsScenario,
      renderJs: renderJs ?? this.renderJs,
      wait: wait is int? ? wait : this.wait,
      waitFor: waitFor is String? ? waitFor : this.waitFor,
      waitBrowser: waitBrowser is String? ? waitBrowser : this.waitBrowser,
      premiumProxy: premiumProxy ?? this.premiumProxy,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      customGoogle: customGoogle is bool? ? customGoogle : this.customGoogle,
    );
  }
}
