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
import 'entities/account/account.dart' as _i2;
import 'entities/account/account_api_key.dart' as _i3;
import 'entities/account/ai_usage/account_ai_usage.dart' as _i4;
import 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i5;
import 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i6;
import 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i7;
import 'entities/account/api_usage/account_api_usage.dart' as _i8;
import 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart'
    as _i9;
import 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i10;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i11;
import 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i12;
import 'entities/account/api_usage/credit_usage.dart' as _i13;
import 'entities/account/credit_purchase_option.dart' as _i14;
import 'entities/account/plan_tier.dart' as _i15;
import 'entities/analytics/analytics_request_details.dart' as _i16;
import 'entities/analytics/analytics_time_scope.dart' as _i17;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i18;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i19;
import 'entities/analytics/scrappable_request_per_time_scope.dart' as _i20;
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i21;
import 'entities/analytics/scrappable_usage_metrics.dart' as _i22;
import 'entities/api_key_response.dart' as _i23;
import 'entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i24;
import 'entities/create_scrappable_stream/grounding_metadata_info.dart' as _i25;
import 'entities/create_scrappable_stream/grounding_source_info.dart' as _i26;
import 'entities/future_calls/session_prompt.dart' as _i27;
import 'entities/ip_spending/anonymous_ip_spending.dart' as _i28;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i29;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i30;
import 'entities/marketplace/pagination_metadata.dart' as _i31;
import 'entities/monthly_credits_data.dart' as _i32;
import 'entities/redraft_scrappable_session/chat_response.dart' as _i33;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i34;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i35;
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
import 'entities/zenscrap_exception.dart' as _i52;
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

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AccountInfo) {
      return _i2.AccountInfo.fromJson(data) as T;
    }
    if (t == _i3.AccountApiKey) {
      return _i3.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i4.AccountAIUsage) {
      return _i4.AccountAIUsage.fromJson(data) as T;
    }
    if (t == _i5.AICreditHistoryItem) {
      return _i5.AICreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i6.MonthlySubscriptionAICreditDeposit) {
      return _i6.MonthlySubscriptionAICreditDeposit.fromJson(data) as T;
    }
    if (t == _i7.PaginatedAICreditHistoryResponse) {
      return _i7.PaginatedAICreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i8.AccountApiUsage) {
      return _i8.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i9.ApiCreditHistoryItem) {
      return _i9.ApiCreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i10.ApiCreditPackagePurchase) {
      return _i10.ApiCreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i11.MonthlySubscriptionApiCreditDeposit) {
      return _i11.MonthlySubscriptionApiCreditDeposit.fromJson(data) as T;
    }
    if (t == _i12.PaginatedApiCreditHistoryResponse) {
      return _i12.PaginatedApiCreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i13.CreditUsage) {
      return _i13.CreditUsage.fromJson(data) as T;
    }
    if (t == _i14.CreditPurchaseOption) {
      return _i14.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i15.PlanTier) {
      return _i15.PlanTier.fromJson(data) as T;
    }
    if (t == _i16.AnalyticsRequestDetails) {
      return _i16.AnalyticsRequestDetails.fromJson(data) as T;
    }
    if (t == _i17.AnalyticsTimeScope) {
      return _i17.AnalyticsTimeScope.fromJson(data) as T;
    }
    if (t == _i18.PaginatedScrappableAnalytics) {
      return _i18.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i19.PaginatedScrappableRequestsAnalytics) {
      return _i19.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i20.ScrappableRequestPerTimeScope) {
      return _i20.ScrappableRequestPerTimeScope.fromJson(data) as T;
    }
    if (t == _i21.ScrappableRequestsAnalyticsItem) {
      return _i21.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i22.ScrappableUsageMetrics) {
      return _i22.ScrappableUsageMetrics.fromJson(data) as T;
    }
    if (t == _i23.ApiKeyResponse) {
      return _i23.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i24.CreateScrappableResult) {
      return _i24.CreateScrappableResult.fromJson(data) as T;
    }
    if (t == _i24.CreateScrappableThinkingChunk) {
      return _i24.CreateScrappableThinkingChunk.fromJson(data) as T;
    }
    if (t == _i25.GroundingMetadataInfo) {
      return _i25.GroundingMetadataInfo.fromJson(data) as T;
    }
    if (t == _i26.GroundingSourceInfo) {
      return _i26.GroundingSourceInfo.fromJson(data) as T;
    }
    if (t == _i27.SessionPrompt) {
      return _i27.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i28.AnonymousIpSpending) {
      return _i28.AnonymousIpSpending.fromJson(data) as T;
    }
    if (t == _i29.MarketPlacePaginatedItem) {
      return _i29.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i30.PaginatedScrappableResponse) {
      return _i30.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i31.PaginationMetadata) {
      return _i31.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i32.MonthlyCreditsData) {
      return _i32.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i33.ApiKeyUpdatedResponse) {
      return _i33.ApiKeyUpdatedResponse.fromJson(data) as T;
    }
    if (t == _i33.CandidateExtractLogicUpdate) {
      return _i33.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i33.CreditLimitReachedResponse) {
      return _i33.CreditLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i33.ErrorTextResponse) {
      return _i33.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i33.IpLimitReachedResponse) {
      return _i33.IpLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i33.MessageTextResponse) {
      return _i33.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i33.NewExtractRuleResponse) {
      return _i33.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i33.TestEndpointCalledErrorResponse) {
      return _i33.TestEndpointCalledErrorResponse.fromJson(data) as T;
    }
    if (t == _i33.TestEndpointCalledSuccessResponse) {
      return _i33.TestEndpointCalledSuccessResponse.fromJson(data) as T;
    }
    if (t == _i33.UpdatedScrappableRequestResponse) {
      return _i33.UpdatedScrappableRequestResponse.fromJson(data) as T;
    }
    if (t == _i33.UserApiKeyQuotaExceededResponse) {
      return _i33.UserApiKeyQuotaExceededResponse.fromJson(data) as T;
    }
    if (t == _i34.CreateSessionResponse) {
      return _i34.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i35.PromptRole) {
      return _i35.PromptRole.fromJson(data) as T;
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
    if (t == _i52.ZenScrapException) {
      return _i52.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountInfo?>()) {
      return (data != null ? _i2.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccountApiKey?>()) {
      return (data != null ? _i3.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AccountAIUsage?>()) {
      return (data != null ? _i4.AccountAIUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AICreditHistoryItem?>()) {
      return (data != null ? _i5.AICreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.MonthlySubscriptionAICreditDeposit?>()) {
      return (data != null
              ? _i6.MonthlySubscriptionAICreditDeposit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i7.PaginatedAICreditHistoryResponse?>()) {
      return (data != null
              ? _i7.PaginatedAICreditHistoryResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i8.AccountApiUsage?>()) {
      return (data != null ? _i8.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ApiCreditHistoryItem?>()) {
      return (data != null ? _i9.ApiCreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ApiCreditPackagePurchase?>()) {
      return (data != null
              ? _i10.ApiCreditPackagePurchase.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.MonthlySubscriptionApiCreditDeposit?>()) {
      return (data != null
              ? _i11.MonthlySubscriptionApiCreditDeposit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.PaginatedApiCreditHistoryResponse?>()) {
      return (data != null
              ? _i12.PaginatedApiCreditHistoryResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.CreditUsage?>()) {
      return (data != null ? _i13.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CreditPurchaseOption?>()) {
      return (data != null ? _i14.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.PlanTier?>()) {
      return (data != null ? _i15.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.AnalyticsRequestDetails?>()) {
      return (data != null ? _i16.AnalyticsRequestDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.AnalyticsTimeScope?>()) {
      return (data != null ? _i17.AnalyticsTimeScope.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.PaginatedScrappableAnalytics?>()) {
      return (data != null
              ? _i18.PaginatedScrappableAnalytics.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
              ? _i19.PaginatedScrappableRequestsAnalytics.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.ScrappableRequestPerTimeScope?>()) {
      return (data != null
              ? _i20.ScrappableRequestPerTimeScope.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i21.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
              ? _i21.ScrappableRequestsAnalyticsItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i22.ScrappableUsageMetrics?>()) {
      return (data != null ? _i22.ScrappableUsageMetrics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.ApiKeyResponse?>()) {
      return (data != null ? _i23.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.CreateScrappableResult?>()) {
      return (data != null ? _i24.CreateScrappableResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.CreateScrappableThinkingChunk?>()) {
      return (data != null
              ? _i24.CreateScrappableThinkingChunk.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.GroundingMetadataInfo?>()) {
      return (data != null ? _i25.GroundingMetadataInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.GroundingSourceInfo?>()) {
      return (data != null ? _i26.GroundingSourceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.SessionPrompt?>()) {
      return (data != null ? _i27.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.AnonymousIpSpending?>()) {
      return (data != null ? _i28.AnonymousIpSpending.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.MarketPlacePaginatedItem?>()) {
      return (data != null
              ? _i29.MarketPlacePaginatedItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i30.PaginatedScrappableResponse?>()) {
      return (data != null
              ? _i30.PaginatedScrappableResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i31.PaginationMetadata?>()) {
      return (data != null ? _i31.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.MonthlyCreditsData?>()) {
      return (data != null ? _i32.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.ApiKeyUpdatedResponse?>()) {
      return (data != null ? _i33.ApiKeyUpdatedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.CandidateExtractLogicUpdate?>()) {
      return (data != null
              ? _i33.CandidateExtractLogicUpdate.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.CreditLimitReachedResponse?>()) {
      return (data != null
              ? _i33.CreditLimitReachedResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.ErrorTextResponse?>()) {
      return (data != null ? _i33.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.IpLimitReachedResponse?>()) {
      return (data != null ? _i33.IpLimitReachedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.MessageTextResponse?>()) {
      return (data != null ? _i33.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.NewExtractRuleResponse?>()) {
      return (data != null ? _i33.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.TestEndpointCalledErrorResponse?>()) {
      return (data != null
              ? _i33.TestEndpointCalledErrorResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.TestEndpointCalledSuccessResponse?>()) {
      return (data != null
              ? _i33.TestEndpointCalledSuccessResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.UpdatedScrappableRequestResponse?>()) {
      return (data != null
              ? _i33.UpdatedScrappableRequestResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.UserApiKeyQuotaExceededResponse?>()) {
      return (data != null
              ? _i33.UserApiKeyQuotaExceededResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i34.CreateSessionResponse?>()) {
      return (data != null ? _i34.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.PromptRole?>()) {
      return (data != null ? _i35.PromptRole.fromJson(data) : null) as T;
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
              : null)
          as T;
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
              : null)
          as T;
    }
    if (t == _i1.getType<_i51.UserPaginatedScrappableResponse?>()) {
      return (data != null
              ? _i51.UserPaginatedScrappableResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i52.ZenScrapException?>()) {
      return (data != null ? _i52.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == List<_i47.Scrappable>) {
      return (data as List).map((e) => deserialize<_i47.Scrappable>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i47.Scrappable>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i47.Scrappable>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i5.AICreditHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i5.AICreditHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i5.AICreditHistoryItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i5.AICreditHistoryItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i9.ApiCreditHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i9.ApiCreditHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.ApiCreditHistoryItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.ApiCreditHistoryItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i3.AccountApiKey>) {
      return (data as List)
              .map((e) => deserialize<_i3.AccountApiKey>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i3.AccountApiKey>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i3.AccountApiKey>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i48.ScrappableAnalytics>) {
      return (data as List)
              .map((e) => deserialize<_i48.ScrappableAnalytics>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
              .map((e) => deserialize<_i21.ScrappableRequestsAnalyticsItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.ScrappableRequestPerTimeScope>) {
      return (data as List)
              .map((e) => deserialize<_i20.ScrappableRequestPerTimeScope>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i26.GroundingSourceInfo>) {
      return (data as List)
              .map((e) => deserialize<_i26.GroundingSourceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.MarketPlacePaginatedItem>) {
      return (data as List)
              .map((e) => deserialize<_i29.MarketPlacePaginatedItem>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    if (t == List<_i37.AutoFixAttempt>) {
      return (data as List)
              .map((e) => deserialize<_i37.AutoFixAttempt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i37.AutoFixAttempt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i37.AutoFixAttempt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i40.AutoFixSession>) {
      return (data as List)
              .map((e) => deserialize<_i40.AutoFixSession>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i48.ScrappableAnalytics>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i48.ScrappableAnalytics>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i53.AccountApiKey>) {
      return (data as List)
              .map((e) => deserialize<_i53.AccountApiKey>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i54.ScraperCategory>) {
      return (data as List)
              .map((e) => deserialize<_i54.ScraperCategory>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i54.ScraperCategory>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i54.ScraperCategory>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    try {
      return _i55.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccountInfo => 'AccountInfo',
      _i3.AccountApiKey => 'AccountApiKey',
      _i4.AccountAIUsage => 'AccountAIUsage',
      _i5.AICreditHistoryItem => 'AICreditHistoryItem',
      _i6.MonthlySubscriptionAICreditDeposit =>
        'MonthlySubscriptionAICreditDeposit',
      _i7.PaginatedAICreditHistoryResponse =>
        'PaginatedAICreditHistoryResponse',
      _i8.AccountApiUsage => 'AccountApiUsage',
      _i9.ApiCreditHistoryItem => 'ApiCreditHistoryItem',
      _i10.ApiCreditPackagePurchase => 'ApiCreditPackagePurchase',
      _i11.MonthlySubscriptionApiCreditDeposit =>
        'MonthlySubscriptionApiCreditDeposit',
      _i12.PaginatedApiCreditHistoryResponse =>
        'PaginatedApiCreditHistoryResponse',
      _i13.CreditUsage => 'CreditUsage',
      _i14.CreditPurchaseOption => 'CreditPurchaseOption',
      _i15.PlanTier => 'PlanTier',
      _i16.AnalyticsRequestDetails => 'AnalyticsRequestDetails',
      _i17.AnalyticsTimeScope => 'AnalyticsTimeScope',
      _i18.PaginatedScrappableAnalytics => 'PaginatedScrappableAnalytics',
      _i19.PaginatedScrappableRequestsAnalytics =>
        'PaginatedScrappableRequestsAnalytics',
      _i20.ScrappableRequestPerTimeScope => 'ScrappableRequestPerTimeScope',
      _i21.ScrappableRequestsAnalyticsItem => 'ScrappableRequestsAnalyticsItem',
      _i22.ScrappableUsageMetrics => 'ScrappableUsageMetrics',
      _i23.ApiKeyResponse => 'ApiKeyResponse',
      _i24.CreateScrappableResult => 'CreateScrappableResult',
      _i24.CreateScrappableThinkingChunk => 'CreateScrappableThinkingChunk',
      _i25.GroundingMetadataInfo => 'GroundingMetadataInfo',
      _i26.GroundingSourceInfo => 'GroundingSourceInfo',
      _i27.SessionPrompt => 'SessionPrompt',
      _i28.AnonymousIpSpending => 'AnonymousIpSpending',
      _i29.MarketPlacePaginatedItem => 'MarketPlacePaginatedItem',
      _i30.PaginatedScrappableResponse => 'PaginatedScrappableResponse',
      _i31.PaginationMetadata => 'PaginationMetadata',
      _i32.MonthlyCreditsData => 'MonthlyCreditsData',
      _i33.ApiKeyUpdatedResponse => 'ApiKeyUpdatedResponse',
      _i33.CandidateExtractLogicUpdate => 'CandidateExtractLogicUpdate',
      _i33.CreditLimitReachedResponse => 'CreditLimitReachedResponse',
      _i33.ErrorTextResponse => 'ErrorTextResponse',
      _i33.IpLimitReachedResponse => 'IpLimitReachedResponse',
      _i33.MessageTextResponse => 'MessageTextResponse',
      _i33.NewExtractRuleResponse => 'NewExtractRuleResponse',
      _i33.TestEndpointCalledErrorResponse => 'TestEndpointCalledErrorResponse',
      _i33.TestEndpointCalledSuccessResponse =>
        'TestEndpointCalledSuccessResponse',
      _i33.UpdatedScrappableRequestResponse =>
        'UpdatedScrappableRequestResponse',
      _i33.UserApiKeyQuotaExceededResponse => 'UserApiKeyQuotaExceededResponse',
      _i34.CreateSessionResponse => 'CreateSessionResponse',
      _i35.PromptRole => 'PromptRole',
      _i36.AiModel => 'AiModel',
      _i37.AutoFixAttempt => 'AutoFixAttempt',
      _i38.AutoFixAttemptStatus => 'AutoFixAttemptStatus',
      _i39.AutoFixConfig => 'AutoFixConfig',
      _i40.AutoFixSession => 'AutoFixSession',
      _i41.AutoFixSessionStatus => 'AutoFixSessionStatus',
      _i42.PaginatedAutoFixSessionResponse => 'PaginatedAutoFixSessionResponse',
      _i43.ByteTestData => 'ByteTestData',
      _i44.ReferenceTestData => 'ReferenceTestData',
      _i45.RequestStatus => 'RequestStatus',
      _i46.ScraperCategory => 'ScraperCategory',
      _i47.Scrappable => 'Scrappable',
      _i48.ScrappableAnalytics => 'ScrappableAnalytics',
      _i49.ScrappableRequest => 'ScrappableRequest',
      _i50.ScrappingBeeExtractLogic => 'ScrappingBeeExtractLogic',
      _i51.UserPaginatedScrappableResponse => 'UserPaginatedScrappableResponse',
      _i52.ZenScrapException => 'ZenScrapException',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('zenscrap.', '');
    }

    switch (data) {
      case _i2.AccountInfo():
        return 'AccountInfo';
      case _i3.AccountApiKey():
        return 'AccountApiKey';
      case _i4.AccountAIUsage():
        return 'AccountAIUsage';
      case _i5.AICreditHistoryItem():
        return 'AICreditHistoryItem';
      case _i6.MonthlySubscriptionAICreditDeposit():
        return 'MonthlySubscriptionAICreditDeposit';
      case _i7.PaginatedAICreditHistoryResponse():
        return 'PaginatedAICreditHistoryResponse';
      case _i8.AccountApiUsage():
        return 'AccountApiUsage';
      case _i9.ApiCreditHistoryItem():
        return 'ApiCreditHistoryItem';
      case _i10.ApiCreditPackagePurchase():
        return 'ApiCreditPackagePurchase';
      case _i11.MonthlySubscriptionApiCreditDeposit():
        return 'MonthlySubscriptionApiCreditDeposit';
      case _i12.PaginatedApiCreditHistoryResponse():
        return 'PaginatedApiCreditHistoryResponse';
      case _i13.CreditUsage():
        return 'CreditUsage';
      case _i14.CreditPurchaseOption():
        return 'CreditPurchaseOption';
      case _i15.PlanTier():
        return 'PlanTier';
      case _i16.AnalyticsRequestDetails():
        return 'AnalyticsRequestDetails';
      case _i17.AnalyticsTimeScope():
        return 'AnalyticsTimeScope';
      case _i18.PaginatedScrappableAnalytics():
        return 'PaginatedScrappableAnalytics';
      case _i19.PaginatedScrappableRequestsAnalytics():
        return 'PaginatedScrappableRequestsAnalytics';
      case _i20.ScrappableRequestPerTimeScope():
        return 'ScrappableRequestPerTimeScope';
      case _i21.ScrappableRequestsAnalyticsItem():
        return 'ScrappableRequestsAnalyticsItem';
      case _i22.ScrappableUsageMetrics():
        return 'ScrappableUsageMetrics';
      case _i23.ApiKeyResponse():
        return 'ApiKeyResponse';
      case _i24.CreateScrappableResult():
        return 'CreateScrappableResult';
      case _i24.CreateScrappableThinkingChunk():
        return 'CreateScrappableThinkingChunk';
      case _i25.GroundingMetadataInfo():
        return 'GroundingMetadataInfo';
      case _i26.GroundingSourceInfo():
        return 'GroundingSourceInfo';
      case _i27.SessionPrompt():
        return 'SessionPrompt';
      case _i28.AnonymousIpSpending():
        return 'AnonymousIpSpending';
      case _i29.MarketPlacePaginatedItem():
        return 'MarketPlacePaginatedItem';
      case _i30.PaginatedScrappableResponse():
        return 'PaginatedScrappableResponse';
      case _i31.PaginationMetadata():
        return 'PaginationMetadata';
      case _i32.MonthlyCreditsData():
        return 'MonthlyCreditsData';
      case _i33.ApiKeyUpdatedResponse():
        return 'ApiKeyUpdatedResponse';
      case _i33.CandidateExtractLogicUpdate():
        return 'CandidateExtractLogicUpdate';
      case _i33.CreditLimitReachedResponse():
        return 'CreditLimitReachedResponse';
      case _i33.ErrorTextResponse():
        return 'ErrorTextResponse';
      case _i33.IpLimitReachedResponse():
        return 'IpLimitReachedResponse';
      case _i33.MessageTextResponse():
        return 'MessageTextResponse';
      case _i33.NewExtractRuleResponse():
        return 'NewExtractRuleResponse';
      case _i33.TestEndpointCalledErrorResponse():
        return 'TestEndpointCalledErrorResponse';
      case _i33.TestEndpointCalledSuccessResponse():
        return 'TestEndpointCalledSuccessResponse';
      case _i33.UpdatedScrappableRequestResponse():
        return 'UpdatedScrappableRequestResponse';
      case _i33.UserApiKeyQuotaExceededResponse():
        return 'UserApiKeyQuotaExceededResponse';
      case _i34.CreateSessionResponse():
        return 'CreateSessionResponse';
      case _i35.PromptRole():
        return 'PromptRole';
      case _i36.AiModel():
        return 'AiModel';
      case _i37.AutoFixAttempt():
        return 'AutoFixAttempt';
      case _i38.AutoFixAttemptStatus():
        return 'AutoFixAttemptStatus';
      case _i39.AutoFixConfig():
        return 'AutoFixConfig';
      case _i40.AutoFixSession():
        return 'AutoFixSession';
      case _i41.AutoFixSessionStatus():
        return 'AutoFixSessionStatus';
      case _i42.PaginatedAutoFixSessionResponse():
        return 'PaginatedAutoFixSessionResponse';
      case _i43.ByteTestData():
        return 'ByteTestData';
      case _i44.ReferenceTestData():
        return 'ReferenceTestData';
      case _i45.RequestStatus():
        return 'RequestStatus';
      case _i46.ScraperCategory():
        return 'ScraperCategory';
      case _i47.Scrappable():
        return 'Scrappable';
      case _i48.ScrappableAnalytics():
        return 'ScrappableAnalytics';
      case _i49.ScrappableRequest():
        return 'ScrappableRequest';
      case _i50.ScrappingBeeExtractLogic():
        return 'ScrappingBeeExtractLogic';
      case _i51.UserPaginatedScrappableResponse():
        return 'UserPaginatedScrappableResponse';
      case _i52.ZenScrapException():
        return 'ZenScrapException';
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
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i2.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i3.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'AccountAIUsage') {
      return deserialize<_i4.AccountAIUsage>(data['data']);
    }
    if (dataClassName == 'AICreditHistoryItem') {
      return deserialize<_i5.AICreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionAICreditDeposit') {
      return deserialize<_i6.MonthlySubscriptionAICreditDeposit>(data['data']);
    }
    if (dataClassName == 'PaginatedAICreditHistoryResponse') {
      return deserialize<_i7.PaginatedAICreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i8.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'ApiCreditHistoryItem') {
      return deserialize<_i9.ApiCreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'ApiCreditPackagePurchase') {
      return deserialize<_i10.ApiCreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionApiCreditDeposit') {
      return deserialize<_i11.MonthlySubscriptionApiCreditDeposit>(
        data['data'],
      );
    }
    if (dataClassName == 'PaginatedApiCreditHistoryResponse') {
      return deserialize<_i12.PaginatedApiCreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i13.CreditUsage>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i14.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i15.PlanTier>(data['data']);
    }
    if (dataClassName == 'AnalyticsRequestDetails') {
      return deserialize<_i16.AnalyticsRequestDetails>(data['data']);
    }
    if (dataClassName == 'AnalyticsTimeScope') {
      return deserialize<_i17.AnalyticsTimeScope>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i18.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i19.PaginatedScrappableRequestsAnalytics>(
        data['data'],
      );
    }
    if (dataClassName == 'ScrappableRequestPerTimeScope') {
      return deserialize<_i20.ScrappableRequestPerTimeScope>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i21.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'ScrappableUsageMetrics') {
      return deserialize<_i22.ScrappableUsageMetrics>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i23.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'CreateScrappableResult') {
      return deserialize<_i24.CreateScrappableResult>(data['data']);
    }
    if (dataClassName == 'CreateScrappableThinkingChunk') {
      return deserialize<_i24.CreateScrappableThinkingChunk>(data['data']);
    }
    if (dataClassName == 'GroundingMetadataInfo') {
      return deserialize<_i25.GroundingMetadataInfo>(data['data']);
    }
    if (dataClassName == 'GroundingSourceInfo') {
      return deserialize<_i26.GroundingSourceInfo>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i27.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'AnonymousIpSpending') {
      return deserialize<_i28.AnonymousIpSpending>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i29.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i30.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i31.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i32.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'ApiKeyUpdatedResponse') {
      return deserialize<_i33.ApiKeyUpdatedResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i33.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'CreditLimitReachedResponse') {
      return deserialize<_i33.CreditLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i33.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'IpLimitReachedResponse') {
      return deserialize<_i33.IpLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i33.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i33.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledErrorResponse') {
      return deserialize<_i33.TestEndpointCalledErrorResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledSuccessResponse') {
      return deserialize<_i33.TestEndpointCalledSuccessResponse>(data['data']);
    }
    if (dataClassName == 'UpdatedScrappableRequestResponse') {
      return deserialize<_i33.UpdatedScrappableRequestResponse>(data['data']);
    }
    if (dataClassName == 'UserApiKeyQuotaExceededResponse') {
      return deserialize<_i33.UserApiKeyQuotaExceededResponse>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i34.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i35.PromptRole>(data['data']);
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
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i52.ZenScrapException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i55.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing
/// [Record]s or non-String-keyed [Map]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These
/// handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with
/// non-String keys) or a `Map<String, dynamic>` in case the input was
/// a `Map<String, …>`.
Object? mapContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapContainerToJson(iterable),
      Map map => mapContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          },
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
