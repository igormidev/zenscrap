BEGIN;

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
    "subscriptionCredits" bigint NOT NULL,
    "purchasedCredits" bigint NOT NULL
);

--
-- Class AccountInfo as table account_info
--
CREATE TABLE "account_info" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "accountApiUsageId" bigint NOT NULL,
    "planTier" bigint NOT NULL,
    "stripeCustomerId" text,
    "stripeSubscriptionId" text,
    "subscriptionStatus" text,
    "subscriptionEndDate" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_info_id_unique_idx" ON "account_info" USING btree ("userInfoId");
CREATE UNIQUE INDEX "account_api_usage_id_unique_idx" ON "account_info" USING btree ("accountApiUsageId");

--
-- Class ByteTestData as table byte_test_data
--
CREATE TABLE "byte_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceHtmlPage" bytea NOT NULL,
    "referenceSiteScreenshot" bytea NOT NULL
);

--
-- Class CreditHistoryItem as table credit_history_item
--
CREATE TABLE "credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "monthlySubscriptionCreditDepositId" bigint,
    "creaditPackagePurchaseId" bigint,
    "accountApiUsageId" bigint NOT NULL
);

--
-- Class CreditPackagePurchase as table credit_package_purchase
--
CREATE TABLE "credit_package_purchase" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL,
    "stripePurchaseId" text
);

--
-- Class MonthlySubscriptionCreditDeposit as table monthly_subscription_credit_deposit
--
CREATE TABLE "monthly_subscription_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL
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
    "description" text NOT NULL,
    "testEndpointAvailableUntil" timestamp without time zone,
    "scrappingRules" text,
    "willHideFromMarketplace" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL,
    "category" bigint NOT NULL,
    "isDeleted" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

--
-- Class ScrappableAnalytics as table scrappable_analytics
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" bigint NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "attachedNanoId" text NOT NULL,
    "attachedApiKey" text NOT NULL,
    "scrappableId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "scrappable_analytics_attached_nanoid_idx" ON "scrappable_analytics" USING btree ("attachedNanoId");
CREATE INDEX "scrappable_analytics_attached_apikey_idx" ON "scrappable_analytics" USING btree ("attachedApiKey");

--
-- Class ScrappableRequest as table scrappable_target_request
--
CREATE TABLE "scrappable_target_request" (
    "id" bigserial PRIMARY KEY,
    "url" text NOT NULL,
    "queryParams" json NOT NULL,
    "pathParams" json NOT NULL
);

--
-- Class ReferenceTestData as table scrappable_test_data
--
CREATE TABLE "scrappable_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceLinkUsed" text NOT NULL,
    "referenceQueryParametersJson" text NOT NULL,
    "byteDataId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "reference_test_data_byte_data_id_idx" ON "scrappable_test_data" USING btree ("byteDataId");

--
-- Class ScrappableTestResult as table scrappable_test_result
--
CREATE TABLE "scrappable_test_result" (
    "id" bigserial PRIMARY KEY,
    "testExtractRule" text NOT NULL,
    "extractJsonResult" text NOT NULL,
    "scrappableId" bigint NOT NULL,
    "referenceTestDataId" bigint
);

-- Indexes
CREATE INDEX "scrappable_id_idx" ON "scrappable_test_result" USING btree ("scrappableId");
CREATE UNIQUE INDEX "reference_test_data_unique_idx" ON "scrappable_test_result" USING btree ("referenceTestDataId");

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
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AuthKey as table serverpod_auth_key
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- Class EmailAuth as table serverpod_email_auth
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- Class EmailReset as table serverpod_email_reset
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- Class UserInfo as table serverpod_user_info
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

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
-- Foreign relations for "account_info" table
--
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_1"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "credit_history_item" table
--
ALTER TABLE ONLY "credit_history_item"
    ADD CONSTRAINT "credit_history_item_fk_0"
    FOREIGN KEY("monthlySubscriptionCreditDepositId")
    REFERENCES "monthly_subscription_credit_deposit"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "credit_history_item"
    ADD CONSTRAINT "credit_history_item_fk_1"
    FOREIGN KEY("creaditPackagePurchaseId")
    REFERENCES "credit_package_purchase"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "credit_history_item"
    ADD CONSTRAINT "credit_history_item_fk_2"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
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

--
-- Foreign relations for "scrappable_analytics" table
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
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
-- Foreign relations for "scrappable_test_result" table
--
ALTER TABLE ONLY "scrappable_test_result"
    ADD CONSTRAINT "scrappable_test_result_fk_0"
    FOREIGN KEY("referenceTestDataId")
    REFERENCES "scrappable_test_data"("id")
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
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250903182043681', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250903182043681', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
