BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AccountAIUsage as table account_ai_usage
--
CREATE TABLE "account_ai_usage" (
    "id" bigserial PRIMARY KEY,
    "userOpenAiApiKey" text,
    "totalDollarsSpentFromTotalInUSD" double precision NOT NULL
);

--
-- Class AccountApiKey as table account_api_key
--
CREATE TABLE "account_api_key" (
    "id" bigserial PRIMARY KEY,
    "apiKey" text NOT NULL,
    "name" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true,
    "accountApiUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "account_api_key_api_key_idx" ON "account_api_key" USING btree ("apiKey");

--
-- Class AccountApiUsage as table account_api_usage
--
CREATE TABLE "account_api_usage" (
    "id" bigserial PRIMARY KEY,
    "nanoId" text NOT NULL,
    "creditUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "credit_usage_id_unique_idx" ON "account_api_usage" USING btree ("creditUsageId");

--
-- Class AccountInfo as table account_info
--
CREATE TABLE "account_info" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "accountApiUsageId" bigint NOT NULL,
    "planTier" bigint NOT NULL,
    "stripeCustomerId" text,
    "stripeSubscriptionId" text,
    "subscriptionStatus" text,
    "subscriptionEndDate" timestamp without time zone,
    "accountAIUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auth_user_id_unique_idx" ON "account_info" USING btree ("authUserId");
CREATE UNIQUE INDEX "account_api_usage_id_unique_idx" ON "account_info" USING btree ("accountApiUsageId");
CREATE UNIQUE INDEX "user_account_ai_usage_id_unique_idx" ON "account_info" USING btree ("accountAIUsageId");

--
-- Class AICreditHistoryItem as table ai_credit_history_item
--
CREATE TABLE "ai_credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "transactionType" text NOT NULL,
    "monthlySubscriptionAICreditDepositId" bigint,
    "accountAIUsageId" bigint NOT NULL
);

--
-- Class AnalyticsRequestDetails as table analytics_request_details
--
CREATE TABLE "analytics_request_details" (
    "id" bigserial PRIMARY KEY,
    "timeStamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" text,
    "description" text,
    "errorObjectAsString" text,
    "errorStackTraceAsString" text,
    "stringifiedPayload" text NOT NULL,
    "stringifiedResponse" text
);

-- Indexes
CREATE INDEX "analytics_request_details_timestamp_idx" ON "analytics_request_details" USING btree ("timeStamp");

--
-- Class AnonymousIpSpending as table anonymous_ip_spending
--
CREATE TABLE "anonymous_ip_spending" (
    "id" bigserial PRIMARY KEY,
    "ipAddress" text NOT NULL,
    "totalSpentUsd" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "anonymous_ip_spending_ip_idx" ON "anonymous_ip_spending" USING btree ("ipAddress");
CREATE INDEX "anonymous_ip_spending_created_at_idx" ON "anonymous_ip_spending" USING btree ("createdAt");

--
-- Class ApiCreditHistoryItem as table api_credit_history_item
--
CREATE TABLE "api_credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "transactionType" text NOT NULL,
    "monthlySubscriptionApiCreditDepositId" bigint,
    "apiCreditPackagePurchaseId" bigint,
    "accountApiUsageId" bigint NOT NULL
);

--
-- Class ApiCreditPackagePurchase as table api_credit_package_purchase
--
CREATE TABLE "api_credit_package_purchase" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL,
    "stripePurchaseId" text
);

--
-- Class AutoFixAttempt as table auto_fix_attempt
--
CREATE TABLE "auto_fix_attempt" (
    "id" bigserial PRIMARY KEY,
    "startedAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone,
    "attemptNumber" bigint NOT NULL,
    "succeeded" boolean NOT NULL DEFAULT false,
    "status" text NOT NULL DEFAULT 'in_progress'::text,
    "errorMessage" text,
    "aiThinkingLog" text,
    "generatedExtractRules" text,
    "generatedJsScenario" text,
    "validationPassed" boolean,
    "validationError" text,
    "costUsd" double precision NOT NULL DEFAULT 0.0,
    "inputTokens" bigint NOT NULL DEFAULT 0,
    "outputTokens" bigint NOT NULL DEFAULT 0,
    "reasoningTokens" bigint NOT NULL DEFAULT 0,
    "sessionId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "auto_fix_attempt_session_idx" ON "auto_fix_attempt" USING btree ("sessionId");
CREATE INDEX "auto_fix_attempt_status_idx" ON "auto_fix_attempt" USING btree ("status", "startedAt");

--
-- Class AutoFixConfig as table auto_fix_config
--
CREATE TABLE "auto_fix_config" (
    "id" bigserial PRIMARY KEY,
    "enabled" boolean NOT NULL DEFAULT true,
    "consecutiveErrorThreshold" bigint NOT NULL DEFAULT 100,
    "currentConsecutiveErrors" bigint NOT NULL DEFAULT 0,
    "lastAttemptAt" timestamp without time zone,
    "inProgress" boolean NOT NULL DEFAULT false,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "preferredAiModel" text,
    "scrappableId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auto_fix_config_scrappable_unique_idx" ON "auto_fix_config" USING btree ("scrappableId");
CREATE INDEX "auto_fix_config_candidates_idx" ON "auto_fix_config" USING btree ("enabled", "inProgress", "currentConsecutiveErrors");

--
-- Class AutoFixSession as table auto_fix_session
--
CREATE TABLE "auto_fix_session" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "triggeredAtErrorCount" bigint NOT NULL,
    "configuredThreshold" bigint NOT NULL,
    "usedAiModel" text NOT NULL,
    "usedUserApiKey" boolean NOT NULL DEFAULT false,
    "successSummary" text,
    "failureReason" text,
    "totalCostUsd" double precision NOT NULL DEFAULT 0.0,
    "totalInputTokens" bigint NOT NULL DEFAULT 0,
    "totalOutputTokens" bigint NOT NULL DEFAULT 0,
    "scrappableId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "auto_fix_session_scrappable_idx" ON "auto_fix_session" USING btree ("scrappableId");
CREATE INDEX "auto_fix_session_status_idx" ON "auto_fix_session" USING btree ("status", "createdAt");

--
-- Class ByteTestData as table byte_test_data
--
CREATE TABLE "byte_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceHtmlPage" bytea NOT NULL,
    "referenceSiteScreenshot" bytea NOT NULL
);

--
-- Class CreditUsage as table credit_usage
--
CREATE TABLE "credit_usage" (
    "id" bigserial PRIMARY KEY,
    "subscriptionCredits" bigint NOT NULL,
    "purchasedCredits" bigint NOT NULL
);

--
-- Class MonthlySubscriptionAICreditDeposit as table monthly_subscription_ai_credit_deposit
--
CREATE TABLE "monthly_subscription_ai_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "creditsAmountInDollars" double precision NOT NULL,
    "planTier" bigint NOT NULL
);

--
-- Class MonthlySubscriptionApiCreditDeposit as table monthly_subscription_api_credit_deposit
--
CREATE TABLE "monthly_subscription_api_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "creditsAmount" bigint NOT NULL,
    "planTier" bigint NOT NULL
);

--
-- Class Scrappable as table scrappable
--
CREATE TABLE "scrappable" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint,
    "apiUsageOwnerNanoId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "generalInfosUpdatedAt" timestamp without time zone NOT NULL,
    "extractRulesUpdatedAt" timestamp without time zone NOT NULL,
    "name" text NOT NULL,
    "nameLanguage" text,
    "description" text NOT NULL,
    "descriptionLanguage" text,
    "testEndpointAvailableUntil" timestamp without time zone,
    "willHideFromMarketplace" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL,
    "category" text NOT NULL,
    "isDeleted" boolean NOT NULL,
    "averageDurationInfoId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

--
-- Class ScrappableAnalytics as table scrappable_analytics
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" text NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "attachedNanoId" text NOT NULL,
    "attachedApiKey" text NOT NULL,
    "scrappableId" bigint NOT NULL,
    "detailsId" bigint,
    "apiKeyId" bigint,
    "duration" bigint
);

-- Indexes
CREATE INDEX "scrappable_analytics_scrappable_id_idx" ON "scrappable_analytics" USING btree ("scrappableId");
CREATE INDEX "scrappable_analytics_attached_nanoid_idx" ON "scrappable_analytics" USING btree ("attachedNanoId");
CREATE INDEX "scrappable_analytics_attached_apikey_idx" ON "scrappable_analytics" USING btree ("attachedApiKey");
CREATE INDEX "scrappable_analytics_scrappable_requested_status_idx" ON "scrappable_analytics" USING btree ("scrappableId", "requestedAt", "requestStatus");

--
-- Class ScrappableAverageDuration as table scrappable_average_duration
--
CREATE TABLE "scrappable_average_duration" (
    "id" bigserial PRIMARY KEY,
    "updatedAt" timestamp without time zone NOT NULL,
    "averageDuration" bigint NOT NULL
);

--
-- Class ScrappableRequest as table scrappable_target_request
--
CREATE TABLE "scrappable_target_request" (
    "id" bigserial PRIMARY KEY,
    "url" text NOT NULL,
    "queryParams" json NOT NULL,
    "queryParamsNotRelatedToUrl" json NOT NULL,
    "pathParams" json NOT NULL
);

--
-- Class ReferenceTestData as table scrappable_test_data
--
CREATE TABLE "scrappable_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceLinkUsed" text NOT NULL,
    "referenceQueryParametersJson" text NOT NULL,
    "scrapResultJson" text,
    "byteDataId" bigint
);

--
-- Class ScrappingBeeExtractLogic as table scrapping_bee_extract_logic
--
CREATE TABLE "scrapping_bee_extract_logic" (
    "id" bigserial PRIMARY KEY,
    "scrappableId" bigint,
    "extractRules" text NOT NULL,
    "jsScenario" text,
    "renderJs" boolean NOT NULL,
    "wait" bigint,
    "waitFor" text,
    "waitBrowser" text,
    "premiumProxy" boolean NOT NULL,
    "stealthProxy" boolean NOT NULL,
    "countryCode" text,
    "sessionId" text,
    "customGoogle" boolean
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_id_idx" ON "scrapping_bee_extract_logic" USING btree ("scrappableId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_domain" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain");
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_source" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("source");
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_nonce" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("nonce");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "account_api_key" table
--
ALTER TABLE ONLY "account_api_key"
    ADD CONSTRAINT "account_api_key_fk_0"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "account_api_usage" table
--
ALTER TABLE ONLY "account_api_usage"
    ADD CONSTRAINT "account_api_usage_fk_0"
    FOREIGN KEY("creditUsageId")
    REFERENCES "credit_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "account_info" table
--
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_1"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_2"
    FOREIGN KEY("accountAIUsageId")
    REFERENCES "account_ai_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "ai_credit_history_item" table
--
ALTER TABLE ONLY "ai_credit_history_item"
    ADD CONSTRAINT "ai_credit_history_item_fk_0"
    FOREIGN KEY("monthlySubscriptionAICreditDepositId")
    REFERENCES "monthly_subscription_ai_credit_deposit"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_credit_history_item"
    ADD CONSTRAINT "ai_credit_history_item_fk_1"
    FOREIGN KEY("accountAIUsageId")
    REFERENCES "account_ai_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "api_credit_history_item" table
--
ALTER TABLE ONLY "api_credit_history_item"
    ADD CONSTRAINT "api_credit_history_item_fk_0"
    FOREIGN KEY("monthlySubscriptionApiCreditDepositId")
    REFERENCES "monthly_subscription_api_credit_deposit"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "api_credit_history_item"
    ADD CONSTRAINT "api_credit_history_item_fk_1"
    FOREIGN KEY("apiCreditPackagePurchaseId")
    REFERENCES "api_credit_package_purchase"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "api_credit_history_item"
    ADD CONSTRAINT "api_credit_history_item_fk_2"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "auto_fix_attempt" table
--
ALTER TABLE ONLY "auto_fix_attempt"
    ADD CONSTRAINT "auto_fix_attempt_fk_0"
    FOREIGN KEY("sessionId")
    REFERENCES "auto_fix_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "auto_fix_config" table
--
ALTER TABLE ONLY "auto_fix_config"
    ADD CONSTRAINT "auto_fix_config_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "auto_fix_session" table
--
ALTER TABLE ONLY "auto_fix_session"
    ADD CONSTRAINT "auto_fix_session_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "scrappable" table
--
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "account_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_1"
    FOREIGN KEY("targetRequestId")
    REFERENCES "scrappable_target_request"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_2"
    FOREIGN KEY("referenceTestDataId")
    REFERENCES "scrappable_test_data"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_3"
    FOREIGN KEY("averageDurationInfoId")
    REFERENCES "scrappable_average_duration"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "scrappable_analytics" table
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_1"
    FOREIGN KEY("detailsId")
    REFERENCES "analytics_request_details"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_2"
    FOREIGN KEY("apiKeyId")
    REFERENCES "account_api_key"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "scrappable_test_data" table
--
ALTER TABLE ONLY "scrappable_test_data"
    ADD CONSTRAINT "scrappable_test_data_fk_0"
    FOREIGN KEY("byteDataId")
    REFERENCES "byte_test_data"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "scrapping_bee_extract_logic" table
--
ALTER TABLE ONLY "scrapping_bee_extract_logic"
    ADD CONSTRAINT "scrapping_bee_extract_logic_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251220090354614', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251220090354614', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
