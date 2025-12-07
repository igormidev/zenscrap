BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auto_fix_attempt" (
    "id" bigserial PRIMARY KEY,
    "startedAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone,
    "attemptNumber" bigint NOT NULL,
    "succeeded" boolean NOT NULL DEFAULT false,
    "status" bigint NOT NULL DEFAULT 0,
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
-- ACTION CREATE TABLE
--
CREATE TABLE "auto_fix_config" (
    "id" bigserial PRIMARY KEY,
    "enabled" boolean NOT NULL DEFAULT true,
    "consecutiveErrorThreshold" bigint NOT NULL DEFAULT 100,
    "currentConsecutiveErrors" bigint NOT NULL DEFAULT 0,
    "lastAttemptAt" timestamp without time zone,
    "inProgress" boolean NOT NULL DEFAULT false,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "preferredAiModel" bigint,
    "scrappableId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auto_fix_config_scrappable_unique_idx" ON "auto_fix_config" USING btree ("scrappableId");
CREATE INDEX "auto_fix_config_candidates_idx" ON "auto_fix_config" USING btree ("enabled", "inProgress", "currentConsecutiveErrors");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auto_fix_session" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone,
    "status" bigint NOT NULL DEFAULT 0,
    "triggeredAtErrorCount" bigint NOT NULL,
    "configuredThreshold" bigint NOT NULL,
    "usedAiModel" bigint NOT NULL,
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
-- ACTION ALTER TABLE
--
DROP INDEX "scrappable_auto_fix_candidates_idx";
ALTER TABLE "scrappable" DROP COLUMN "autoFixEnabled";
ALTER TABLE "scrappable" DROP COLUMN "consecutiveErrorThreshold";
ALTER TABLE "scrappable" DROP COLUMN "currentConsecutiveErrors";
ALTER TABLE "scrappable" DROP COLUMN "lastAutoFixAttemptAt";
ALTER TABLE "scrappable" DROP COLUMN "autoFixInProgress";
ALTER TABLE "scrappable" DROP COLUMN "autoFixAttemptCount";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auto_fix_attempt"
    ADD CONSTRAINT "auto_fix_attempt_fk_0"
    FOREIGN KEY("sessionId")
    REFERENCES "auto_fix_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auto_fix_config"
    ADD CONSTRAINT "auto_fix_config_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

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
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251207162748993', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251207162748993', "timestamp" = now();

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
