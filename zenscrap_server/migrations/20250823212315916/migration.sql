BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "account_api_key" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_api_key" (
    "id" bigserial PRIMARY KEY,
    "apiKey" text NOT NULL,
    "name" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "accountApiUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "account_api_key_api_key_idx" ON "account_api_key" USING btree ("apiKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_api_usage" (
    "id" bigserial PRIMARY KEY,
    "nanoId" text NOT NULL,
    "subscriptionCredits" bigint NOT NULL,
    "purchasedCredits" bigint NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "account_info" CASCADE;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "monthlySubscriptionCreditDepositId" bigint,
    "creaditPackagePurchaseId" bigint,
    "accountApiUsageId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "credit_package_purchase" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL,
    "stripePurchaseId" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "monthly_subscription_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "accountId" bigint,
    "apiUsageOwnerNanoId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "isPrivate" boolean NOT NULL,
    "testEndpointAvailableUntil" timestamp without time zone,
    "scrappingRules" text,
    "isActive" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" bigint NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "scrappableId" uuid NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_api_key"
    ADD CONSTRAINT "account_api_key_fk_0"
    FOREIGN KEY("accountApiUsageId")
    REFERENCES "account_api_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250823212315916', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250823212315916', "timestamp" = now();

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
