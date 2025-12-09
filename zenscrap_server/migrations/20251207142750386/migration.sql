BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "monthly_subscription_credit_deposit" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "credit_package_purchase" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "credit_history_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_ai_usage" (
    "id" bigserial PRIMARY KEY,
    "userOpenAiApiKey" text,
    "totalDollarsSpentFromTotalInUSD" double precision NOT NULL
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
    "subscriptionEndDate" timestamp without time zone,
    "accountAIUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_info_id_unique_idx" ON "account_info" USING btree ("userInfoId");
CREATE UNIQUE INDEX "account_api_usage_id_unique_idx" ON "account_info" USING btree ("accountApiUsageId");
CREATE UNIQUE INDEX "user_account_ai_usage_id_unique_idx" ON "account_info" USING btree ("accountAIUsageId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "monthlySubscriptionAICreditDepositId" bigint,
    "accountAIUsageId" bigint NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "analytics_request_details" ADD COLUMN "stringifiedResponse" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "api_credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "monthlySubscriptionApiCreditDepositId" bigint,
    "apiCreditPackagePurchaseId" bigint,
    "accountApiUsageId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "api_credit_package_purchase" (
    "id" bigserial PRIMARY KEY,
    "value" double precision NOT NULL,
    "stripePurchaseId" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "monthly_subscription_ai_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "creditsAmountInDollars" double precision NOT NULL,
    "planTier" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "monthly_subscription_api_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "creditsAmount" bigint NOT NULL,
    "planTier" bigint NOT NULL
);

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
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_2"
    FOREIGN KEY("accountAIUsageId")
    REFERENCES "account_ai_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251207142750386', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251207142750386', "timestamp" = now();

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
