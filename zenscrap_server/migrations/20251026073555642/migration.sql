BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "analytics_request_details" (
    "id" bigserial PRIMARY KEY,
    "timeStamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" text,
    "description" text,
    "errorObjectAsString" text,
    "errorStackTraceAsString" text,
    "stringifiedPayload" text NOT NULL
);

-- Indexes
CREATE INDEX "analytics_request_details_timestamp_idx" ON "analytics_request_details" USING btree ("timeStamp");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable_analytics" ADD COLUMN "detailsId" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
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
    VALUES ('zenscrap', '20251026073555642', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251026073555642', "timestamp" = now();

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
