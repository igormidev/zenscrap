/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class MonthlyCreditsData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MonthlyCreditsData._({required this.accountInfoId});

  factory MonthlyCreditsData({required int accountInfoId}) =
      _MonthlyCreditsDataImpl;

  factory MonthlyCreditsData.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonthlyCreditsData(
        accountInfoId: jsonSerialization['accountInfoId'] as int);
  }

  int accountInfoId;

  /// Returns a shallow copy of this [MonthlyCreditsData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlyCreditsData copyWith({int? accountInfoId});
  @override
  Map<String, dynamic> toJson() {
    return {'accountInfoId': accountInfoId};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'accountInfoId': accountInfoId};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MonthlyCreditsDataImpl extends MonthlyCreditsData {
  _MonthlyCreditsDataImpl({required int accountInfoId})
      : super._(accountInfoId: accountInfoId);

  /// Returns a shallow copy of this [MonthlyCreditsData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlyCreditsData copyWith({int? accountInfoId}) {
    return MonthlyCreditsData(
        accountInfoId: accountInfoId ?? this.accountInfoId);
  }
}
