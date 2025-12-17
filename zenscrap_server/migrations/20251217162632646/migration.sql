BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "scrappable_analytics_scrappable_requested_status_idx" ON "scrappable_analytics" USING btree ("scrappableId", "requestedAt", "requestStatus");

--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251217162632646', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251217162632646', "timestamp" = now();

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
