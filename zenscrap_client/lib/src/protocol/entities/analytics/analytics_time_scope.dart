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

enum AnalyticsTimeScope implements _i1.SerializableModel {
  lastHour,
  last12Hours,
  last24Hours,
  last7Days,
  last30Days;

  static AnalyticsTimeScope fromJson(String name) {
    switch (name) {
      case 'lastHour':
        return AnalyticsTimeScope.lastHour;
      case 'last12Hours':
        return AnalyticsTimeScope.last12Hours;
      case 'last24Hours':
        return AnalyticsTimeScope.last24Hours;
      case 'last7Days':
        return AnalyticsTimeScope.last7Days;
      case 'last30Days':
        return AnalyticsTimeScope.last30Days;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AnalyticsTimeScope"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
