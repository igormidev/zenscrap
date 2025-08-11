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
import 'entities/scrappable.dart' as _i2;
import 'entities/scrappable_target_request.dart' as _i3;
export 'entities/scrappable.dart';
export 'entities/scrappable_target_request.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Scrappable) {
      return _i2.Scrappable.fromJson(data) as T;
    }
    if (t == _i3.ScrappableTargetRequestStructure) {
      return _i3.ScrappableTargetRequestStructure.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Scrappable?>()) {
      return (data != null ? _i2.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ScrappableTargetRequestStructure?>()) {
      return (data != null
          ? _i3.ScrappableTargetRequestStructure.fromJson(data)
          : null) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i3.ScrappableTargetRequestStructure) {
      return 'ScrappableTargetRequestStructure';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i2.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableTargetRequestStructure') {
      return deserialize<_i3.ScrappableTargetRequestStructure>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
