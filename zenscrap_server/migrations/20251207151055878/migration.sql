BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable" ADD COLUMN "autoFixEnabled" boolean NOT NULL DEFAULT true;
ALTER TABLE "scrappable" ADD COLUMN "consecutiveErrorThreshold" bigint NOT NULL DEFAULT 100;
ALTER TABLE "scrappable" ADD COLUMN "currentConsecutiveErrors" bigint NOT NULL DEFAULT 0;
ALTER TABLE "scrappable" ADD COLUMN "lastAutoFixAttemptAt" timestamp without time zone;
ALTER TABLE "scrappable" ADD COLUMN "autoFixInProgress" boolean NOT NULL DEFAULT false;
CREATE INDEX "scrappable_auto_fix_candidates_idx" ON "scrappable" USING btree ("autoFixEnabled", "autoFixInProgress", "currentConsecutiveErrors");

--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251207151055878', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251207151055878', "timestamp" = now();

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
