BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "scrapping_bee_extract_logic" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrapping_bee_extract_logic" (
    "id" bigserial PRIMARY KEY,
    "scrappableId" bigint,
    "extractRules" text NOT NULL,
    "jsScenario" text,
    "renderJs" boolean NOT NULL,
    "wait" bigint,
    "waitFor" text,
    "waitBrowser" text,
    "premiumProxy" boolean NOT NULL,
    "stealthProxy" boolean NOT NULL,
    "countryCode" text,
    "sessionId" text,
    "customGoogle" boolean
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_id_idx" ON "scrapping_bee_extract_logic" USING btree ("scrappableId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrapping_bee_extract_logic"
    ADD CONSTRAINT "scrapping_bee_extract_logic_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250928230043956', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250928230043956', "timestamp" = now();

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
