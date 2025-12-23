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
import 'package:serverpod/serverpod.dart' as _i1;

enum IpBlockReason implements _i1.SerializableModel {
  unknown,
  torDetected,
  datacenterAbuser,
  knownAbuser,
  crawlerDetected,
  bogonIp;

  static IpBlockReason fromJson(String name) {
    switch (name) {
      case 'unknown':
        return IpBlockReason.unknown;
      case 'torDetected':
        return IpBlockReason.torDetected;
      case 'datacenterAbuser':
        return IpBlockReason.datacenterAbuser;
      case 'knownAbuser':
        return IpBlockReason.knownAbuser;
      case 'crawlerDetected':
        return IpBlockReason.crawlerDetected;
      case 'bogonIp':
        return IpBlockReason.bogonIp;
      default:
        return IpBlockReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
