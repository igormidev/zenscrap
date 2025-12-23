BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ip_validation_cache" (
    "id" bigserial PRIMARY KEY,
    "ipAddress" text NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "isLegitimate" boolean NOT NULL,
    "blockReason" text,
    "isVpn" boolean NOT NULL,
    "isProxy" boolean NOT NULL,
    "isTor" boolean NOT NULL,
    "isDatacenter" boolean NOT NULL,
    "isAbuser" boolean NOT NULL,
    "isCrawler" boolean NOT NULL,
    "isMobile" boolean NOT NULL,
    "companyName" text,
    "companyType" text,
    "countryCode" text,
    "city" text
);

-- Indexes
CREATE UNIQUE INDEX "ip_validation_cache_ip_address_unique_idx" ON "ip_validation_cache" USING btree ("ipAddress");
CREATE INDEX "ip_validation_cache_updated_at_idx" ON "ip_validation_cache" USING btree ("updatedAt");


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251223122045169', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251223122045169', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
