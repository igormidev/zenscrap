BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "scrappingRules" text NOT NULL,
    "isActive" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_target_request" (
    "id" bigserial PRIMARY KEY,
    "url" text NOT NULL,
    "queryParams" json NOT NULL,
    "pathParams" json NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_0"
    FOREIGN KEY("targetRequestId")
    REFERENCES "scrappable_target_request"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250812143101052', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250812143101052', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
