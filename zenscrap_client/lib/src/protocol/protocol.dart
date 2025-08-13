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
import 'entities/account/account.dart' as _i2;
import 'entities/account/account_api_key.dart' as _i3;
import 'entities/scrappable.dart' as _i4;
import 'entities/scrappable_target_request.dart' as _i5;
import 'entities/zenscrap_exception.dart' as _i6;
import 'generated/entities/redraft_scrappable_session/zen_scrap_redraft_state.dart'
    as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/scrappable.dart';
export 'entities/scrappable_target_request.dart';
export 'entities/zenscrap_exception.dart';
export 'generated/entities/redraft_scrappable_session/zen_scrap_redraft_state.dart';
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
    if (t == _i2.AccountInfo) {
      return _i2.AccountInfo.fromJson(data) as T;
    }
    if (t == _i3.AccountApiKey) {
      return _i3.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i4.Scrappable) {
      return _i4.Scrappable.fromJson(data) as T;
    }
    if (t == _i5.ScrappableTargetRequestStructure) {
      return _i5.ScrappableTargetRequestStructure.fromJson(data) as T;
    }
    if (t == _i6.ZenScrapException) {
      return _i6.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i7.PromptAiErrorResponse) {
      return _i7.PromptAiErrorResponse.fromJson(data) as T;
    }
    if (t == _i7.PromptAiOnlyTextResponse) {
      return _i7.PromptAiOnlyTextResponse.fromJson(data) as T;
    }
    if (t == _i7.PromptAiTextAndNewExtractRulesResponse) {
      return _i7.PromptAiTextAndNewExtractRulesResponse.fromJson(data) as T;
    }
    if (t == _i7.PromptZenScrapSystemResponse) {
      return _i7.PromptZenScrapSystemResponse.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountInfo?>()) {
      return (data != null ? _i2.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccountApiKey?>()) {
      return (data != null ? _i3.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Scrappable?>()) {
      return (data != null ? _i4.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ScrappableTargetRequestStructure?>()) {
      return (data != null
          ? _i5.ScrappableTargetRequestStructure.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.ZenScrapException?>()) {
      return (data != null ? _i6.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PromptAiErrorResponse?>()) {
      return (data != null ? _i7.PromptAiErrorResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.PromptAiOnlyTextResponse?>()) {
      return (data != null ? _i7.PromptAiOnlyTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.PromptAiTextAndNewExtractRulesResponse?>()) {
      return (data != null
          ? _i7.PromptAiTextAndNewExtractRulesResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.PromptZenScrapSystemResponse?>()) {
      return (data != null
          ? _i7.PromptZenScrapSystemResponse.fromJson(data)
          : null) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i3.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i4.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i5.ScrappableTargetRequestStructure) {
      return 'ScrappableTargetRequestStructure';
    }
    if (data is _i6.ZenScrapException) {
      return 'ZenScrapException';
    }
    if (data is _i7.PromptAiErrorResponse) {
      return 'PromptAiErrorResponse';
    }
    if (data is _i7.PromptAiOnlyTextResponse) {
      return 'PromptAiOnlyTextResponse';
    }
    if (data is _i7.PromptAiTextAndNewExtractRulesResponse) {
      return 'PromptAiTextAndNewExtractRulesResponse';
    }
    if (data is _i7.PromptZenScrapSystemResponse) {
      return 'PromptZenScrapSystemResponse';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i2.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i3.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i4.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableTargetRequestStructure') {
      return deserialize<_i5.ScrappableTargetRequestStructure>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i6.ZenScrapException>(data['data']);
    }
    if (dataClassName == 'PromptAiErrorResponse') {
      return deserialize<_i7.PromptAiErrorResponse>(data['data']);
    }
    if (dataClassName == 'PromptAiOnlyTextResponse') {
      return deserialize<_i7.PromptAiOnlyTextResponse>(data['data']);
    }
    if (dataClassName == 'PromptAiTextAndNewExtractRulesResponse') {
      return deserialize<_i7.PromptAiTextAndNewExtractRulesResponse>(
          data['data']);
    }
    if (dataClassName == 'PromptZenScrapSystemResponse') {
      return deserialize<_i7.PromptZenScrapSystemResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
