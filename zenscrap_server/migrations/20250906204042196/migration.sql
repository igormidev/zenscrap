BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "credit_history_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "credit_history_item" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "monthlySubscriptionCreditDepositId" bigint,
    "creaditPackagePurchaseId" bigint,
    "accountApiUsageId" bigint NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "monthly_subscription_credit_deposit" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "monthly_subscription_credit_deposit" (
    "id" bigserial PRIMARY KEY,
    "creditsAmount" bigint NOT NULL,
    "currency" text,
    "planTier" bigint NOT NULL
);

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
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250906204042196', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250906204042196', "timestamp" = now();

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
