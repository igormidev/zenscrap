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
import '../../entities/ip_validation/ip_block_reason.dart' as _i2;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i3;

abstract class IpValidationCache implements _i1.SerializableModel {
  IpValidationCache._({
    this.id,
    required this.ipAddress,
    required this.updatedAt,
    required this.isLegitimate,
    this.blockReason,
    this.blockReasonEnums,
    required this.isVpn,
    required this.isProxy,
    required this.isTor,
    required this.isDatacenter,
    required this.isAbuser,
    required this.isCrawler,
    required this.isMobile,
    this.companyName,
    this.companyType,
    this.countryCode,
    this.city,
  });

  factory IpValidationCache({
    int? id,
    required String ipAddress,
    required DateTime updatedAt,
    required bool isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    required bool isCrawler,
    required bool isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  }) = _IpValidationCacheImpl;

  factory IpValidationCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return IpValidationCache(
      id: jsonSerialization['id'] as int?,
      ipAddress: jsonSerialization['ipAddress'] as String,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isLegitimate: jsonSerialization['isLegitimate'] as bool,
      blockReason: jsonSerialization['blockReason'] as String?,
      blockReasonEnums: jsonSerialization['blockReasonEnums'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.IpBlockReason>>(
              jsonSerialization['blockReasonEnums'],
            ),
      isVpn: jsonSerialization['isVpn'] as bool,
      isProxy: jsonSerialization['isProxy'] as bool,
      isTor: jsonSerialization['isTor'] as bool,
      isDatacenter: jsonSerialization['isDatacenter'] as bool,
      isAbuser: jsonSerialization['isAbuser'] as bool,
      isCrawler: jsonSerialization['isCrawler'] as bool,
      isMobile: jsonSerialization['isMobile'] as bool,
      companyName: jsonSerialization['companyName'] as String?,
      companyType: jsonSerialization['companyType'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String ipAddress;

  DateTime updatedAt;

  bool isLegitimate;

  String? blockReason;

  List<_i2.IpBlockReason>? blockReasonEnums;

  bool isVpn;

  bool isProxy;

  bool isTor;

  bool isDatacenter;

  bool isAbuser;

  bool isCrawler;

  bool isMobile;

  String? companyName;

  String? companyType;

  String? countryCode;

  String? city;

  /// Returns a shallow copy of this [IpValidationCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IpValidationCache copyWith({
    int? id,
    String? ipAddress,
    DateTime? updatedAt,
    bool? isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    bool? isCrawler,
    bool? isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IpValidationCache',
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'updatedAt': updatedAt.toJson(),
      'isLegitimate': isLegitimate,
      if (blockReason != null) 'blockReason': blockReason,
      if (blockReasonEnums != null)
        'blockReasonEnums': blockReasonEnums?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'isVpn': isVpn,
      'isProxy': isProxy,
      'isTor': isTor,
      'isDatacenter': isDatacenter,
      'isAbuser': isAbuser,
      'isCrawler': isCrawler,
      'isMobile': isMobile,
      if (companyName != null) 'companyName': companyName,
      if (companyType != null) 'companyType': companyType,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IpValidationCacheImpl extends IpValidationCache {
  _IpValidationCacheImpl({
    int? id,
    required String ipAddress,
    required DateTime updatedAt,
    required bool isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    required bool isCrawler,
    required bool isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  }) : super._(
         id: id,
         ipAddress: ipAddress,
         updatedAt: updatedAt,
         isLegitimate: isLegitimate,
         blockReason: blockReason,
         blockReasonEnums: blockReasonEnums,
         isVpn: isVpn,
         isProxy: isProxy,
         isTor: isTor,
         isDatacenter: isDatacenter,
         isAbuser: isAbuser,
         isCrawler: isCrawler,
         isMobile: isMobile,
         companyName: companyName,
         companyType: companyType,
         countryCode: countryCode,
         city: city,
       );

  /// Returns a shallow copy of this [IpValidationCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IpValidationCache copyWith({
    Object? id = _Undefined,
    String? ipAddress,
    DateTime? updatedAt,
    bool? isLegitimate,
    Object? blockReason = _Undefined,
    Object? blockReasonEnums = _Undefined,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    bool? isCrawler,
    bool? isMobile,
    Object? companyName = _Undefined,
    Object? companyType = _Undefined,
    Object? countryCode = _Undefined,
    Object? city = _Undefined,
  }) {
    return IpValidationCache(
      id: id is int? ? id : this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      updatedAt: updatedAt ?? this.updatedAt,
      isLegitimate: isLegitimate ?? this.isLegitimate,
      blockReason: blockReason is String? ? blockReason : this.blockReason,
      blockReasonEnums: blockReasonEnums is List<_i2.IpBlockReason>?
          ? blockReasonEnums
          : this.blockReasonEnums?.map((e0) => e0).toList(),
      isVpn: isVpn ?? this.isVpn,
      isProxy: isProxy ?? this.isProxy,
      isTor: isTor ?? this.isTor,
      isDatacenter: isDatacenter ?? this.isDatacenter,
      isAbuser: isAbuser ?? this.isAbuser,
      isCrawler: isCrawler ?? this.isCrawler,
      isMobile: isMobile ?? this.isMobile,
      companyName: companyName is String? ? companyName : this.companyName,
      companyType: companyType is String? ? companyType : this.companyType,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      city: city is String? ? city : this.city,
    );
  }
}
