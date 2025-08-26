BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "account_api_key" ADD COLUMN "isActive" boolean NOT NULL DEFAULT true;
--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_analytics" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" bigint NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "attachedNanoId" text NOT NULL,
    "attachedApiKey" text NOT NULL,
    "scrappableId" uuid NOT NULL
);

-- Indexes
CREATE INDEX "scrappable_analytics_attached_nanoid_idx" ON "scrappable_analytics" USING btree ("attachedNanoId");
CREATE INDEX "scrappable_analytics_attached_apikey_idx" ON "scrappable_analytics" USING btree ("attachedApiKey");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250826031713755', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250826031713755', "timestamp" = now();

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
