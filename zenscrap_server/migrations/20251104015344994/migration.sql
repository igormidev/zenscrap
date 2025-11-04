BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_target_request" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_target_request" (
    "id" bigserial PRIMARY KEY,
    "url" text NOT NULL,
    "queryParams" json NOT NULL,
    "queryParamsNotRelatedToUrl" json NOT NULL,
    "pathParams" json NOT NULL
);


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251104015344994', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251104015344994', "timestamp" = now();

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
