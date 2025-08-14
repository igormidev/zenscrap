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
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i4;
import 'entities/redraft_scrappable_session/zen_scrap_redraft_state.dart'
    as _i5;
import 'entities/scrappable/reference_test_data.dart' as _i6;
import 'entities/scrappable/scrappable.dart' as _i7;
import 'entities/scrappable/scrappable_request.dart' as _i8;
import 'entities/scrappable/scrappable_test_result.dart' as _i9;
import 'entities/zenscrap_exception.dart' as _i10;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i11;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/redraft_scrappable_session/zen_scrap_redraft_state.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_request.dart';
export 'entities/scrappable/scrappable_test_result.dart';
export 'entities/zenscrap_exception.dart';
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
    if (t == _i4.PromptRole) {
      return _i4.PromptRole.fromJson(data) as T;
    }
    if (t == _i5.ErrorTextResponse) {
      return _i5.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i5.MessageTextAndNewExtractRulesResponse) {
      return _i5.MessageTextAndNewExtractRulesResponse.fromJson(data) as T;
    }
    if (t == _i5.MessageTextResponse) {
      return _i5.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i5.NewExtractRuleResponse) {
      return _i5.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i6.ReferenceTestData) {
      return _i6.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i7.Scrappable) {
      return _i7.Scrappable.fromJson(data) as T;
    }
    if (t == _i8.ScrappableRequest) {
      return _i8.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i9.ScrappableTestResult) {
      return _i9.ScrappableTestResult.fromJson(data) as T;
    }
    if (t == _i10.ZenScrapException) {
      return _i10.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountInfo?>()) {
      return (data != null ? _i2.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccountApiKey?>()) {
      return (data != null ? _i3.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.PromptRole?>()) {
      return (data != null ? _i4.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ErrorTextResponse?>()) {
      return (data != null ? _i5.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.MessageTextAndNewExtractRulesResponse?>()) {
      return (data != null
          ? _i5.MessageTextAndNewExtractRulesResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.MessageTextResponse?>()) {
      return (data != null ? _i5.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.NewExtractRuleResponse?>()) {
      return (data != null ? _i5.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ReferenceTestData?>()) {
      return (data != null ? _i6.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Scrappable?>()) {
      return (data != null ? _i7.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ScrappableRequest?>()) {
      return (data != null ? _i8.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ScrappableTestResult?>()) {
      return (data != null ? _i9.ScrappableTestResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ZenScrapException?>()) {
      return (data != null ? _i10.ZenScrapException.fromJson(data) : null) as T;
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
      return _i11.Protocol().deserialize<T>(data, t);
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
    if (data is _i4.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i5.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i5.MessageTextAndNewExtractRulesResponse) {
      return 'MessageTextAndNewExtractRulesResponse';
    }
    if (data is _i5.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i5.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i6.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i7.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i8.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i9.ScrappableTestResult) {
      return 'ScrappableTestResult';
    }
    if (data is _i10.ZenScrapException) {
      return 'ZenScrapException';
    }
    className = _i11.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'PromptRole') {
      return deserialize<_i4.PromptRole>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i5.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextAndNewExtractRulesResponse') {
      return deserialize<_i5.MessageTextAndNewExtractRulesResponse>(
          data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i5.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i5.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i6.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i7.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i8.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappableTestResult') {
      return deserialize<_i9.ScrappableTestResult>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i10.ZenScrapException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i11.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
