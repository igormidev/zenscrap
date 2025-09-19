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
import 'entities/redraft_scrappable_session/chat_response.dart' as _i2;
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i3;
import 'entities/account/account_api_key.dart' as _i4;
import 'entities/account/api_usage/credit_usage.dart' as _i5;
import 'entities/account/credit_purchase_option.dart' as _i6;
import 'entities/account/plan_tier.dart' as _i7;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i8;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart' as _i9;
import 'entities/analytics/scraapable_request_per_day.dart' as _i10;
import 'entities/account/account.dart' as _i11;
import 'entities/api_key_response.dart' as _i12;
import 'entities/future_calls/session_prompt.dart' as _i13;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i14;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i15;
import 'entities/marketplace/pagination_metadata.dart' as _i16;
import 'entities/monthly_credits_data.dart' as _i17;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i18;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i19;
import 'entities/account/api_usage/account_api_usage.dart' as _i20;
import 'entities/zenscrap_exception.dart' as _i21;
import 'entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i22;
import 'entities/account/api_usage/api_credit_history/credit_package_purchase.dart'
    as _i23;
import 'entities/scrappable/ai_model.dart' as _i24;
import 'entities/scrappable/byte_test_data.dart' as _i25;
import 'entities/scrappable/reference_test_data.dart' as _i26;
import 'entities/scrappable/request_status.dart' as _i27;
import 'entities/scrappable/scraper_category.dart' as _i28;
import 'entities/scrappable/scrappable.dart' as _i29;
import 'entities/scrappable/scrappable_analytics.dart' as _i30;
import 'entities/scrappable/scrappable_request.dart' as _i31;
import 'entities/scrappable/scrapping_bee_extract_logic.dart' as _i32;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_credit_deposit.dart'
    as _i33;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i34;
import 'package:zenscrap_client/src/protocol/entities/account/account_api_key.dart'
    as _i35;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scrappable.dart'
    as _i36;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i37;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_credit_history/api_creadit_history_item.dart';
export 'entities/account/api_usage/api_credit_history/credit_package_purchase.dart';
export 'entities/account/api_usage/api_credit_history/monthly_subscription_credit_deposit.dart';
export 'entities/account/api_usage/credit_usage.dart';
export 'entities/account/credit_purchase_option.dart';
export 'entities/account/plan_tier.dart';
export 'entities/analytics/paginated_scrappable_analytics.dart';
export 'entities/analytics/paginated_scrappable_requests_analytics.dart';
export 'entities/analytics/scraapable_request_per_day.dart';
export 'entities/analytics/scrappable_requests_analytics_item.dart';
export 'entities/api_key_response.dart';
export 'entities/future_calls/session_prompt.dart';
export 'entities/marketplace/marketplace_paginated_item.dart';
export 'entities/marketplace/paginated_scrappable_response.dart';
export 'entities/marketplace/pagination_metadata.dart';
export 'entities/monthly_credits_data.dart';
export 'entities/redraft_scrappable_session/chat_response.dart';
export 'entities/redraft_scrappable_session/create_session_response.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/scrappable/ai_model.dart';
export 'entities/scrappable/byte_test_data.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/request_status.dart';
export 'entities/scrappable/scraper_category.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_analytics.dart';
export 'entities/scrappable/scrappable_request.dart';
export 'entities/scrappable/scrapping_bee_extract_logic.dart';
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
    if (t == _i2.NewExtractRuleResponse) {
      return _i2.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i2.ErrorTextResponse) {
      return _i2.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i2.CandidateExtractLogicUpdate) {
      return _i2.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i2.MessageTextResponse) {
      return _i2.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i3.ScrappableRequestsAnalyticsItem) {
      return _i3.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i4.AccountApiKey) {
      return _i4.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i5.CreditUsage) {
      return _i5.CreditUsage.fromJson(data) as T;
    }
    if (t == _i6.CreditPurchaseOption) {
      return _i6.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i7.PlanTier) {
      return _i7.PlanTier.fromJson(data) as T;
    }
    if (t == _i8.PaginatedScrappableAnalytics) {
      return _i8.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i9.PaginatedScrappableRequestsAnalytics) {
      return _i9.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i10.ScrappableRequestPerHour) {
      return _i10.ScrappableRequestPerHour.fromJson(data) as T;
    }
    if (t == _i11.AccountInfo) {
      return _i11.AccountInfo.fromJson(data) as T;
    }
    if (t == _i12.ApiKeyResponse) {
      return _i12.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i13.SessionPrompt) {
      return _i13.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i14.MarketPlacePaginatedItem) {
      return _i14.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i15.PaginatedScrappableResponse) {
      return _i15.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i16.PaginationMetadata) {
      return _i16.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i17.MonthlyCreditsData) {
      return _i17.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i18.CreateSessionResponse) {
      return _i18.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i19.PromptRole) {
      return _i19.PromptRole.fromJson(data) as T;
    }
    if (t == _i20.AccountApiUsage) {
      return _i20.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i21.ZenScrapException) {
      return _i21.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i22.CreditHistoryItem) {
      return _i22.CreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i23.CreditPackagePurchase) {
      return _i23.CreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i24.AiModel) {
      return _i24.AiModel.fromJson(data) as T;
    }
    if (t == _i25.ByteTestData) {
      return _i25.ByteTestData.fromJson(data) as T;
    }
    if (t == _i26.ReferenceTestData) {
      return _i26.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i27.RequestStatus) {
      return _i27.RequestStatus.fromJson(data) as T;
    }
    if (t == _i28.ScraperCategory) {
      return _i28.ScraperCategory.fromJson(data) as T;
    }
    if (t == _i29.Scrappable) {
      return _i29.Scrappable.fromJson(data) as T;
    }
    if (t == _i30.ScrappableAnalytics) {
      return _i30.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i31.ScrappableRequest) {
      return _i31.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i32.ScrappingBeeExtractLogic) {
      return _i32.ScrappingBeeExtractLogic.fromJson(data) as T;
    }
    if (t == _i33.MonthlySubscriptionCreditDeposit) {
      return _i33.MonthlySubscriptionCreditDeposit.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.NewExtractRuleResponse?>()) {
      return (data != null ? _i2.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.ErrorTextResponse?>()) {
      return (data != null ? _i2.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.CandidateExtractLogicUpdate?>()) {
      return (data != null
          ? _i2.CandidateExtractLogicUpdate.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.MessageTextResponse?>()) {
      return (data != null ? _i2.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
          ? _i3.ScrappableRequestsAnalyticsItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.AccountApiKey?>()) {
      return (data != null ? _i4.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CreditUsage?>()) {
      return (data != null ? _i5.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CreditPurchaseOption?>()) {
      return (data != null ? _i6.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.PlanTier?>()) {
      return (data != null ? _i7.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PaginatedScrappableAnalytics?>()) {
      return (data != null
          ? _i8.PaginatedScrappableAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
          ? _i9.PaginatedScrappableRequestsAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.ScrappableRequestPerHour?>()) {
      return (data != null
          ? _i10.ScrappableRequestPerHour.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.AccountInfo?>()) {
      return (data != null ? _i11.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ApiKeyResponse?>()) {
      return (data != null ? _i12.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SessionPrompt?>()) {
      return (data != null ? _i13.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.MarketPlacePaginatedItem?>()) {
      return (data != null
          ? _i14.MarketPlacePaginatedItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.PaginatedScrappableResponse?>()) {
      return (data != null
          ? _i15.PaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i16.PaginationMetadata?>()) {
      return (data != null ? _i16.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.MonthlyCreditsData?>()) {
      return (data != null ? _i17.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.CreateSessionResponse?>()) {
      return (data != null ? _i18.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.PromptRole?>()) {
      return (data != null ? _i19.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.AccountApiUsage?>()) {
      return (data != null ? _i20.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ZenScrapException?>()) {
      return (data != null ? _i21.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.CreditHistoryItem?>()) {
      return (data != null ? _i22.CreditHistoryItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CreditPackagePurchase?>()) {
      return (data != null ? _i23.CreditPackagePurchase.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.AiModel?>()) {
      return (data != null ? _i24.AiModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ByteTestData?>()) {
      return (data != null ? _i25.ByteTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ReferenceTestData?>()) {
      return (data != null ? _i26.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.RequestStatus?>()) {
      return (data != null ? _i27.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ScraperCategory?>()) {
      return (data != null ? _i28.ScraperCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Scrappable?>()) {
      return (data != null ? _i29.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.ScrappableAnalytics?>()) {
      return (data != null ? _i30.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.ScrappableRequest?>()) {
      return (data != null ? _i31.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.ScrappingBeeExtractLogic?>()) {
      return (data != null
          ? _i32.ScrappingBeeExtractLogic.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i33.MonthlySubscriptionCreditDeposit?>()) {
      return (data != null
          ? _i33.MonthlySubscriptionCreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i10.ScrappableRequestPerHour>) {
      return (data as List)
          .map((e) => deserialize<_i10.ScrappableRequestPerHour>(e))
          .toList() as T;
    }
    if (t == List<_i30.ScrappableAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i30.ScrappableAnalytics>(e))
          .toList() as T;
    }
    if (t == List<_i3.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
          .map((e) => deserialize<_i3.ScrappableRequestsAnalyticsItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i29.Scrappable>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i29.Scrappable>(e)).toList()
          : null) as T;
    }
    if (t == List<_i4.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i4.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == List<_i14.MarketPlacePaginatedItem>) {
      return (data as List)
          .map((e) => deserialize<_i14.MarketPlacePaginatedItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i22.CreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i22.CreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i4.AccountApiKey>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i4.AccountApiKey>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i30.ScrappableAnalytics>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i30.ScrappableAnalytics>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<_i34.CreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i34.CreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == List<_i35.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i35.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == List<_i36.Scrappable>) {
      return (data as List).map((e) => deserialize<_i36.Scrappable>(e)).toList()
          as T;
    }
    try {
      return _i37.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i2.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i2.CandidateExtractLogicUpdate) {
      return 'CandidateExtractLogicUpdate';
    }
    if (data is _i2.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i3.ScrappableRequestsAnalyticsItem) {
      return 'ScrappableRequestsAnalyticsItem';
    }
    if (data is _i4.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i5.CreditUsage) {
      return 'CreditUsage';
    }
    if (data is _i6.CreditPurchaseOption) {
      return 'CreditPurchaseOption';
    }
    if (data is _i7.PlanTier) {
      return 'PlanTier';
    }
    if (data is _i8.PaginatedScrappableAnalytics) {
      return 'PaginatedScrappableAnalytics';
    }
    if (data is _i9.PaginatedScrappableRequestsAnalytics) {
      return 'PaginatedScrappableRequestsAnalytics';
    }
    if (data is _i10.ScrappableRequestPerHour) {
      return 'ScrappableRequestPerHour';
    }
    if (data is _i11.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i12.ApiKeyResponse) {
      return 'ApiKeyResponse';
    }
    if (data is _i13.SessionPrompt) {
      return 'SessionPrompt';
    }
    if (data is _i14.MarketPlacePaginatedItem) {
      return 'MarketPlacePaginatedItem';
    }
    if (data is _i15.PaginatedScrappableResponse) {
      return 'PaginatedScrappableResponse';
    }
    if (data is _i16.PaginationMetadata) {
      return 'PaginationMetadata';
    }
    if (data is _i17.MonthlyCreditsData) {
      return 'MonthlyCreditsData';
    }
    if (data is _i18.CreateSessionResponse) {
      return 'CreateSessionResponse';
    }
    if (data is _i19.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i20.AccountApiUsage) {
      return 'AccountApiUsage';
    }
    if (data is _i21.ZenScrapException) {
      return 'ZenScrapException';
    }
    if (data is _i22.CreditHistoryItem) {
      return 'CreditHistoryItem';
    }
    if (data is _i23.CreditPackagePurchase) {
      return 'CreditPackagePurchase';
    }
    if (data is _i24.AiModel) {
      return 'AiModel';
    }
    if (data is _i25.ByteTestData) {
      return 'ByteTestData';
    }
    if (data is _i26.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i27.RequestStatus) {
      return 'RequestStatus';
    }
    if (data is _i28.ScraperCategory) {
      return 'ScraperCategory';
    }
    if (data is _i29.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i30.ScrappableAnalytics) {
      return 'ScrappableAnalytics';
    }
    if (data is _i31.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i32.ScrappingBeeExtractLogic) {
      return 'ScrappingBeeExtractLogic';
    }
    if (data is _i33.MonthlySubscriptionCreditDeposit) {
      return 'MonthlySubscriptionCreditDeposit';
    }
    className = _i37.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i2.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i2.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i2.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i2.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i3.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i4.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i5.CreditUsage>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i6.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i7.PlanTier>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i8.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i9.PaginatedScrappableRequestsAnalytics>(
          data['data']);
    }
    if (dataClassName == 'ScrappableRequestPerHour') {
      return deserialize<_i10.ScrappableRequestPerHour>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i11.AccountInfo>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i12.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i13.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i14.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i15.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i16.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i17.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i18.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i19.PromptRole>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i20.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i21.ZenScrapException>(data['data']);
    }
    if (dataClassName == 'CreditHistoryItem') {
      return deserialize<_i22.CreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'CreditPackagePurchase') {
      return deserialize<_i23.CreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'AiModel') {
      return deserialize<_i24.AiModel>(data['data']);
    }
    if (dataClassName == 'ByteTestData') {
      return deserialize<_i25.ByteTestData>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i26.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i27.RequestStatus>(data['data']);
    }
    if (dataClassName == 'ScraperCategory') {
      return deserialize<_i28.ScraperCategory>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i29.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i30.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i31.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappingBeeExtractLogic') {
      return deserialize<_i32.ScrappingBeeExtractLogic>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionCreditDeposit') {
      return deserialize<_i33.MonthlySubscriptionCreditDeposit>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i37.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
