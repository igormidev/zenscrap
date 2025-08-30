BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable" ALTER COLUMN "isDeleted" SET NOT NULL;
ALTER TABLE "scrappable" ALTER COLUMN "isDeleted" DROP DEFAULT;

--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250830030113576', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250830030113576', "timestamp" = now();

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
