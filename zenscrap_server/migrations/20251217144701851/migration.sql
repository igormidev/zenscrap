BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable" ADD COLUMN "averageDurationInfoId" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable_analytics" ADD COLUMN "duration" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_average_duration" (
    "id" bigserial PRIMARY KEY,
    "updatedAt" timestamp without time zone NOT NULL,
    "averageDuration" bigint NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_3"
    FOREIGN KEY("averageDurationInfoId")
    REFERENCES "scrappable_average_duration"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251217144701851', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251217144701851', "timestamp" = now();

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
