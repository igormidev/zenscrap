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
import 'entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i3;
import 'entities/analytics/scrappable_usage_metrics.dart' as _i4;
import 'entities/analytics/analytics_request_details.dart' as _i5;
import 'entities/analytics/analytics_time_scope.dart' as _i6;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i7;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart' as _i8;
import 'entities/analytics/scrappable_request_per_time_scope.dart' as _i9;
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i10;
import 'entities/account/account.dart' as _i11;
import 'entities/api_key_response.dart' as _i12;
import 'entities/account/ai_usage/account_ai_usage.dart' as _i13;
import 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i14;
import 'entities/create_scrappable_stream/grounding_metadata_info.dart' as _i15;
import 'entities/create_scrappable_stream/grounding_source_info.dart' as _i16;
import 'entities/future_calls/session_prompt.dart' as _i17;
import 'entities/ip_spending/anonymous_ip_spending.dart' as _i18;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i19;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i20;
import 'entities/marketplace/pagination_metadata.dart' as _i21;
import 'entities/monthly_credits_data.dart' as _i22;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i23;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i24;
import 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i25;
import 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i26;
import 'entities/account/api_usage/account_api_usage.dart' as _i27;
import 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart'
    as _i28;
import 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i29;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i30;
import 'entities/zenscrap_exception.dart' as _i31;
import 'entities/account/account_api_key.dart' as _i32;
import 'entities/account/api_usage/credit_usage.dart' as _i33;
import 'entities/account/credit_purchase_option.dart' as _i34;
import 'entities/account/plan_tier.dart' as _i35;
import 'entities/scrappable/ai_model.dart' as _i36;
import 'entities/scrappable/auto_fix/auto_fix_attempt.dart' as _i37;
import 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart' as _i38;
import 'entities/scrappable/auto_fix/auto_fix_config.dart' as _i39;
import 'entities/scrappable/auto_fix/auto_fix_session.dart' as _i40;
import 'entities/scrappable/auto_fix/auto_fix_session_status.dart' as _i41;
import 'entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart'
    as _i42;
import 'entities/scrappable/byte_test_data.dart' as _i43;
import 'entities/scrappable/reference_test_data.dart' as _i44;
import 'entities/scrappable/request_status.dart' as _i45;
import 'entities/scrappable/scraper_category.dart' as _i46;
import 'entities/scrappable/scrappable.dart' as _i47;
import 'entities/scrappable/scrappable_analytics.dart' as _i48;
import 'entities/scrappable/scrappable_request.dart' as _i49;
import 'entities/scrappable/scrapping_bee_extract_logic.dart' as _i50;
import 'entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i51;
import 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i52;
import 'package:zenscrap_client/src/protocol/entities/account/account_api_key.dart'
    as _i53;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scraper_category.dart'
    as _i54;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i55;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/ai_usage/account_ai_usage.dart';
export 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart';
export 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart';
export 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart';
export 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart';
export 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart';
export 'entities/account/api_usage/credit_usage.dart';
export 'entities/account/credit_purchase_option.dart';
export 'entities/account/plan_tier.dart';
export 'entities/analytics/analytics_request_details.dart';
export 'entities/analytics/analytics_time_scope.dart';
export 'entities/analytics/paginated_scrappable_analytics.dart';
export 'entities/analytics/paginated_scrappable_requests_analytics.dart';
export 'entities/analytics/scrappable_request_per_time_scope.dart';
export 'entities/analytics/scrappable_requests_analytics_item.dart';
export 'entities/analytics/scrappable_usage_metrics.dart';
export 'entities/api_key_response.dart';
export 'entities/create_scrappable_stream/create_scrappable_stream_item.dart';
export 'entities/create_scrappable_stream/grounding_metadata_info.dart';
export 'entities/create_scrappable_stream/grounding_source_info.dart';
export 'entities/future_calls/session_prompt.dart';
export 'entities/ip_spending/anonymous_ip_spending.dart';
export 'entities/marketplace/marketplace_paginated_item.dart';
export 'entities/marketplace/paginated_scrappable_response.dart';
export 'entities/marketplace/pagination_metadata.dart';
export 'entities/monthly_credits_data.dart';
export 'entities/redraft_scrappable_session/chat_response.dart';
export 'entities/redraft_scrappable_session/create_session_response.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/scrappable/ai_model.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart';
export 'entities/scrappable/auto_fix/auto_fix_config.dart';
export 'entities/scrappable/auto_fix/auto_fix_session.dart';
export 'entities/scrappable/auto_fix/auto_fix_session_status.dart';
export 'entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart';
export 'entities/scrappable/byte_test_data.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/request_status.dart';
export 'entities/scrappable/scraper_category.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_analytics.dart';
export 'entities/scrappable/scrappable_request.dart';
export 'entities/scrappable/scrapping_bee_extract_logic.dart';
export 'entities/user_scrappables/user_paginated_scrappable_response.dart';
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
    if (t == _i2.UserApiKeyQuotaExceededResponse) {
      return _i2.UserApiKeyQuotaExceededResponse.fromJson(data) as T;
    }
    if (t == _i2.NewExtractRuleResponse) {
      return _i2.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i3.CreateScrappableResult) {
      return _i3.CreateScrappableResult.fromJson(data) as T;
    }
    if (t == _i3.CreateScrappableThinkingChunk) {
      return _i3.CreateScrappableThinkingChunk.fromJson(data) as T;
    }
    if (t == _i2.ApiKeyUpdatedResponse) {
      return _i2.ApiKeyUpdatedResponse.fromJson(data) as T;
    }
    if (t == _i2.CandidateExtractLogicUpdate) {
      return _i2.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i2.CreditLimitReachedResponse) {
      return _i2.CreditLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i2.ErrorTextResponse) {
      return _i2.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i2.IpLimitReachedResponse) {
      return _i2.IpLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i2.MessageTextResponse) {
      return _i2.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i2.TestEndpointCalledErrorResponse) {
      return _i2.TestEndpointCalledErrorResponse.fromJson(data) as T;
    }
    if (t == _i2.TestEndpointCalledSuccessResponse) {
      return _i2.TestEndpointCalledSuccessResponse.fromJson(data) as T;
    }
    if (t == _i2.UpdatedScrappableRequestResponse) {
      return _i2.UpdatedScrappableRequestResponse.fromJson(data) as T;
    }
    if (t == _i4.ScrappableUsageMetrics) {
      return _i4.ScrappableUsageMetrics.fromJson(data) as T;
    }
    if (t == _i5.AnalyticsRequestDetails) {
      return _i5.AnalyticsRequestDetails.fromJson(data) as T;
    }
    if (t == _i6.AnalyticsTimeScope) {
      return _i6.AnalyticsTimeScope.fromJson(data) as T;
    }
    if (t == _i7.PaginatedScrappableAnalytics) {
      return _i7.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i8.PaginatedScrappableRequestsAnalytics) {
      return _i8.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i9.ScrappableRequestPerTimeScope) {
      return _i9.ScrappableRequestPerTimeScope.fromJson(data) as T;
    }
    if (t == _i10.ScrappableRequestsAnalyticsItem) {
      return _i10.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i11.AccountInfo) {
      return _i11.AccountInfo.fromJson(data) as T;
    }
    if (t == _i12.ApiKeyResponse) {
      return _i12.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i13.AccountAIUsage) {
      return _i13.AccountAIUsage.fromJson(data) as T;
    }
    if (t == _i14.AICreditHistoryItem) {
      return _i14.AICreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i15.GroundingMetadataInfo) {
      return _i15.GroundingMetadataInfo.fromJson(data) as T;
    }
    if (t == _i16.GroundingSourceInfo) {
      return _i16.GroundingSourceInfo.fromJson(data) as T;
    }
    if (t == _i17.SessionPrompt) {
      return _i17.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i18.AnonymousIpSpending) {
      return _i18.AnonymousIpSpending.fromJson(data) as T;
    }
    if (t == _i19.MarketPlacePaginatedItem) {
      return _i19.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i20.PaginatedScrappableResponse) {
      return _i20.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i21.PaginationMetadata) {
      return _i21.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i22.MonthlyCreditsData) {
      return _i22.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i23.CreateSessionResponse) {
      return _i23.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i24.PromptRole) {
      return _i24.PromptRole.fromJson(data) as T;
    }
    if (t == _i25.MonthlySubscriptionAICreditDeposit) {
      return _i25.MonthlySubscriptionAICreditDeposit.fromJson(data) as T;
    }
    if (t == _i26.PaginatedAICreditHistoryResponse) {
      return _i26.PaginatedAICreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i27.AccountApiUsage) {
      return _i27.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i28.ApiCreditHistoryItem) {
      return _i28.ApiCreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i29.ApiCreditPackagePurchase) {
      return _i29.ApiCreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i30.MonthlySubscriptionApiCreditDeposit) {
      return _i30.MonthlySubscriptionApiCreditDeposit.fromJson(data) as T;
    }
    if (t == _i31.ZenScrapException) {
      return _i31.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i32.AccountApiKey) {
      return _i32.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i33.CreditUsage) {
      return _i33.CreditUsage.fromJson(data) as T;
    }
    if (t == _i34.CreditPurchaseOption) {
      return _i34.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i35.PlanTier) {
      return _i35.PlanTier.fromJson(data) as T;
    }
    if (t == _i36.AiModel) {
      return _i36.AiModel.fromJson(data) as T;
    }
    if (t == _i37.AutoFixAttempt) {
      return _i37.AutoFixAttempt.fromJson(data) as T;
    }
    if (t == _i38.AutoFixAttemptStatus) {
      return _i38.AutoFixAttemptStatus.fromJson(data) as T;
    }
    if (t == _i39.AutoFixConfig) {
      return _i39.AutoFixConfig.fromJson(data) as T;
    }
    if (t == _i40.AutoFixSession) {
      return _i40.AutoFixSession.fromJson(data) as T;
    }
    if (t == _i41.AutoFixSessionStatus) {
      return _i41.AutoFixSessionStatus.fromJson(data) as T;
    }
    if (t == _i42.PaginatedAutoFixSessionResponse) {
      return _i42.PaginatedAutoFixSessionResponse.fromJson(data) as T;
    }
    if (t == _i43.ByteTestData) {
      return _i43.ByteTestData.fromJson(data) as T;
    }
    if (t == _i44.ReferenceTestData) {
      return _i44.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i45.RequestStatus) {
      return _i45.RequestStatus.fromJson(data) as T;
    }
    if (t == _i46.ScraperCategory) {
      return _i46.ScraperCategory.fromJson(data) as T;
    }
    if (t == _i47.Scrappable) {
      return _i47.Scrappable.fromJson(data) as T;
    }
    if (t == _i48.ScrappableAnalytics) {
      return _i48.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i49.ScrappableRequest) {
      return _i49.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i50.ScrappingBeeExtractLogic) {
      return _i50.ScrappingBeeExtractLogic.fromJson(data) as T;
    }
    if (t == _i51.UserPaginatedScrappableResponse) {
      return _i51.UserPaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i52.PaginatedApiCreditHistoryResponse) {
      return _i52.PaginatedApiCreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.UserApiKeyQuotaExceededResponse?>()) {
      return (data != null
          ? _i2.UserApiKeyQuotaExceededResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.NewExtractRuleResponse?>()) {
      return (data != null ? _i2.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.CreateScrappableResult?>()) {
      return (data != null ? _i3.CreateScrappableResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.CreateScrappableThinkingChunk?>()) {
      return (data != null
          ? _i3.CreateScrappableThinkingChunk.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.ApiKeyUpdatedResponse?>()) {
      return (data != null ? _i2.ApiKeyUpdatedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.CandidateExtractLogicUpdate?>()) {
      return (data != null
          ? _i2.CandidateExtractLogicUpdate.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.CreditLimitReachedResponse?>()) {
      return (data != null
          ? _i2.CreditLimitReachedResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.ErrorTextResponse?>()) {
      return (data != null ? _i2.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.IpLimitReachedResponse?>()) {
      return (data != null ? _i2.IpLimitReachedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.MessageTextResponse?>()) {
      return (data != null ? _i2.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.TestEndpointCalledErrorResponse?>()) {
      return (data != null
          ? _i2.TestEndpointCalledErrorResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.TestEndpointCalledSuccessResponse?>()) {
      return (data != null
          ? _i2.TestEndpointCalledSuccessResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i2.UpdatedScrappableRequestResponse?>()) {
      return (data != null
          ? _i2.UpdatedScrappableRequestResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.ScrappableUsageMetrics?>()) {
      return (data != null ? _i4.ScrappableUsageMetrics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AnalyticsRequestDetails?>()) {
      return (data != null ? _i5.AnalyticsRequestDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.AnalyticsTimeScope?>()) {
      return (data != null ? _i6.AnalyticsTimeScope.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PaginatedScrappableAnalytics?>()) {
      return (data != null
          ? _i7.PaginatedScrappableAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
          ? _i8.PaginatedScrappableRequestsAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.ScrappableRequestPerTimeScope?>()) {
      return (data != null
          ? _i9.ScrappableRequestPerTimeScope.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
          ? _i10.ScrappableRequestsAnalyticsItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.AccountInfo?>()) {
      return (data != null ? _i11.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ApiKeyResponse?>()) {
      return (data != null ? _i12.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.AccountAIUsage?>()) {
      return (data != null ? _i13.AccountAIUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AICreditHistoryItem?>()) {
      return (data != null ? _i14.AICreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.GroundingMetadataInfo?>()) {
      return (data != null ? _i15.GroundingMetadataInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.GroundingSourceInfo?>()) {
      return (data != null ? _i16.GroundingSourceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.SessionPrompt?>()) {
      return (data != null ? _i17.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.AnonymousIpSpending?>()) {
      return (data != null ? _i18.AnonymousIpSpending.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.MarketPlacePaginatedItem?>()) {
      return (data != null
          ? _i19.MarketPlacePaginatedItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i20.PaginatedScrappableResponse?>()) {
      return (data != null
          ? _i20.PaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i21.PaginationMetadata?>()) {
      return (data != null ? _i21.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.MonthlyCreditsData?>()) {
      return (data != null ? _i22.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.CreateSessionResponse?>()) {
      return (data != null ? _i23.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.PromptRole?>()) {
      return (data != null ? _i24.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.MonthlySubscriptionAICreditDeposit?>()) {
      return (data != null
          ? _i25.MonthlySubscriptionAICreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i26.PaginatedAICreditHistoryResponse?>()) {
      return (data != null
          ? _i26.PaginatedAICreditHistoryResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i27.AccountApiUsage?>()) {
      return (data != null ? _i27.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ApiCreditHistoryItem?>()) {
      return (data != null ? _i28.ApiCreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.ApiCreditPackagePurchase?>()) {
      return (data != null
          ? _i29.ApiCreditPackagePurchase.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i30.MonthlySubscriptionApiCreditDeposit?>()) {
      return (data != null
          ? _i30.MonthlySubscriptionApiCreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i31.ZenScrapException?>()) {
      return (data != null ? _i31.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.AccountApiKey?>()) {
      return (data != null ? _i32.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.CreditUsage?>()) {
      return (data != null ? _i33.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CreditPurchaseOption?>()) {
      return (data != null ? _i34.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.PlanTier?>()) {
      return (data != null ? _i35.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.AiModel?>()) {
      return (data != null ? _i36.AiModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.AutoFixAttempt?>()) {
      return (data != null ? _i37.AutoFixAttempt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.AutoFixAttemptStatus?>()) {
      return (data != null ? _i38.AutoFixAttemptStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.AutoFixConfig?>()) {
      return (data != null ? _i39.AutoFixConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.AutoFixSession?>()) {
      return (data != null ? _i40.AutoFixSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.AutoFixSessionStatus?>()) {
      return (data != null ? _i41.AutoFixSessionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.PaginatedAutoFixSessionResponse?>()) {
      return (data != null
          ? _i42.PaginatedAutoFixSessionResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i43.ByteTestData?>()) {
      return (data != null ? _i43.ByteTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.ReferenceTestData?>()) {
      return (data != null ? _i44.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.RequestStatus?>()) {
      return (data != null ? _i45.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.ScraperCategory?>()) {
      return (data != null ? _i46.ScraperCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.Scrappable?>()) {
      return (data != null ? _i47.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ScrappableAnalytics?>()) {
      return (data != null ? _i48.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.ScrappableRequest?>()) {
      return (data != null ? _i49.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ScrappingBeeExtractLogic?>()) {
      return (data != null
          ? _i50.ScrappingBeeExtractLogic.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i51.UserPaginatedScrappableResponse?>()) {
      return (data != null
          ? _i51.UserPaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i52.PaginatedApiCreditHistoryResponse?>()) {
      return (data != null
          ? _i52.PaginatedApiCreditHistoryResponse.fromJson(data)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<_i48.ScrappableAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i48.ScrappableAnalytics>(e))
          .toList() as T;
    }
    if (t == List<_i10.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
          .map((e) => deserialize<_i10.ScrappableRequestsAnalyticsItem>(e))
          .toList() as T;
    }
    if (t == List<_i9.ScrappableRequestPerTimeScope>) {
      return (data as List)
          .map((e) => deserialize<_i9.ScrappableRequestPerTimeScope>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i47.Scrappable>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Scrappable>(e)).toList()
          : null) as T;
    }
    if (t == List<_i32.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i32.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == _i1.getType<List<_i14.AICreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i14.AICreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i16.GroundingSourceInfo>) {
      return (data as List)
          .map((e) => deserialize<_i16.GroundingSourceInfo>(e))
          .toList() as T;
    }
    if (t == List<_i19.MarketPlacePaginatedItem>) {
      return (data as List)
          .map((e) => deserialize<_i19.MarketPlacePaginatedItem>(e))
          .toList() as T;
    }
    if (t == List<_i14.AICreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i14.AICreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i28.ApiCreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i28.ApiCreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i32.AccountApiKey>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i32.AccountApiKey>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i37.AutoFixAttempt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i37.AutoFixAttempt>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i40.AutoFixSession>) {
      return (data as List)
          .map((e) => deserialize<_i40.AutoFixSession>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i48.ScrappableAnalytics>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i48.ScrappableAnalytics>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i47.Scrappable>) {
      return (data as List).map((e) => deserialize<_i47.Scrappable>(e)).toList()
          as T;
    }
    if (t == List<_i28.ApiCreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i28.ApiCreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == List<_i53.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i53.AccountApiKey>(e))
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
    if (t == _i1.getType<List<_i54.ScraperCategory>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i54.ScraperCategory>(e))
              .toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    try {
      return _i55.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.UserApiKeyQuotaExceededResponse) {
      return 'UserApiKeyQuotaExceededResponse';
    }
    if (data is _i2.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i3.CreateScrappableResult) {
      return 'CreateScrappableResult';
    }
    if (data is _i3.CreateScrappableThinkingChunk) {
      return 'CreateScrappableThinkingChunk';
    }
    if (data is _i2.ApiKeyUpdatedResponse) {
      return 'ApiKeyUpdatedResponse';
    }
    if (data is _i2.CandidateExtractLogicUpdate) {
      return 'CandidateExtractLogicUpdate';
    }
    if (data is _i2.CreditLimitReachedResponse) {
      return 'CreditLimitReachedResponse';
    }
    if (data is _i2.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i2.IpLimitReachedResponse) {
      return 'IpLimitReachedResponse';
    }
    if (data is _i2.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i2.TestEndpointCalledErrorResponse) {
      return 'TestEndpointCalledErrorResponse';
    }
    if (data is _i2.TestEndpointCalledSuccessResponse) {
      return 'TestEndpointCalledSuccessResponse';
    }
    if (data is _i2.UpdatedScrappableRequestResponse) {
      return 'UpdatedScrappableRequestResponse';
    }
    if (data is _i4.ScrappableUsageMetrics) {
      return 'ScrappableUsageMetrics';
    }
    if (data is _i5.AnalyticsRequestDetails) {
      return 'AnalyticsRequestDetails';
    }
    if (data is _i6.AnalyticsTimeScope) {
      return 'AnalyticsTimeScope';
    }
    if (data is _i7.PaginatedScrappableAnalytics) {
      return 'PaginatedScrappableAnalytics';
    }
    if (data is _i8.PaginatedScrappableRequestsAnalytics) {
      return 'PaginatedScrappableRequestsAnalytics';
    }
    if (data is _i9.ScrappableRequestPerTimeScope) {
      return 'ScrappableRequestPerTimeScope';
    }
    if (data is _i10.ScrappableRequestsAnalyticsItem) {
      return 'ScrappableRequestsAnalyticsItem';
    }
    if (data is _i11.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i12.ApiKeyResponse) {
      return 'ApiKeyResponse';
    }
    if (data is _i13.AccountAIUsage) {
      return 'AccountAIUsage';
    }
    if (data is _i14.AICreditHistoryItem) {
      return 'AICreditHistoryItem';
    }
    if (data is _i15.GroundingMetadataInfo) {
      return 'GroundingMetadataInfo';
    }
    if (data is _i16.GroundingSourceInfo) {
      return 'GroundingSourceInfo';
    }
    if (data is _i17.SessionPrompt) {
      return 'SessionPrompt';
    }
    if (data is _i18.AnonymousIpSpending) {
      return 'AnonymousIpSpending';
    }
    if (data is _i19.MarketPlacePaginatedItem) {
      return 'MarketPlacePaginatedItem';
    }
    if (data is _i20.PaginatedScrappableResponse) {
      return 'PaginatedScrappableResponse';
    }
    if (data is _i21.PaginationMetadata) {
      return 'PaginationMetadata';
    }
    if (data is _i22.MonthlyCreditsData) {
      return 'MonthlyCreditsData';
    }
    if (data is _i23.CreateSessionResponse) {
      return 'CreateSessionResponse';
    }
    if (data is _i24.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i25.MonthlySubscriptionAICreditDeposit) {
      return 'MonthlySubscriptionAICreditDeposit';
    }
    if (data is _i26.PaginatedAICreditHistoryResponse) {
      return 'PaginatedAICreditHistoryResponse';
    }
    if (data is _i27.AccountApiUsage) {
      return 'AccountApiUsage';
    }
    if (data is _i28.ApiCreditHistoryItem) {
      return 'ApiCreditHistoryItem';
    }
    if (data is _i29.ApiCreditPackagePurchase) {
      return 'ApiCreditPackagePurchase';
    }
    if (data is _i30.MonthlySubscriptionApiCreditDeposit) {
      return 'MonthlySubscriptionApiCreditDeposit';
    }
    if (data is _i31.ZenScrapException) {
      return 'ZenScrapException';
    }
    if (data is _i32.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i33.CreditUsage) {
      return 'CreditUsage';
    }
    if (data is _i34.CreditPurchaseOption) {
      return 'CreditPurchaseOption';
    }
    if (data is _i35.PlanTier) {
      return 'PlanTier';
    }
    if (data is _i36.AiModel) {
      return 'AiModel';
    }
    if (data is _i37.AutoFixAttempt) {
      return 'AutoFixAttempt';
    }
    if (data is _i38.AutoFixAttemptStatus) {
      return 'AutoFixAttemptStatus';
    }
    if (data is _i39.AutoFixConfig) {
      return 'AutoFixConfig';
    }
    if (data is _i40.AutoFixSession) {
      return 'AutoFixSession';
    }
    if (data is _i41.AutoFixSessionStatus) {
      return 'AutoFixSessionStatus';
    }
    if (data is _i42.PaginatedAutoFixSessionResponse) {
      return 'PaginatedAutoFixSessionResponse';
    }
    if (data is _i43.ByteTestData) {
      return 'ByteTestData';
    }
    if (data is _i44.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i45.RequestStatus) {
      return 'RequestStatus';
    }
    if (data is _i46.ScraperCategory) {
      return 'ScraperCategory';
    }
    if (data is _i47.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i48.ScrappableAnalytics) {
      return 'ScrappableAnalytics';
    }
    if (data is _i49.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i50.ScrappingBeeExtractLogic) {
      return 'ScrappingBeeExtractLogic';
    }
    if (data is _i51.UserPaginatedScrappableResponse) {
      return 'UserPaginatedScrappableResponse';
    }
    if (data is _i52.PaginatedApiCreditHistoryResponse) {
      return 'PaginatedApiCreditHistoryResponse';
    }
    className = _i55.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'UserApiKeyQuotaExceededResponse') {
      return deserialize<_i2.UserApiKeyQuotaExceededResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i2.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'CreateScrappableResult') {
      return deserialize<_i3.CreateScrappableResult>(data['data']);
    }
    if (dataClassName == 'CreateScrappableThinkingChunk') {
      return deserialize<_i3.CreateScrappableThinkingChunk>(data['data']);
    }
    if (dataClassName == 'ApiKeyUpdatedResponse') {
      return deserialize<_i2.ApiKeyUpdatedResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i2.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'CreditLimitReachedResponse') {
      return deserialize<_i2.CreditLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i2.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'IpLimitReachedResponse') {
      return deserialize<_i2.IpLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i2.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledErrorResponse') {
      return deserialize<_i2.TestEndpointCalledErrorResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledSuccessResponse') {
      return deserialize<_i2.TestEndpointCalledSuccessResponse>(data['data']);
    }
    if (dataClassName == 'UpdatedScrappableRequestResponse') {
      return deserialize<_i2.UpdatedScrappableRequestResponse>(data['data']);
    }
    if (dataClassName == 'ScrappableUsageMetrics') {
      return deserialize<_i4.ScrappableUsageMetrics>(data['data']);
    }
    if (dataClassName == 'AnalyticsRequestDetails') {
      return deserialize<_i5.AnalyticsRequestDetails>(data['data']);
    }
    if (dataClassName == 'AnalyticsTimeScope') {
      return deserialize<_i6.AnalyticsTimeScope>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i7.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i8.PaginatedScrappableRequestsAnalytics>(
          data['data']);
    }
    if (dataClassName == 'ScrappableRequestPerTimeScope') {
      return deserialize<_i9.ScrappableRequestPerTimeScope>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i10.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i11.AccountInfo>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i12.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'AccountAIUsage') {
      return deserialize<_i13.AccountAIUsage>(data['data']);
    }
    if (dataClassName == 'AICreditHistoryItem') {
      return deserialize<_i14.AICreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'GroundingMetadataInfo') {
      return deserialize<_i15.GroundingMetadataInfo>(data['data']);
    }
    if (dataClassName == 'GroundingSourceInfo') {
      return deserialize<_i16.GroundingSourceInfo>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i17.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'AnonymousIpSpending') {
      return deserialize<_i18.AnonymousIpSpending>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i19.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i20.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i21.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i22.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i23.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i24.PromptRole>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionAICreditDeposit') {
      return deserialize<_i25.MonthlySubscriptionAICreditDeposit>(data['data']);
    }
    if (dataClassName == 'PaginatedAICreditHistoryResponse') {
      return deserialize<_i26.PaginatedAICreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i27.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'ApiCreditHistoryItem') {
      return deserialize<_i28.ApiCreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'ApiCreditPackagePurchase') {
      return deserialize<_i29.ApiCreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionApiCreditDeposit') {
      return deserialize<_i30.MonthlySubscriptionApiCreditDeposit>(
          data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i31.ZenScrapException>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i32.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i33.CreditUsage>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i34.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i35.PlanTier>(data['data']);
    }
    if (dataClassName == 'AiModel') {
      return deserialize<_i36.AiModel>(data['data']);
    }
    if (dataClassName == 'AutoFixAttempt') {
      return deserialize<_i37.AutoFixAttempt>(data['data']);
    }
    if (dataClassName == 'AutoFixAttemptStatus') {
      return deserialize<_i38.AutoFixAttemptStatus>(data['data']);
    }
    if (dataClassName == 'AutoFixConfig') {
      return deserialize<_i39.AutoFixConfig>(data['data']);
    }
    if (dataClassName == 'AutoFixSession') {
      return deserialize<_i40.AutoFixSession>(data['data']);
    }
    if (dataClassName == 'AutoFixSessionStatus') {
      return deserialize<_i41.AutoFixSessionStatus>(data['data']);
    }
    if (dataClassName == 'PaginatedAutoFixSessionResponse') {
      return deserialize<_i42.PaginatedAutoFixSessionResponse>(data['data']);
    }
    if (dataClassName == 'ByteTestData') {
      return deserialize<_i43.ByteTestData>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i44.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i45.RequestStatus>(data['data']);
    }
    if (dataClassName == 'ScraperCategory') {
      return deserialize<_i46.ScraperCategory>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i47.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i48.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i49.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappingBeeExtractLogic') {
      return deserialize<_i50.ScrappingBeeExtractLogic>(data['data']);
    }
    if (dataClassName == 'UserPaginatedScrappableResponse') {
      return deserialize<_i51.UserPaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginatedApiCreditHistoryResponse') {
      return deserialize<_i52.PaginatedApiCreditHistoryResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i55.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
