BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "ai_credit_history_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "transactionType" text NOT NULL,
    "monthlySubscriptionAICreditDepositId" bigint,
    "accountAIUsageId" bigint NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "api_credit_history_item" CASCADE;

--
-- ACTION CREATE TABLE
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
    VALUES ('zenscrap', '20251216084401418', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251216084401418', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
