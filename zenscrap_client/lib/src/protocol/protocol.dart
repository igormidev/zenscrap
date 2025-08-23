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
import 'entities/account/api_usage/account_api_usage.dart' as _i4;
import 'entities/account/api_usage/api_creadit_history/api_creadit_history_item.dart'
    as _i5;
import 'entities/account/api_usage/api_creadit_history/credit_package_purchase.dart'
    as _i6;
import 'entities/account/api_usage/api_creadit_history/monthly_subscription_credit_deposit.dart'
    as _i7;
import 'entities/account/plan_tier.dart' as _i8;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i9;
import 'entities/marketplace/pagination_metadata.dart' as _i10;
import 'entities/monthly_credits_data.dart' as _i11;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i12;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i13;
import 'entities/redraft_scrappable_session/chat_response.dart' as _i14;
import 'entities/scrappable/reference_test_data.dart' as _i15;
import 'entities/scrappable/request_status.dart' as _i16;
import 'entities/scrappable/scrappable.dart' as _i17;
import 'entities/scrappable/scrappable_analytics.dart' as _i18;
import 'entities/scrappable/scrappable_request.dart' as _i19;
import 'entities/scrappable/scrappable_test_result.dart' as _i20;
import 'entities/zenscrap_exception.dart' as _i21;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scrappable.dart'
    as _i22;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i23;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_creadit_history/api_creadit_history_item.dart';
export 'entities/account/api_usage/api_creadit_history/credit_package_purchase.dart';
export 'entities/account/api_usage/api_creadit_history/monthly_subscription_credit_deposit.dart';
export 'entities/account/plan_tier.dart';
export 'entities/marketplace/paginated_scrappable_response.dart';
export 'entities/marketplace/pagination_metadata.dart';
export 'entities/monthly_credits_data.dart';
export 'entities/redraft_scrappable_session/chat_response.dart';
export 'entities/redraft_scrappable_session/create_session_response.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/request_status.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_analytics.dart';
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
    if (t == _i4.AccountApiUsage) {
      return _i4.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i5.CreditHistoryItem) {
      return _i5.CreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i6.CreditPackagePurchase) {
      return _i6.CreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i7.MonthlySubscriptionCreditDeposit) {
      return _i7.MonthlySubscriptionCreditDeposit.fromJson(data) as T;
    }
    if (t == _i8.PlanTier) {
      return _i8.PlanTier.fromJson(data) as T;
    }
    if (t == _i9.PaginatedScrappableResponse) {
      return _i9.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i10.PaginationMetadata) {
      return _i10.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i11.MonthlyCreditsData) {
      return _i11.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i12.CreateSessionResponse) {
      return _i12.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i13.PromptRole) {
      return _i13.PromptRole.fromJson(data) as T;
    }
    if (t == _i14.ErrorTextResponse) {
      return _i14.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i14.MessageTextAndNewExtractRulesResponse) {
      return _i14.MessageTextAndNewExtractRulesResponse.fromJson(data) as T;
    }
    if (t == _i14.MessageTextResponse) {
      return _i14.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i14.NewExtractRuleResponse) {
      return _i14.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i15.ReferenceTestData) {
      return _i15.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i16.RequestStatus) {
      return _i16.RequestStatus.fromJson(data) as T;
    }
    if (t == _i17.Scrappable) {
      return _i17.Scrappable.fromJson(data) as T;
    }
    if (t == _i18.ScrappableAnalytics) {
      return _i18.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i19.ScrappableRequest) {
      return _i19.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i20.ScrappableTestResult) {
      return _i20.ScrappableTestResult.fromJson(data) as T;
    }
    if (t == _i21.ZenScrapException) {
      return _i21.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountInfo?>()) {
      return (data != null ? _i2.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccountApiKey?>()) {
      return (data != null ? _i3.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AccountApiUsage?>()) {
      return (data != null ? _i4.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CreditHistoryItem?>()) {
      return (data != null ? _i5.CreditHistoryItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CreditPackagePurchase?>()) {
      return (data != null ? _i6.CreditPackagePurchase.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.MonthlySubscriptionCreditDeposit?>()) {
      return (data != null
          ? _i7.MonthlySubscriptionCreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.PlanTier?>()) {
      return (data != null ? _i8.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PaginatedScrappableResponse?>()) {
      return (data != null
          ? _i9.PaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.PaginationMetadata?>()) {
      return (data != null ? _i10.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.MonthlyCreditsData?>()) {
      return (data != null ? _i11.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.CreateSessionResponse?>()) {
      return (data != null ? _i12.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.PromptRole?>()) {
      return (data != null ? _i13.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ErrorTextResponse?>()) {
      return (data != null ? _i14.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.MessageTextAndNewExtractRulesResponse?>()) {
      return (data != null
          ? _i14.MessageTextAndNewExtractRulesResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.MessageTextResponse?>()) {
      return (data != null ? _i14.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.NewExtractRuleResponse?>()) {
      return (data != null ? _i14.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ReferenceTestData?>()) {
      return (data != null ? _i15.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.RequestStatus?>()) {
      return (data != null ? _i16.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Scrappable?>()) {
      return (data != null ? _i17.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ScrappableAnalytics?>()) {
      return (data != null ? _i18.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ScrappableRequest?>()) {
      return (data != null ? _i19.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ScrappableTestResult?>()) {
      return (data != null ? _i20.ScrappableTestResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ZenScrapException?>()) {
      return (data != null ? _i21.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i17.Scrappable>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i17.Scrappable>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i5.CreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i5.CreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i3.AccountApiKey>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i3.AccountApiKey>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i17.Scrappable>) {
      return (data as List).map((e) => deserialize<_i17.Scrappable>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i18.ScrappableAnalytics>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i18.ScrappableAnalytics>(e))
              .toList()
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
    if (t == List<_i22.Scrappable>) {
      return (data as List).map((e) => deserialize<_i22.Scrappable>(e)).toList()
          as T;
    }
    try {
      return _i23.Protocol().deserialize<T>(data, t);
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
    if (data is _i4.AccountApiUsage) {
      return 'AccountApiUsage';
    }
    if (data is _i5.CreditHistoryItem) {
      return 'CreditHistoryItem';
    }
    if (data is _i6.CreditPackagePurchase) {
      return 'CreditPackagePurchase';
    }
    if (data is _i7.MonthlySubscriptionCreditDeposit) {
      return 'MonthlySubscriptionCreditDeposit';
    }
    if (data is _i8.PlanTier) {
      return 'PlanTier';
    }
    if (data is _i9.PaginatedScrappableResponse) {
      return 'PaginatedScrappableResponse';
    }
    if (data is _i10.PaginationMetadata) {
      return 'PaginationMetadata';
    }
    if (data is _i11.MonthlyCreditsData) {
      return 'MonthlyCreditsData';
    }
    if (data is _i12.CreateSessionResponse) {
      return 'CreateSessionResponse';
    }
    if (data is _i13.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i14.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i14.MessageTextAndNewExtractRulesResponse) {
      return 'MessageTextAndNewExtractRulesResponse';
    }
    if (data is _i14.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i14.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i15.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i16.RequestStatus) {
      return 'RequestStatus';
    }
    if (data is _i17.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i18.ScrappableAnalytics) {
      return 'ScrappableAnalytics';
    }
    if (data is _i19.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i20.ScrappableTestResult) {
      return 'ScrappableTestResult';
    }
    if (data is _i21.ZenScrapException) {
      return 'ZenScrapException';
    }
    className = _i23.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i4.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'CreditHistoryItem') {
      return deserialize<_i5.CreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'CreditPackagePurchase') {
      return deserialize<_i6.CreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionCreditDeposit') {
      return deserialize<_i7.MonthlySubscriptionCreditDeposit>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i8.PlanTier>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i9.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i10.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i11.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i12.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i13.PromptRole>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i14.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextAndNewExtractRulesResponse') {
      return deserialize<_i14.MessageTextAndNewExtractRulesResponse>(
          data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i14.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i14.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i15.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i16.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i17.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i18.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i19.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappableTestResult') {
      return deserialize<_i20.ScrappableTestResult>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i21.ZenScrapException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i23.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
