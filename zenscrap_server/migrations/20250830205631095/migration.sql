BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "byte_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceHtmlPage" bytea NOT NULL,
    "referenceSiteScreenshot" bytea NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_test_data" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_test_data" (
    "id" bigserial PRIMARY KEY,
    "referenceLinkUsed" text NOT NULL,
    "referenceQueryParametersJson" text NOT NULL,
    "byteDataId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "reference_test_data_byte_data_id_idx" ON "scrappable_test_data" USING btree ("byteDataId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_test_data"
    ADD CONSTRAINT "scrappable_test_data_fk_0"
    FOREIGN KEY("byteDataId")
    REFERENCES "byte_test_data"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250830205631095', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250830205631095', "timestamp" = now();

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
