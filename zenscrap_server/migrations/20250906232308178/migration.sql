BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "account_api_usage" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_api_usage" (
    "id" bigserial PRIMARY KEY,
    "nanoId" text NOT NULL,
    "creditUsageId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "credit_usage_id_unique_idx" ON "account_api_usage" USING btree ("creditUsageId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "credit_usage" (
    "id" bigserial PRIMARY KEY,
    "subscriptionCredits" bigint NOT NULL,
    "purchasedCredits" bigint NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "monthly_subscription_credit_deposit" DROP COLUMN "currency";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_api_usage"
    ADD CONSTRAINT "account_api_usage_fk_0"
    FOREIGN KEY("creditUsageId")
    REFERENCES "credit_usage"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250906232308178', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250906232308178', "timestamp" = now();

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
