BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scrappable_analytics" ADD COLUMN "apiKeyId" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_2"
    FOREIGN KEY("apiKeyId")
    REFERENCES "account_api_key"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251217132618742', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251217132618742', "timestamp" = now();

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
