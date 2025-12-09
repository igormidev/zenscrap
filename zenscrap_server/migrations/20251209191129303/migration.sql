BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "auto_fix_attempt" DROP COLUMN "status";
ALTER TABLE "auto_fix_attempt" ADD COLUMN "status" text NOT NULL DEFAULT 'in_progress'::text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "auto_fix_config" DROP COLUMN "preferredAiModel";
ALTER TABLE "auto_fix_config" ADD COLUMN "preferredAiModel" text;
--
-- ACTION DROP TABLE
--
DROP TABLE "auto_fix_session" CASCADE;

--
-- ACTION CREATE TABLE
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
-- ACTION DROP TABLE
--
DROP TABLE "scrappable" CASCADE;

--
-- ACTION CREATE TABLE
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
    "willHideFromMarketplace" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL,
    "category" text NOT NULL,
    "isDeleted" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_analytics" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" text NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "attachedNanoId" text NOT NULL,
    "attachedApiKey" text NOT NULL,
    "scrappableId" bigint NOT NULL,
    "detailsId" bigint
);

-- Indexes
CREATE INDEX "scrappable_analytics_attached_nanoid_idx" ON "scrappable_analytics" USING btree ("attachedNanoId");
CREATE INDEX "scrappable_analytics_attached_apikey_idx" ON "scrappable_analytics" USING btree ("attachedApiKey");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auto_fix_session"
    ADD CONSTRAINT "auto_fix_session_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
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
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_1"
    FOREIGN KEY("detailsId")
    REFERENCES "analytics_request_details"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251209191129303', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251209191129303', "timestamp" = now();

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
